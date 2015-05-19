//
//  OAKQueryFactory.h
//  Oak
//
//  Created by t-matsumura on 5/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google-API-Client/GTLCalendar.h>

@interface OAKQueryFactory : NSObject

@property (nonatomic, copy, readonly) NSDate *date;

- (instancetype)initWithDate:(NSDate *)date;

- (GTLQueryCalendar *)createIndexQuery;

@end
