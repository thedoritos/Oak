//
//  OAKEventTemplateStore.m
//  Oak
//
//  Created by t-matsumura on 6/18/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKEventTemplateStore.h"

NSString * const kTitleKey = @"Title";
NSString * const kPeriodsKey = @"Periods";

@interface OAKEventTemplateStore ()

@property (nonatomic) NSString *calendarID;

@end

@implementation OAKEventTemplateStore

+ (instancetype)storeForCalendarID:(NSString *)calendarID {
    return [[OAKEventTemplateStore alloc] initWithCalendarID:calendarID];
}

- (instancetype)initWithCalendarID:(NSString *)calendarID {
    self = [super init];
    if (self) {
        self.calendarID = calendarID;
    }
    return self;
}

- (NSString *)loadTitle {
    NSDictionary *templates = [self loadTemplates];
    return templates[kTitleKey];
}

- (void)saveTitle:(NSString *)title {
    NSMutableDictionary *templates = [self loadTemplates];
    templates[kTitleKey] = title;
    [self saveTemplates:templates];
}

- (NSInteger)loadPeriodCount {
    NSMutableDictionary *templates = [self loadTemplates];
    NSArray *periods = templates[kPeriodsKey];
    return periods.count;
}

- (NSArray *)loadPeriodAtIndex:(NSInteger)index {
    NSMutableDictionary *templates = [self loadTemplates];
    NSArray *periods = templates[kPeriodsKey];
    return periods[index];
}

#pragma mark - Private

- (NSMutableDictionary *)loadTemplates {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{
        self.calendarID : @{
            kTitleKey : @"Event",
            kPeriodsKey : @[
                @[@(5), @(14)],
                @[@(5), @(9)],
                @[@(7), @(14)],
                @[@(8), @(14)]
            ]
        }
    }];
    
    return [[defaults dictionaryForKey:self.calendarID] mutableCopy];
}

- (void)saveTemplates:(NSDictionary *)templates {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:templates forKey:self.calendarID];
}

@end
