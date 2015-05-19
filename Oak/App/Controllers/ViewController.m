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
#import "OAKJSONLoader.h"
#import "OAKGoogleClientSecret.h"
#import "OAKDayCell.h"
#import "NSDate+Monthly.h"

NSString * const KEYCHAIN_NAME = @"Oak";
NSString * const DayCellIdentifier = @"OAKDayCell";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *dates;
@property (nonatomic) GTLCalendarEvents *calendarEvents;

@property (nonatomic) GTLServiceCalendar *calendarService;
@property (nonatomic, copy, readonly) OAKGoogleClientSecret *secret;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *today = [NSDate date];
    self.dates = [NSDate datesBetween:today.beginningOfMonth and:today.endOfMonth];
    self.calendarEvents = [[GTLCalendarEvents alloc] init];
    
    NSDictionary *secretJSON = [OAKJSONLoader loadJSONForPath:@"client_secret"];
    _secret = [[OAKGoogleClientSecret alloc] initWithJSON:secretJSON];
    
    self.calendarService = [[GTLServiceCalendar alloc] init];
    self.calendarService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:KEYCHAIN_NAME
                                                                                            clientID:self.secret.clientID
                                                                                        clientSecret:self.secret.clientSecret];

    [self.tableView registerNib:[UINib nibWithNibName:DayCellIdentifier bundle:nil] forCellReuseIdentifier:DayCellIdentifier];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (![self.calendarService.authorizer canAuthorize]) {
        UIViewController *authViewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeCalendar
                                                                                          clientID:self.secret.clientID
                                                                                      clientSecret:self.secret.clientSecret
                                                                                  keychainItemName:KEYCHAIN_NAME
                                                                                          delegate:self
                                                                                  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        [self presentViewController:authViewController animated:YES completion:nil];
        return;
    }
    
    [self fetchEvents];
}

#pragma mark - Actions

- (void)fetchEvents {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"primary"];
    query.timeMin = [GTLDateTime dateTimeWithDate:[[NSDate date] beginningOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    query.timeMax = [GTLDateTime dateTimeWithDate:[[NSDate date] endOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    [self.calendarService executeQuery:query
                              delegate:self
                     didFinishSelector:@selector(serviceTicket:finishedWithObject:error:)];
}

- (void)postEventWithDate:(NSDate *)date period:(NSArray *)period {
    GTLCalendarEvent *event = [[GTLCalendarEvent alloc] init];
    
    GTLCalendarEventDateTime *startDateTime = [[GTLCalendarEventDateTime alloc] init];
    startDateTime.dateTime = [GTLDateTime dateTimeWithDate:period.firstObject
                                                  timeZone:[NSTimeZone localTimeZone]];
    GTLCalendarEventDateTime *endDateTime = [[GTLCalendarEventDateTime alloc] init];
    endDateTime.dateTime = [GTLDateTime dateTimeWithDate:period.lastObject
                                                timeZone:[NSTimeZone localTimeZone]];
    
    event.start = startDateTime;
    event.end = endDateTime;
    
    event.summary = @"OakFood";
    
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsInsertWithObject:event calendarId:@"primary"];
    
    [self.calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error != nil) {
            [self showAlert:@"Failed to post event." message:error.localizedDescription];
            return;
        }
        
        if (![object isKindOfClass:[GTLCalendarEvent class]]) {
            [self showAlert:@"Failed to post event." message:@"Invalid object type"];
            return;
        }
        
        NSMutableArray *events = [NSMutableArray arrayWithArray:self.calendarEvents.items];
        [events addObject:event];
        self.calendarEvents.items = events;
        
        [self.tableView reloadData];
    }];
}

- (void)updateEvent:(GTLCalendarEvent *)existing withDate:(NSDate *)date period:(NSArray *)period {
    GTLCalendarEvent *event = [[GTLCalendarEvent alloc] init];
    
    GTLCalendarEventDateTime *startDateTime = [[GTLCalendarEventDateTime alloc] init];
    startDateTime.dateTime = [GTLDateTime dateTimeWithDate:period.firstObject
                                                  timeZone:[NSTimeZone localTimeZone]];
    GTLCalendarEventDateTime *endDateTime = [[GTLCalendarEventDateTime alloc] init];
    endDateTime.dateTime = [GTLDateTime dateTimeWithDate:period.lastObject
                                                timeZone:[NSTimeZone localTimeZone]];
    
    event.start = startDateTime;
    event.end = endDateTime;
    
    event.summary = @"OakFood";

    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsUpdateWithObject:event
                                                                    calendarId:@"primary"
                                                                       eventId:existing.identifier];
    
    [self.calendarService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error != nil) {
            [self showAlert:@"Failed to update event." message:error.localizedDescription];
            return;
        }
        
        if (![object isKindOfClass:[GTLCalendarEvent class]]) {
            [self showAlert:@"Failed to update event." message:@"Invalid object type"];
            return;
        }
        
        NSMutableArray *events = [NSMutableArray arrayWithArray:self.calendarEvents.items];
        [events removeObject:existing];
        [events addObject:event];
        self.calendarEvents.items = events;
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Action Handlers

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    
    if (error != nil) {
        self.calendarService.authorizer = nil;
        [self showAlert:@"Failed to authenticate" message:error.localizedDescription];
        return;
    }
    
    self.calendarService.authorizer = authResult;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)serviceTicket:(GTLServiceTicket *)ticket
   finishedWithObject:(id)object
                error:(NSError *)error {
    
    if (error != nil) {
        [self showAlert:@"Failed to fetch events." message:error.localizedDescription];
        return;
    }
    
    if (![object isKindOfClass:[GTLCalendarEvents class]]) {
        [self showAlert:@"Failed to fetch events." message:@"Invalid object type"];
        return;
    }
    
    self.calendarEvents = object;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = self.dates[indexPath.row];
    
    OAKDayCell *cell = [tableView dequeueReusableCellWithIdentifier:DayCellIdentifier forIndexPath:indexPath];
    [cell setDate:date];
    
    NSMutableArray *events = [NSMutableArray array];
    
    for (GTLCalendarEvent *event in self.calendarEvents.items) {
        GTLDateTime *start = event.start.dateTime ?: event.start.date;
        GTLDateTime *end = event.end.dateTime ?: event.end.date;
        
        if (start.date.day <= date.day && end.date.day >= date.day) {
            [events addObject:event];
        }
    }
    
    [cell setEvents:events];
    
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
                                           
                                           GTLCalendarEvent *matched = [self.calendarEvents.items bk_match:^BOOL(GTLCalendarEvent *event) {
                                               
                                               GTLDateTime *start = event.start.dateTime ?: event.start.date;
                                               GTLDateTime *end = event.end.dateTime ?: event.end.date;
                                               
                                               if ([event.summary isEqualToString:@"OakFood"] &&
                                                   start.date.day <= date.day &&
                                                   end.date.day >= date.day) {
                                                   return YES;
                                               }
                                               return NO;
                                           }];
                                           
                                           if (matched != nil) {
                                               [self updateEvent:matched withDate:date period:selectablePeriods[selectedIndex]];
                                               return;
                                           }
                                           
                                           [self postEventWithDate:date period:selectablePeriods[selectedIndex]];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         
                                     }
                                          origin:self.view];
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

- (void)setCalendarEvents:(GTLCalendarEvents *)events {
    _calendarEvents = events;
    
    self.title = _calendarEvents == nil ? @"Events" : events.summary;
}

@end
