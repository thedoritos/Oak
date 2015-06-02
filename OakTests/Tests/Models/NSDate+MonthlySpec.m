//
//  NSDate+MonthlySpec.m
//  Oak
//
//  Created by t-matsumura on 6/2/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAKTestHelper.h"
#import "NSDate+Monthly.h"

SpecBegin(NSDateMonthly)

describe(@"NSDate+Monthly", ^{
    __block NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    __block NSDate *today = [calendar dateWithEra:1 year:1988 month:5 day:31 hour:0 minute:0 second:0 nanosecond:0];
    
    describe(@"#addMinute", ^{
        it(@"returns 1 minute ago", ^{
            NSDate *ago = [today addMinute:1];
            expect(ago.year).to.equal(1988);
            expect(ago.month).to.equal(5);
            expect(ago.day).to.equal(31);
            expect(ago.hour).to.equal(0);
            expect(ago.minute).to.equal(1);
            expect(ago.second).to.equal(0);
        });
        
        it(@"returns 2 minutes before", ^{
            NSDate *ago = [today addMinute:-2];
            expect(ago.year).to.equal(1988);
            expect(ago.month).to.equal(5);
            expect(ago.day).to.equal(30);
            expect(ago.hour).to.equal(23);
            expect(ago.minute).to.equal(58);
            expect(ago.second).to.equal(0);
        });
    });

    describe(@"#addSecond", ^{
        it(@"returns 3 seconds ago", ^{
            NSDate *ago = [today addSecond:3];
            expect(ago.year).to.equal(1988);
            expect(ago.month).to.equal(5);
            expect(ago.day).to.equal(31);
            expect(ago.hour).to.equal(0);
            expect(ago.minute).to.equal(0);
            expect(ago.second).to.equal(3);
        });
        
        it(@"returns 4 seconds before", ^{
            NSDate *ago = [today addSecond:-4];
            expect(ago.year).to.equal(1988);
            expect(ago.month).to.equal(5);
            expect(ago.day).to.equal(30);
            expect(ago.hour).to.equal(23);
            expect(ago.minute).to.equal(59);
            expect(ago.second).to.equal(56);
        });
    });

    describe(@"#endOfMonth", ^{
        it(@"returns the last day of the month", ^{
            NSDate *end = [today endOfMonth];
            expect(end.year).to.equal(1988);
            expect(end.month).to.equal(5);
            expect(end.day).to.equal(31);
            expect(end.hour).to.equal(23);
            expect(end.minute).to.equal(59);
            expect(end.second).to.equal(59);
        });
    });
});

SpecEnd