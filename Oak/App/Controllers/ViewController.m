//
//  ViewController.m
//  Oak
//
//  Created by t-matsumura on 5/15/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "ViewController.h"
#import <GTMOAuth2ViewControllerTouch.h>
#import <GTLCalendar.h>
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "OAKJSONLoader.h"
#import "OAKGoogleClientSecret.h"
#import "OAKDayCell.h"
#import "NSDate+Monthly.h"
#import "OAKEventBuilder.h"
#import "OAKQueryFactory.h"
#import "OAKEvents.h"
#import "MenuViewController.h"
#import "OAKCalendarService.h"

NSString * const KEYCHAIN_NAME = @"Oak";
NSString * const DayCellIdentifier = @"OAKDayCell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *calendarID;

@property (nonatomic) NSArray *dates;
@property (nonatomic) OAKEvents *events;

@property (nonatomic) OAKCalendarService *calendarService;

@end

@implementation ViewController

- (instancetype)initWithCalendarID:(NSString *)calendarID {
    self = [super init];
    if (self) {
        self.calendarID = calendarID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *today = [NSDate date];
    self.dates = [NSDate datesBetween:today.beginningOfMonth and:today.endOfMonth];
    self.events = [[OAKEvents alloc] init];
    
    self.calendarService = [OAKCalendarService sharedService];

    [self.tableView registerNib:[UINib nibWithNibName:DayCellIdentifier bundle:nil] forCellReuseIdentifier:DayCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks handler:^(id sender) {
        MenuViewController *menu = (MenuViewController *) self.navigationController;
        [menu toggleMenu];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.calendarService.isAuthorized) {
        UIViewController *authorizer = [self.calendarService createAuthorizerWithCompletionHandler:^{
            [self viewDidAuthorize];
        } failure:^(NSError *error) {
            [self showAlert:@"Failed to authenticate" message:error.localizedDescription];
        }];
        
        [self presentViewController:authorizer animated:YES completion:nil];
    }
    
    [self viewDidAuthorize];
}

- (void)viewDidAuthorize {
    [self fetchEvents];
}

#pragma mark - Actions

- (void)fetchEvents {
    [self showProgress:@"Receiving..."];
    
    OAKQueryFactory *factory = [OAKQueryFactory factoryWithCalendarID:self.calendarID];
    GTLQueryCalendar *query = [factory createIndexQueryWithMonth:[NSDate date]];
    [self.calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLCalendarEvents *fetched, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to fetch events with error: %@", error.localizedDescription);
            
            [self dismissProgressWithError];
            return;
        }
        
        self.events = [[OAKEvents alloc] initWithCalendarEvents:fetched];
        [self.tableView reloadData];
        [self dismissProgressWithSuccess];
    }];
}

- (void)postEventWithDate:(NSDate *)date period:(NSArray *)period {
    [self showProgress:@"Creating..."];
    
    OAKEventBuilder *builder = [OAKEventBuilder builder];
    
    GTLCalendarEvent *event = [[[[builder setSummary:@"OakFood"]
                                          setStartDate:period.firstObject]
                                          setEndDate:period.lastObject]
                                          build];
    
    OAKQueryFactory *factory = [OAKQueryFactory factoryWithCalendarID:self.calendarID];
    GTLQueryCalendar *query = [factory createCreateQueryWithEvent:event];
    
    [self.calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLCalendarEvent *created, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to post event with error: %@", error.localizedDescription);
            
            [self dismissProgressWithError];
            return;
        }
        
        [self.events add:created];
        [self.tableView reloadData];
        [self dismissProgressWithSuccess];
    }];
}

- (void)updateEvent:(GTLCalendarEvent *)existing withDate:(NSDate *)date period:(NSArray *)period {
    [self showProgress:@"Updating..."];
    
    OAKEventBuilder *builder = [OAKEventBuilder builder];
    
    GTLCalendarEvent *event = [[[[builder setSummary:@"OakFood"]
                                          setStartDate:period.firstObject]
                                          setEndDate:period.lastObject]
                                          build];
    
    OAKQueryFactory *factory = [OAKQueryFactory factoryWithCalendarID:self.calendarID];
    GTLQueryCalendar *query = [factory createUpdateQueryWithEvent:event where:existing.identifier];
    
    [self.calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLCalendarEvent *updated, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to update event with error: %@", error.localizedDescription);
            
            [self dismissProgressWithError];
            return;
        }
        
        [self.events replace:existing with:updated];
        [self.tableView reloadData];
        [self dismissProgressWithSuccess];
    }];
}

- (void)deleteEventWithId:(NSString *)eventId {
    [self showProgress:@"Deleting..."];
    
    OAKQueryFactory *factory = [OAKQueryFactory factoryWithCalendarID:self.calendarID];
    GTLQueryCalendar *query = [factory createDeleteQueryWithEventId:eventId];
    
    [self.calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to delete event with error: %@", error.localizedDescription);
            
            [self dismissProgressWithError];
            return;
        }
        
        [self.events removeWithId:eventId];
        [self.tableView reloadData];
        [self dismissProgressWithSuccess];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = self.dates[indexPath.row];
    
    OAKDayCell *cell = [tableView dequeueReusableCellWithIdentifier:DayCellIdentifier forIndexPath:indexPath];
    [cell setDate:date];
    
    [cell setEvents:[self.events itemsAtDay:date]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block NSDate *date = self.dates[indexPath.row];
    
    NSArray *selectablePeriods = @[
        @[[date addHour:5], [date addHour:9]],
        @[[date addHour:5], [date addHour:14]],
        @[[date addHour:7], [date addHour:14]],
        @[[date addHour:8], [date addHour:14]]
    ];
    
    NSArray *selectableStrings = [selectablePeriods bk_map:^NSString *(NSArray *period) {
        NSDate *beginning = period.firstObject;
        NSDate *end = period.lastObject;
        return [NSString stringWithFormat:@"%ld:00 ~ %ld:00", (long)beginning.hour, (long)end.hour];
    }];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Events"
                                            rows:selectableStrings
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, NSString *selectedValue) {
                                           NSArray *events = [self.events itemsWithSummary:@"OakFood" atDay:date];
                                           
                                           GTLCalendarEvent *matched = events.firstObject;
                                           if (matched != nil) {
                                               [self updateEvent:matched withDate:date period:selectablePeriods[selectedIndex]];
                                               return;
                                           }
                                           
                                           [self postEventWithDate:date period:selectablePeriods[selectedIndex]];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
                                         if (selectedIndexPath == nil) {
                                             return;
                                         }
                                         [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
                                     }
                                          origin:self.view];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = self.dates[indexPath.row];
    NSArray *events = [self.events itemsWithSummary:@"OakFood" atDay:date];
    
    return events.count > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __block NSDate *date = self.dates[indexPath.row];
        
        NSArray *events = [self.events itemsWithSummary:@"OakFood" atDay:date];
        
        GTLCalendarEvent *matched = events.firstObject;
        if (matched != nil) {
            [self deleteEventWithId:matched.identifier];
            return;
        }
    }
    
    [tableView reloadData];
}

#pragma mark - View Helpers

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

- (void)showProgress:(NSString *)title {
    [SVProgressHUD showWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
}

- (void)dismissProgressWithSuccess {
    [SVProgressHUD showSuccessWithStatus:@"Success"];
}

- (void)dismissProgressWithError {
    [SVProgressHUD showErrorWithStatus:@"Failed"];
}

- (void)dismissProgress {
    [SVProgressHUD dismiss];
}

- (void)setEvents:(OAKEvents *)events {
    _events = events;
    self.title = events == nil ? @"Events" : events.summary;
}

@end
