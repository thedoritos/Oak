//
//  OAKCalendarService.m
//  Oak
//
//  Created by t-matsumura on 5/27/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKCalendarService.h"

#import "OAKJSONLoader.h"
#import "OAKGoogleClientSecret.h"

NSString * const kOAKKeyChainName = @"Oak";

@interface OAKCalendarService ()

@property (nonatomic, copy, readonly) OAKGoogleClientSecret *secret;
@property (nonatomic) GTLServiceCalendar *calendarService;

@end

@implementation OAKCalendarService

+ (instancetype)sharedService {
    static OAKCalendarService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OAKCalendarService alloc] initInstance];
    });
    return instance;
}

- (instancetype)initInstance {
    self = [super init];
    if (self) {
        NSDictionary *secretJSON = [OAKJSONLoader loadJSONForPath:@"client_secret"];
        _secret = [[OAKGoogleClientSecret alloc] initWithJSON:secretJSON];
        
        self.calendarService = [[GTLServiceCalendar alloc] init];
        self.calendarService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kOAKKeyChainName
                                                                                                clientID:self.secret.clientID
                                                                                            clientSecret:self.secret.clientSecret];
    }
    return self;
}

- (BOOL)isAuthorized {
    return [self.calendarService.authorizer canAuthorize];
}

- (UIViewController *)createAuthorizerWithCompletionHandler:(void (^)())completion
                                                    failure:(void (^)(NSError *error))failure {
    return [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeCalendar
                                                      clientID:self.secret.clientID
                                                  clientSecret:self.secret.clientSecret
                                              keychainItemName:kOAKKeyChainName
                                             completionHandler:^(GTMOAuth2ViewControllerTouch *viewController,
                                                                 GTMOAuth2Authentication *auth,
                                                                 NSError *error){
                                                 if (error) {
                                                     self.calendarService.authorizer = nil;
                                                     failure(error);
                                                     return;
                                                 }
                                                 
                                                 self.calendarService.authorizer = auth;
                                                 completion();
                                             }];
}

- (GTLServiceTicket *)executeQuery:(id<GTLQueryProtocol>)queryObj
                 completionHandler:(void (^)(GTLServiceTicket *ticket, id object, NSError *error))handler {
    return [self.calendarService executeQuery:queryObj completionHandler:handler];
}

@end
