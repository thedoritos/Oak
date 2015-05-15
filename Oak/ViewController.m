//
//  ViewController.m
//  Oak
//
//  Created by t-matsumura on 5/15/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "ViewController.h"
#import <GTMOAuth2ViewControllerTouch.h>
#import <GTLCalendar.h>
#import "OAKJSONLoader.h"
#import "OAKGoogleClientSecret.h"

NSString * const KEYCHAIN_NAME = @"Oak";

@interface ViewController ()

@property (nonatomic) GTLServiceCalendar *calendarService;
@property (nonatomic, copy, readonly) OAKGoogleClientSecret *secret;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *secretJSON = [OAKJSONLoader loadJSONForPath:@"client_secret"];
    _secret = [[OAKGoogleClientSecret alloc] initWithJSON:secretJSON];
    
    self.calendarService = [[GTLServiceCalendar alloc] init];
    self.calendarService.authorizer = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:KEYCHAIN_NAME
                                                                                            clientID:self.secret.clientID
                                                                                        clientSecret:self.secret.clientSecret];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![self.calendarService.authorizer canAuthorize]) {
        UIViewController *authViewController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:kGTLAuthScopeCalendar
                                                                                          clientID:self.secret.clientID
                                                                                      clientSecret:self.secret.clientSecret
                                                                                  keychainItemName:KEYCHAIN_NAME
                                                                                          delegate:self
                                                                                  finishedSelector:@selector(viewController:finishedWithAuth:error:)];
        [self presentViewController:authViewController animated:YES completion:nil];
        return;
    }
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    
    if (error != nil) {
        self.calendarService.authorizer = nil;
        return;
    }
    
    self.calendarService.authorizer = authResult;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
