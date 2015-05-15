//
//  OAKJSONLoaderTests.m
//  Oak
//
//  Created by t-matsumura on 5/16/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OAKJSONLoader.h"

@interface OAKJSONLoaderTests : XCTestCase

@end

@implementation OAKJSONLoaderTests

- (void)testLoadJSON {
    id json = [OAKJSONLoader loadJSONForBundle:[NSBundle bundleForClass:self.class] path:@"client_secret"];
    
    XCTAssertNotNil(json, @"should always return not null, even if failed to load JSON");
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = json;
        XCTAssertGreaterThan(dictionary.count, 0, @"should not be empty");
        return;
    }
    
    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *array = json;
        XCTAssertGreaterThan(array.count, 0, @"should not be empty");
        return;
    }
    
    XCTFail(@"should be either NSDictionary or NSArray");
}

@end
