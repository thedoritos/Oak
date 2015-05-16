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
#import "OAKJSONLoader.h"
#import "OAKGoogleClientSecret.h"

NSString * const KEYCHAIN_NAME = @"Oak";

@interface ViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) GTLCalendarEvents *calendarEvents;

@property (nonatomic) GTLServiceCalendar *calendarService;
@property (nonatomic, copy, readonly) OAKGoogleClientSecret *secret;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarEvents = [[GTLCalendarEvents alloc] init];
    
    NSDictionary *secretJSON = [OAKJSONLoader loadJSONForPath:@"client_secret"];
    _secret = [[OAKGoogleClientSecret alloc] initWithJSON:secretJSON];
    
    self.calendarService = [[GTLServiceCalendar alloc] init];
    self.calendarService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:KEYCHAIN_NAME
                                                                                            clientID:self.secret.clientID
                                                                                        clientSecret:self.secret.clientSecret];
    
    self.tableView.dataSource = self;
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
    query.maxResults = 10;
    query.timeMin = [GTLDateTime dateTimeWithDate:[NSDate date]
                                         timeZone:[NSTimeZone localTimeZone]];
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    [self.calendarService executeQuery:query
                              delegate:self
                     didFinishSelector:@selector(serviceTicket:finishedWithObject:error:)];
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
    return self.calendarEvents.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTLCalendarEvent *event = self.calendarEvents.items[indexPath.row];
    
    NSString * const ReuseID = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:ReuseID];
    }
    
    GTLDateTime *start = event.start.dateTime ?: event.start.date;
    GTLDateTime *end   = event.end.dateTime   ?: event.end.date;
    
    NSString *startString = [NSDateFormatter localizedStringFromDate:start.date
                                                           dateStyle:NSDateFormatterShortStyle
                                                           timeStyle:NSDateFormatterShortStyle];
    NSString *endString = [NSDateFormatter localizedStringFromDate:end.date
                                                         dateStyle:NSDateFormatterShortStyle
                                                         timeStyle:NSDateFormatterShortStyle];
    
    cell.textLabel.text = event.summary;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startString, endString];
    
    return cell;
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
