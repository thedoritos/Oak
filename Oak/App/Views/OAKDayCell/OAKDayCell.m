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
#import <GTLCalendar.h>

@interface OAKDayCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;

@end

@implementation OAKDayCell

- (void)setDate:(NSDate *)date {
    NSDictionary *weekdays = @{
        @(1): @"日",
        @(2): @"月",
        @(3): @"火",
        @(4): @"水",
        @(5): @"木",
        @(6): @"金",
        @(7): @"土"
    };
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)date.day];
    self.weekdayLabel.text = weekdays[@(date.weekday)];
}

- (void)setEvents:(NSArray *)events {
    self.eventLabel.text = [[events bk_map:^NSString *(GTLCalendarEvent *event) {
        GTLDateTime *start = event.start.dateTime ?: event.start.date;
        GTLDateTime *end = event.end.dateTime ?: event.end.date;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"H:mm";
        
        return [NSString stringWithFormat:@"%@: %@ ~ %@",
                event.summary,
                [formatter stringFromDate:start.date],
                [formatter stringFromDate:end.date]];
        
    }] componentsJoinedByString:@"; "];
}

+ (CGFloat)preferredHeight {
    return 52.0f;
}

@end
