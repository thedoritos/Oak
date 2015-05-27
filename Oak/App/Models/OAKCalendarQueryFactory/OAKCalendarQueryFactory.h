//
//  OAKCalendarQueryFactory.h
//  Oak
//
//  Created by t-matsumura on 5/26/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Google-API-Client/GTLCalendar.h>

@interface OAKCalendarQueryFactory : NSObject

+ (instancetype)factory;

- (GTLQueryCalendar *)createIndexQuery;

@end
