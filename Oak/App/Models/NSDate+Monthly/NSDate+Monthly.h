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

@end
