//
//  OAKEventBuilder.m
//  Oak
//
//  Created by t-matsumura on 5/19/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKEventBuilder.h"

@implementation OAKEventBuilder

- (instancetype)setSummary:(NSString *)summary {
    _summary = summary;
    return self;
}

- (instancetype)setStartDate:(NSDate *)date {
    _startDate = date;
    return self;
}

- (instancetype)setEndDate:(NSDate *)date {
    _endDate = date;
    return self;
}

- (GTLCalendarEvent *)build {
    GTLCalendarEvent *event = [[GTLCalendarEvent alloc] init];
    
    GTLCalendarEventDateTime *startDateTime = [[GTLCalendarEventDateTime alloc] init];
    startDateTime.dateTime = [GTLDateTime dateTimeWithDate:self.startDate
                                                  timeZone:[NSTimeZone localTimeZone]];
    GTLCalendarEventDateTime *endDateTime = [[GTLCalendarEventDateTime alloc] init];
    endDateTime.dateTime = [GTLDateTime dateTimeWithDate:self.endDate
                                                timeZone:[NSTimeZone localTimeZone]];
    
    event.start = startDateTime;
    event.end = endDateTime;
    
    event.summary = self.summary;
    
    return event;
}

@end
