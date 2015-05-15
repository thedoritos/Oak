//
//  OAKJSONLoader.h
//  Oak
//
//  Created by t-matsumura on 5/16/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAKJSONLoader : NSObject

+ (id)loadJSONForBundle:(NSBundle *)bundle path:(NSString *)path;

+ (id)loadJSONForPath:(NSString *)path;

@end
