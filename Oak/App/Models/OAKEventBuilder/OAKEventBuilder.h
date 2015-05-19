//
//  OAKEventBuilder.h
//  Oak
//
//  Created by t-matsumura on 5/19/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google-API-Client/GTLCalendar.h>

@interface OAKEventBuilder : NSObject

@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSDate *startDate;
@property (nonatomic, copy, readonly) NSDate *endDate;

- (instancetype)setSummary:(NSString *)summary;
- (instancetype)setStartDate:(NSDate *)date;
- (instancetype)setEndDate:(NSDate *)date;

- (GTLCalendarEvent *)build;

@end
