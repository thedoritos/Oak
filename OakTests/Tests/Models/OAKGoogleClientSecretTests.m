//
//  OAKGoogleClientSecretTests.m
//  Oak
//
//  Created by t-matsumura on 5/16/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "OAKJSONLoader.h"
#import "OAKGoogleClientSecret.h"

@interface OAKGoogleClientSecretTests : XCTestCase

@end

@implementation OAKGoogleClientSecretTests

- (void)testInitializeProperties {
    NSDictionary *secretJSON = [OAKJSONLoader loadJSONForBundle:[NSBundle bundleForClass:self.class] path:@"client_secret"];
    OAKGoogleClientSecret *secret = [[OAKGoogleClientSecret alloc] initWithJSON:secretJSON];
    
    XCTAssertEqualObjects(secret.clientID, @"clientid.apps.googleusercontent.com", @"should initialize client ID");
    XCTAssertEqualObjects(secret.clientSecret, @"ClientSecret", @"should initialize client secret");
}

@end
