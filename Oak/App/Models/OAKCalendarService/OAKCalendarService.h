//
//  OAKCalendarService.h
//  Oak
//
//  Created by t-matsumura on 5/27/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google-API-Client/GTLCalendar.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>

@interface OAKCalendarService : NSObject

+ (instancetype)sharedService;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (BOOL)isAuthorized;

- (UIViewController *)createAuthorizerWithCompletionHandler:(void (^)())completion
                                                    failure:(void (^)(NSError *error))failure;

- (GTLServiceTicket *)executeQuery:(id<GTLQueryProtocol>)queryObj
                 completionHandler:(void (^)(GTLServiceTicket *ticket, id object, NSError *error))handler;

@end
