//
//  OAKEvents.m
//  Oak
//
//  Created by t-matsumura on 5/21/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKEvents.h"

@implementation OAKEvents

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = @[];
    }
    return self;
}

- (instancetype)initWithCalendarEvents:(GTLCalendarEvents *)calendarEvents {
    self = [super init];
    if (self) {
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

@end
