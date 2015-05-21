//
//  OAKEvents.m
//  Oak
//
//  Created by t-matsumura on 5/21/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKEvents.h"
#import <BlocksKit/BlocksKit.h>
#import "NSDate+Monthly.h"

@implementation OAKEvents

- (instancetype)init {
    self = [super init];
    if (self) {
        _summary = nil;
        _items = @[];
    }
    return self;
}

- (instancetype)initWithCalendarEvents:(GTLCalendarEvents *)calendarEvents {
    self = [super init];
    if (self) {
        _summary = calendarEvents.summary;
        _items = calendarEvents.items;
    }
    return self;
}

- (NSUInteger)count {
    return self.items.count;
}

- (GTLCalendarEvent *)itemAtIndex:(NSUInteger)index {
    return self.items[index];
}

- (void)add:(GTLCalendarEvent *)item {
    NSMutableArray *mutableItems = [NSMutableArray arrayWithArray:self.items];
    [mutableItems addObject:item];
    _items = [NSArray arrayWithArray:mutableItems];
}

- (void)replace:(GTLCalendarEvent *)existing with:(GTLCalendarEvent *)item {
    NSMutableArray *mutableItems = [NSMutableArray arrayWithArray:self.items];
    
    NSUInteger index = [mutableItems indexOfObject:existing];
    [mutableItems replaceObjectAtIndex:index withObject:item];
    _items = [NSArray arrayWithArray:mutableItems];
}

- (NSArray *)itemsAtDay:(NSDate *)day {
    return [self.items bk_select:^BOOL(GTLCalendarEvent *event) {
        GTLDateTime *start = event.start.dateTime ?: event.start.date;
        GTLDateTime *end = event.end.dateTime ?: event.end.date;
        
        NSDate *beginningOfDay = [day beginningOfDay];
        NSDate *endOfDay = [day endOfDay];
        
        if ([end.date compare:beginningOfDay] < 0 || [start.date compare:endOfDay] > 0) {
            return NO;
        }
        
        return YES;
    }];
}

- (NSArray *)itemsWithSummary:(NSString *)summary {
    return [self.items bk_select:^BOOL(GTLCalendarEvent *event) {
        return [event.summary isEqualToString:summary];
    }];
}

- (NSArray *)itemsWithSummary:(NSString *)summary atDay:(NSDate *)day {
    return [[self itemsAtDay:day] bk_select:^BOOL(GTLCalendarEvents *event) {
        return [event.summary isEqualToString:summary];
    }];
}

@end
