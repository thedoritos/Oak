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
    
    _sut = [[OAKQueryFactory alloc] initWithDate:self.today];
}

- (void)testCreateIndexQuery {
    GTLQueryCalendar *query = [_sut createIndexQuery];
    
    XCTAssertEqualObjects(query.calendarId, @"primary",            @"should create query for defaut calendar");
    XCTAssertEqualDates(query.timeMin.date, self.beginningOfMonth, @"should set beginning of range");
    XCTAssertEqualDates(query.timeMax.date, self.endOfMonth,       @"should set end of range");
}

@end
