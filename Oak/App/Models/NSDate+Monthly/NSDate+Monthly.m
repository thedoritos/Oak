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
    return [[self defaultCalendar] component:NSCalendarUnitYear fromDate:self];
}

- (NSInteger)month {
    return [[self defaultCalendar] component:NSCalendarUnitMonth fromDate:self];
}

- (NSInteger)day {
    return [[self defaultCalendar] component:NSCalendarUnitDay fromDate:self];
}

- (NSDate *)beginningOfMonth {
    NSDateComponents *components = [[self defaultCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1;
    return [[self defaultCalendar] dateFromComponents:components];
}

- (NSDate *)endOfMonth {
    return  [[self defaultCalendar] nextDateAfterDate:self
                                         matchingUnit:NSCalendarUnitDay
                                                value:31
                                              options:NSCalendarMatchPreviousTimePreservingSmallerUnits];
}

#pragma mark - Private

- (NSCalendar *)defaultCalendar {
    return [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
}

@end
