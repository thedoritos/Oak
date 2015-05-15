//
//  OAKGoogleClientSecret.h
//  Oak
//
//  Created by t-matsumura on 5/16/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAKGoogleClientSecret : NSObject

@property (nonatomic, copy, readonly) NSString *clientID;
@property (nonatomic, copy, readonly) NSString *clientSecret;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
