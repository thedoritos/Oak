//
//  OAKQueryFactoryTests.m
//  Oak
//
//  Created by t-matsumura on 5/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OAKQueryFactory.h"
#import "OAKTestHelper.h"

@interface OAKQueryFactoryTests : XCTestCase

@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSString *calendarID;

@property (nonatomic, copy, readonly) NSDate *today;
@property (nonatomic, copy, readonly) NSDate *beginningOfMonth;
@property (nonatomic, copy, readonly) NSDate *endOfMonth;

@property (nonatomic) OAKQueryFactory *sut;

@end

@implementation OAKQueryFactoryTests

- (void)setUp {
    [super setUp];
    
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    _today            = [self.calendar dateWithEra:1 year:1988 month:2 day:14 hour:0 minute:0 second:0 nanosecond:0];
    _beginningOfMonth = [self.calendar dateWithEra:1 year:1988 month:2 day:1  hour:0 minute:0 second:0 nanosecond:0];
    _endOfMonth       = [self.calendar dateWithEra:1 year:1988 month:2 day:29 hour:0 minute:0 second:0 nanosecond:0];
    
    _calendarID = @"humour studio";
    _sut = [[OAKQueryFactory alloc] initWithCalendarID:self.calendarID];
}

- (void)testCreateIndexQuery {
    GTLQueryCalendar *query = [_sut createIndexQueryWithMonth:self.today];
    
    XCTAssertEqualObjects(query.calendarId, self.calendarID,       @"should create query for calendar");
    XCTAssertEqualDates(query.timeMin.date, self.beginningOfMonth, @"should set beginning of range");
    XCTAssertEqualDates(query.timeMax.date, self.endOfMonth,       @"should set end of range");
}

- (void)testCreateCreateQuery {
    GTLCalendarEvent *event = [[GTLCalendarEvent alloc] init];
    GTLQueryCalendar *query = [_sut createCreateQueryWithEvent:event];
    
    XCTAssertEqualObjects(query.calendarId, self.calendarID, @"should create query for calendar");
}

- (void)testCreateUpdateQuery {
    GTLCalendarEvent *event = [[GTLCalendarEvent alloc] init];
    NSString *eventId = @"abcd1234";
    GTLQueryCalendar *query = [_sut createUpdateQueryWithEvent:event where:eventId];
    
    XCTAssertEqualObjects(query.calendarId, self.calendarID, @"should create query for calendar");
}

- (void)testCreateDeleteQuery {
    NSString *eventId = @"abcd1234";
    GTLQueryCalendar *query = [_sut createDeleteQueryWithEventId:eventId];
    
    XCTAssertEqualObjects(query.calendarId, self.calendarID, @"should create query for calendar");
    XCTAssertEqualObjects(query.eventId, eventId, @"should create query for the event");
}

@end
