//
//  NSDate+Monthly.m
//  Oak
//
//  Created by t-matsumura on 5/17/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "NSDate+Monthly.h"

@implementation NSDate (Monthly)

- (NSInteger)year {
    return [[NSDate defaultCalendar] component:NSCalendarUnitYear fromDate:self];
}

- (NSInteger)month {
    return [[NSDate defaultCalendar] component:NSCalendarUnitMonth fromDate:self];
}

- (NSInteger)day {
    return [[NSDate defaultCalendar] component:NSCalendarUnitDay fromDate:self];
}

- (NSDate *)beginningOfMonth {
    NSDateComponents *components = [[NSDate defaultCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1;
    return [[NSDate defaultCalendar] dateFromComponents:components];
}

- (NSDate *)endOfMonth {
    return  [[NSDate defaultCalendar] nextDateAfterDate:self
                                         matchingUnit:NSCalendarUnitDay
                                                value:31
                                              options:NSCalendarMatchPreviousTimePreservingSmallerUnits];
}

- (NSDate *)addDay:(NSInteger)day {
    NSDateComponents *offset = [[NSDateComponents alloc] init];
    offset.day = day;
    return [[NSDate defaultCalendar] dateByAddingComponents:offset toDate:self options:0];
}

- (BOOL)isBetween:(NSDate *)start and:(NSDate *)end {
    NSComparisonResult startResult = [self compare:start];
    NSComparisonResult endResult = [self compare:end];
    
    return (startResult == NSOrderedSame || startResult == NSOrderedDescending) &&
           (endResult   == NSOrderedSame || endResult   == NSOrderedAscending);
}

+ (NSInteger)daysBetween:(NSDate *)start and:(NSDate *)end {
    NSCalendar *calendar = [NSDate defaultCalendar];
    
    NSDate *fixedStart, *fixedEnd;
    [calendar rangeOfUnit:NSCalendarUnitDay
                startDate:&fixedStart
                 interval:nil
                  forDate:start];
    [calendar rangeOfUnit:NSCalendarUnitDay
                startDate:&fixedEnd
                 interval:nil
                  forDate:end];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fixedStart
                                                 toDate:fixedEnd
                                                options:0];
    
    return difference.day + 1;
}

+ (NSArray *)datesBetween:(NSDate *)start and:(NSDate *)end {
    NSMutableArray *dates = [NSMutableArray array];
    NSInteger days = [NSDate daysBetween:start and:end];
    
    
    for (NSInteger i = 0; i < days; i++) {
        [dates addObject:[start addDay:i]];
    }
    return dates;
}

#pragma mark - Private

+ (NSCalendar *)defaultCalendar {
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

@end
