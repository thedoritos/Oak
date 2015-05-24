//
//  OAKEventsTests.m
//  Oak
//
//  Created by t-matsumura on 5/21/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OAKTestHelper.h"
#import "OAKEvents.h"
#import "OAKEventBuilder.h"
#import "NSDate+Monthly.h"

@interface OAKEventsTests : XCTestCase

@property (nonatomic) OAKEvents *sut;
@property (nonatomic) NSArray *items;

@property (nonatomic, copy, readonly) NSCalendar *calendar;
@property (nonatomic, copy, readonly) NSDate *today;

@end

@implementation OAKEventsTests

- (void)setUp {
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _today = [self.calendar dateWithEra:1 year:1988 month:2 day:14 hour:0 minute:0 second:0 nanosecond:0];

    _items = @[
        [[[[[OAKEventBuilder builder]
             setSummary:@"First"]
             setStartDate:self.today]
             setEndDate:[self.today addHour:1]]
             build],
        [[[[[OAKEventBuilder builder]
             setSummary:@"Second"]
             setStartDate:[self.today addDay:1]]
             setEndDate:[[self.today addDay:1] addHour:1]]
             build],
        [[[[[OAKEventBuilder builder]
             setSummary:@"Third"]
             setStartDate:[self.today addDay:2]]
             setEndDate:[[self.today addDay:2] addHour:1]]
             build]
    ];
    
    GTLCalendarEvents *events = [[GTLCalendarEvents alloc] init];
    events.items = _items;
    
    _sut = [[OAKEvents alloc] initWithCalendarEvents:events];
}

- (void)testCount {
    XCTAssertEqual(_sut.count, 3);
}

- (void)testItemAtIndex {
    for (NSInteger i = 0; i < _sut.count; i++) {
        XCTAssertEqualObjects([_sut itemAtIndex:i], _items[i]);
    }
}

- (void)testAddEvent {
    GTLCalendarEvent *fourth = [[[[[OAKEventBuilder builder]
                                    setSummary:@"Fourth"]
                                    setStartDate:[self.today addDay:3]]
                                    setEndDate:[[self.today addDay:3] addHour:1]]
                                    build];
    [_sut add:fourth];
    
    XCTAssertEqual(_sut.count, 4);
    XCTAssertEqualObjects([_sut itemAtIndex:3], fourth);
}

- (void)testRemoveEvent {
    [_sut remove:_items[1]];
    
    XCTAssertEqual(_sut.count, 2);
    XCTAssertEqualObjects([_sut itemAtIndex:1], _items[2]);
}

- (void)testReplaceEvent {
    GTLCalendarEvent *newSecond = [[[[[OAKEventBuilder builder]
                                       setSummary:@"Fourth"]
                                       setStartDate:[self.today addDay:3]]
                                       setEndDate:[[self.today addDay:3] addHour:1]]
                                       build];
    [_sut replace:_items[1] with:newSecond];
    
    XCTAssertEqual(_sut.count, 3);
    XCTAssertEqualObjects([_sut itemAtIndex:1], newSecond);
}

- (void)testItemsAtDay {
    XCTAssertEqualArrays([_sut itemsAtDay:self.today], @[_items[0]], @"should filter today's events");
    XCTAssertEqualArrays([_sut itemsAtDay:[self.today addDay:1]], @[_items[1]], @"should filter tomorrow's events");
    XCTAssertEqualArrays([_sut itemsAtDay:[self.today addDay:2]], @[_items[2]], @"should filter the day next tomorrow's events");
}

- (void)testItemsWithSummary {
    XCTAssertEqualArrays([_sut itemsWithSummary:@"First"], @[_items[0]], @"should filter First events");
    XCTAssertEqualArrays([_sut itemsWithSummary:@"Second"], @[_items[1]], @"should filter Second events");
    XCTAssertEqualArrays([_sut itemsWithSummary:@"Third"], @[_items[2]], @"should filter Third events");
}

- (void)testItemsWithSummaryAtDay {
    XCTAssertEqualArrays([_sut itemsWithSummary:@"First" atDay:self.today], @[_items[0]], @"should filter First events on today");
    XCTAssertEqualArrays([_sut itemsWithSummary:@"Second" atDay:self.today], @[], @"should filter Second events on today (none)");
}

@end
