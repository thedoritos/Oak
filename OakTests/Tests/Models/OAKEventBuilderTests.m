//
//  OAKEventBuilderTests.m
//  Oak
//
//  Created by t-matsumura on 5/19/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OAKEventBuilder.h"
#import "NSDate+Monthly.h"
#import "OAKTestHelper.h"

@interface OAKEventBuilderTests : XCTestCase

@property (nonatomic) OAKEventBuilder *sut;

@end

@implementation OAKEventBuilderTests

- (void)setUp {
    [super setUp];
    
    _sut = [[OAKEventBuilder alloc] init];
}

- (void)testSetSummary {
    NSString *summary = @"New Event";
    GTLCalendarEvent *event = [[_sut setSummary:summary] build];
    XCTAssertEqualObjects(event.summary, summary, @"should set summary");
}

- (void)testSetStartDate {
    NSDate *date = [NSDate date];
    GTLCalendarEvent *event = [[_sut setStartDate:date] build];
    XCTAssertEqualDates(event.start.dateTime.date, date, @"should set start date");
}

- (void)testSetEndDate {
    NSDate *date = [NSDate date];
    GTLCalendarEvent *event = [[_sut setEndDate:date] build];
    XCTAssertEqualDates(event.end.dateTime.date, date, @"should set start date");
}

- (void)testSetProperties {
    NSString *summary = @"New Event";
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [[NSDate date] addHour:1];
    
    GTLCalendarEvent *event = [[[[_sut setSummary:summary]
                                       setStartDate:startDate]
                                       setEndDate:endDate]
                                       build];
    
    XCTAssertEqualObjects(event.summary, summary, @"should set summary");
    XCTAssertEqualDates(event.start.dateTime.date, startDate, @"should set start date");
    XCTAssertEqualDates(event.end.dateTime.date, endDate, @"should set start date");
}

@end
