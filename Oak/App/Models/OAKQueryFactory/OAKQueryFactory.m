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

+ (instancetype)factory {
    return [[OAKQueryFactory alloc] init];
}

- (GTLQueryCalendar *)createIndexQueryWithMonth:(NSDate *)date {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:@"primary"];
    
    query.timeMin = [GTLDateTime dateTimeWithDate:[date beginningOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    query.timeMax = [GTLDateTime dateTimeWithDate:[date endOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    return query;
}

- (GTLQueryCalendar *)createCreateQueryWithEvent:(GTLCalendarEvent *)event {
    return [GTLQueryCalendar queryForEventsInsertWithObject:event calendarId:@"primary"];
}

- (GTLQueryCalendar *)createUpdateQueryWithEvent:(GTLCalendarEvent *)event where:(NSString *)eventId {
    return [GTLQueryCalendar queryForEventsUpdateWithObject:event
                                                 calendarId:@"primary"
                                                    eventId:eventId];
}

- (GTLQueryCalendar *)createDeleteQueryWithEventId:(NSString *)eventId {
    return [GTLQueryCalendar queryForEventsDeleteWithCalendarId:@"primary"
                                                        eventId:eventId];
}

@end
