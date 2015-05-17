//
//  NSDate+MonthlyTests.m
//  Oak
//
//  Created by t-matsumura on 5/17/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSDate+Monthly.h"

@interface NSDate_MonthlyTests : XCTestCase

@property (nonatomic, copy, readonly) NSCalendar *calendar;
@property (nonatomic, copy, readonly) NSDate *today;

@end

@implementation NSDate_MonthlyTests

- (void)setUp {
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _today = [self.calendar dateWithEra:1 year:1988 month:2 day:14 hour:0 minute:0 second:0 nanosecond:0];
}

- (void)testGetYear {
    XCTAssertEqual([self.today year], 1988);
}

- (void)testGetMonth {
    XCTAssertEqual([self.today month], 2);
}

- (void)testGetDay {
    XCTAssertEqual([self.today day], 14);
}

- (void)testGetBeginningOfMonth {
    NSDate *beginning = [self.today beginningOfMonth];
    XCTAssertEqual(beginning.year, 1988);
    XCTAssertEqual(beginning.month, 2);
    XCTAssertEqual(beginning.day, 1);
}

- (void)testGetEndOfMonth {
    NSDate *end = [self.today endOfMonth];
    XCTAssertEqual(end.year, 1988);
    XCTAssertEqual(end.month, 2);
    XCTAssertEqual(end.day, 29);
}

- (void)testAddDay {
    NSDate *tomorrow = [self.today addDay:1];
    XCTAssertEqual(tomorrow.year, 1988);
    XCTAssertEqual(tomorrow.month, 2);
    XCTAssertEqual(tomorrow.day, 15);
    
    NSDate *yesterday = [self.today addDay:-1];
    XCTAssertEqual(yesterday.year, 1988);
    XCTAssertEqual(yesterday.month, 2);
    XCTAssertEqual(yesterday.day, 13);
}

- (void)testIsBetween {
    XCTAssertTrue([self.today isBetween:[self.today addDay:-1] and:[self.today addDay:1]],
                   @"should be between");
    XCTAssertTrue([self.today isBetween:[self.today addDay:0] and:[self.today addDay:1]],
                   @"should be between if on start");
    XCTAssertTrue([self.today isBetween:[self.today addDay:-1] and:[self.today addDay:0]],
                   @"should be between if on end");
    XCTAssertFalse([self.today isBetween:[self.today addDay:1] and:[self.today addDay:3]],
                   @"should not be between before start");
    XCTAssertFalse([self.today isBetween:[self.today addDay:-3] and:[self.today addDay:-1]],
                   @"should not be between after end");
}

- (void)testGetDaysBetween {
    XCTAssertEqual([NSDate daysBetween:[self.today beginningOfMonth] and:[self.today endOfMonth]], 29);
}

- (void)testGetDatesBetween {
    NSArray *dates = [NSDate datesBetween:[self.today beginningOfMonth] and:[self.today endOfMonth]];
    XCTAssertEqual(dates.count, 29);
    XCTAssertEqualObjects(dates.firstObject, [self.today beginningOfMonth]);
    XCTAssertEqualObjects(dates.lastObject, [self.today endOfMonth]);
}

@end
