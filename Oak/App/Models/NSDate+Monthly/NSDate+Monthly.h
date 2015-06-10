//
//  NSDate+Monthly.h
//  Oak
//
//  Created by t-matsumura on 5/17/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Monthly)

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)weekday;

- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;

- (NSDate *)beginningOfDay;
- (NSDate *)endOfDay;

- (NSDate *)addMonth:(NSInteger)month;
- (NSDate *)addDay:(NSInteger)day;
- (NSDate *)addHour:(NSInteger)hour;
- (NSDate *)addMinute:(NSInteger)minute;
- (NSDate *)addSecond:(NSInteger)second;

- (BOOL)isBetween:(NSDate *)start and:(NSDate *)end;

+ (NSInteger)daysBetween:(NSDate *)start and:(NSDate *)end;
+ (NSArray *)datesBetween:(NSDate *)start and:(NSDate *)end;

@end
