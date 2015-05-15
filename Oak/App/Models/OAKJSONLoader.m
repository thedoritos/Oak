//
//  OAKJSONLoader.m
//  Oak
//
//  Created by t-matsumura on 5/16/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKJSONLoader.h"

@implementation OAKJSONLoader

+ (id)loadJSONForBundle:(NSBundle *)bundle path:(NSString *)path {
    NSString *fullPath = [bundle pathForResource:path ofType:@"json"];
    
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfFile:fullPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    if (error) {
        return @{};
    }
    
    id json = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                              options:NSJSONReadingMutableContainers
                                                error:&error];
    if (error) {
        return @{};
    }
    
    return json;
}

+ (id)loadJSONForPath:(NSString *)path {
    return [self.class loadJSONForBundle:[NSBundle mainBundle] path:path];
}

@end
