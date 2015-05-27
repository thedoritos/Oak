//
//  OAKQueryFactory.m
//  Oak
//
//  Created by t-matsumura on 5/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKQueryFactory.h"
#import "NSDate+Monthly.h"

@interface OAKQueryFactory ()

@property (nonatomic, copy, readonly) NSString *calendarID;

@end

@implementation OAKQueryFactory

+ (instancetype)factoryWithCalendarID:(NSString *)calendarID {
    return [[OAKQueryFactory alloc] initWithCalendarID:calendarID];
}

- (instancetype)initWithCalendarID:(NSString *)calendarID {
    self = [super init];
    if (self) {
        _calendarID = calendarID;
    }
    return self;
}

- (GTLQueryCalendar *)createIndexQueryWithMonth:(NSDate *)date {
    GTLQueryCalendar *query = [GTLQueryCalendar queryForEventsListWithCalendarId:self.calendarID];
    
    query.timeMin = [GTLDateTime dateTimeWithDate:[date beginningOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    query.timeMax = [GTLDateTime dateTimeWithDate:[date endOfMonth]
                                         timeZone:[NSTimeZone localTimeZone]];
    
    query.singleEvents = YES;
    query.orderBy = kGTLCalendarOrderByStartTime;
    
    return query;
}

- (GTLQueryCalendar *)createCreateQueryWithEvent:(GTLCalendarEvent *)event {
    return [GTLQueryCalendar queryForEventsInsertWithObject:event calendarId:self.calendarID];
}

- (GTLQueryCalendar *)createUpdateQueryWithEvent:(GTLCalendarEvent *)event where:(NSString *)eventId {
    return [GTLQueryCalendar queryForEventsUpdateWithObject:event
                                                 calendarId:self.calendarID
                                                    eventId:eventId];
}

- (GTLQueryCalendar *)createDeleteQueryWithEventId:(NSString *)eventId {
    return [GTLQueryCalendar queryForEventsDeleteWithCalendarId:self.calendarID
                                                        eventId:eventId];
}

@end
