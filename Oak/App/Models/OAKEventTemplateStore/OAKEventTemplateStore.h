//
//  OAKEventTemplateStore.h
//  Oak
//
//  Created by t-matsumura on 6/18/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAKEventTemplateStore : NSObject

+ (instancetype)storeForCalendarID:(NSString *)calendarID;

- (NSString *)loadTitle;
- (void)saveTitle:(NSString *)title;

- (NSInteger)loadPeriodCount;
- (NSArray *)loadPeriodAtIndex:(NSInteger)index;

@end
