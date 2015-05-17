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
    NSDate * beginning = [self.today beginningOfMonth];
    XCTAssertEqual(beginning.year, 1988);
    XCTAssertEqual(beginning.month, 2);
    XCTAssertEqual(beginning.day, 1);
}

- (void)testGetEndOfMonth {
    NSDate * end = [self.today endOfMonth];
    XCTAssertEqual(end.year, 1988);
    XCTAssertEqual(end.month, 2);
    XCTAssertEqual(end.day, 29);
}

@end
