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

@end

@implementation OAKEventsTests

- (void)setUp {
    NSDate *today = [NSDate date];
    
    _items = @[
        [[[[[OAKEventBuilder builder]
             setSummary:@"First"]
             setStartDate:today]
             setEndDate:[today addHour:1]]
             build],
        [[[[[OAKEventBuilder builder]
             setSummary:@"Second"]
             setStartDate:[today addDay:1]]
             setEndDate:[[today addDay:1] addHour:1]]
             build],
        [[[[[OAKEventBuilder builder]
             setSummary:@"Third"]
             setStartDate:[today addDay:2]]
             setEndDate:[[today addDay:2] addHour:1]]
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
    NSDate *today = [NSDate date];
    
    GTLCalendarEvent *fourth = [[[[[OAKEventBuilder builder]
                                    setSummary:@"Fourth"]
                                    setStartDate:[today addDay:3]]
                                    setEndDate:[[today addDay:3] addHour:1]]
                                    build];
    [_sut add:fourth];
    
    XCTAssertEqual(_sut.count, 4);
    XCTAssertEqualObjects([_sut itemAtIndex:3], fourth);
}

- (void)testItemsAtDay {
    NSDate *today = [NSDate date];
    XCTAssertEqualArrays([_sut itemsAtDay:today], @[_items[0]], @"should filter today's events");
    XCTAssertEqualArrays([_sut itemsAtDay:[today addDay:1]], @[_items[1]], @"should filter tomorrow's events");
    XCTAssertEqualArrays([_sut itemsAtDay:[today addDay:2]], @[_items[2]], @"should filter the day next tomorrow's events");
}

@end
