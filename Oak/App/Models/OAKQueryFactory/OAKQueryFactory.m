//
//  OAKQueryFactory.m
//  Oak
//
//  Created by t-matsumura on 5/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKQueryFactory.h"
#import "NSDate+Monthly.h"

@implementation OAKQueryFactory

- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _date = date;
    }
    return self;
}

- (GTLQueryCalendar *)createIndexQuery {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"primary"];
    
    query.timeMin = [GTLDateTime dateTimeWithDate:[self.date beginningOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    query.timeMax = [GTLDateTime dateTimeWithDate:[self.date endOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    return query;
}

@end
