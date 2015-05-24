//
//  OAKEvents.h
//  Oak
//
//  Created by t-matsumura on 5/21/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google-API-Client/GTLCalendar.h>

@interface OAKEvents : NSObject

@property (nonatomic, copy, readonly) NSString *summary;
@property (nonatomic, copy, readonly) NSArray *items;

- (instancetype)initWithCalendarEvents:(GTLCalendarEvents *)calendarEvents;

- (NSUInteger)count;
- (GTLCalendarEvent *)itemAtIndex:(NSUInteger)index;

- (void)add:(GTLCalendarEvent *)item;
- (void)removeWithId:(NSString *)eventId;
- (void)replace:(GTLCalendarEvent *)existing with:(GTLCalendarEvent *)item;

- (NSArray *)itemsAtDay:(NSDate *)day;
- (NSArray *)itemsWithSummary:(NSString *)summary;
- (NSArray *)itemsWithSummary:(NSString *)summary atDay:(NSDate *)day;

@end
