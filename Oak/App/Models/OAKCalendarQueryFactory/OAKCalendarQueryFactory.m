//
//  OAKCalendarQueryFactory.m
//  Oak
//
//  Created by t-matsumura on 5/26/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKCalendarQueryFactory.h"

@implementation OAKCalendarQueryFactory

+ (instancetype)factory {
    return [[OAKCalendarQueryFactory alloc] init];
}

- (GTLQueryCalendar *)createIndexQuery {
    return [GTLQueryCalendar queryForCalendarListList];
}

@end
