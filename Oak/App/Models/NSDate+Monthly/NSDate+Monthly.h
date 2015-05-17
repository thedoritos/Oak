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

- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;

- (NSDate *)addDay:(NSInteger)day;

+ (NSInteger)daysBetween:(NSDate *)start and:(NSDate *)end;
+ (NSArray *)datesBetween:(NSDate *)start and:(NSDate *)end;

@end
