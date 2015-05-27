//
//  OAKCalendarQueryFactoryTests.m
//  Oak
//
//  Created by t-matsumura on 5/26/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAKTestHelper.h"
#import "OAKCalendarQueryFactory.h"

SpecBegin(OAKCalendarQueryFactory)

describe(@"OAKCalendarQueryFactory", ^{
    OAKCalendarQueryFactory *sut = [OAKCalendarQueryFactory factory];
    
    describe(@"#createIndexQuery", ^{
        it(@"returns query", ^{
            GTLQueryCalendar *query = [sut createIndexQuery];
            expect(query).toNot.beNil();
        });
    });
});

SpecEnd