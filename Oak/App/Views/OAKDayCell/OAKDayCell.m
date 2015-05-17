//
//  OAKDayCell.m
//  Oak
//
//  Created by t-matsumura on 5/17/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKDayCell.h"
#import "NSDate+Monthly.h"
#import <BlocksKit/BlocksKit.h>
#import <GTLCalendarEvent.h>

@interface OAKDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

@end

@implementation OAKDayCell

- (void)setDate:(NSDate *)date {
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)date.day];
}

- (void)setEvents:(NSArray *)events {
    self.eventLabel.text = [[events bk_map:^NSString *(GTLCalendarEvent *event) {
        return event.summary;
    }] componentsJoinedByString:@"; "];
}

@end
