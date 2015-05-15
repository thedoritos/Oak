//
//  OAKGoogleClientSecret.m
//  Oak
//
//  Created by t-matsumura on 5/16/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKGoogleClientSecret.h"

@implementation OAKGoogleClientSecret

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        NSDictionary *installed = json[@"installed"];
        
        if (installed == nil) {
            return self;
        }
        
        _clientID = installed[@"client_id"];
        _clientSecret = installed[@"client_secret"];
    }
    return self;
}

@end
