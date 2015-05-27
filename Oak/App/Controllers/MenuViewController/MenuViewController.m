//
//  MenuViewController.m
//  Oak
//
//  Created by t-matsumura on 5/26/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "MenuViewController.h"
#import <REMenu/REMenu.h>
#import <BlocksKit/BlocksKit.h>
#import <UIColor-HexString/UIColor+HexString.h>
#import "OAKCalendarService.h"
#import "OAKCalendarQueryFactory.h"
#import "ViewController.h"

@interface MenuViewController ()

@property (strong, readwrite, nonatomic) REMenu *menu;
@property (nonatomic) OAKCalendarService *calendarService;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarService = [OAKCalendarService sharedService];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.calendarService.isAuthorized) {
        UIViewController *authorizer = [self.calendarService createAuthorizerWithCompletionHandler:^{
            [self viewDidAuthorize];
        } failure:^(NSError *error) {
            [self showAlert:@"Failed to authenticate" message:error.localizedDescription];
        }];
        
        [self presentViewController:authorizer animated:YES completion:nil];
    }
    
    [self viewDidAuthorize];
}

- (void)viewDidAuthorize {
    OAKCalendarQueryFactory *factory = [OAKCalendarQueryFactory factory];
    [self.calendarService executeQuery:[factory createIndexQuery]
                     completionHandler:^(GTLServiceTicket *ticker, GTLCalendarCalendarList *list, NSError *error) {
                         NSArray *items = [[list.items bk_select:^BOOL(GTLCalendarCalendarListEntry *entry) {
                             
                             return [entry.accessRole isEqualToString:@"owner"]
                                 && [entry.hidden boolValue] == false;
                             
                         }] bk_map:^REMenuItem *(GTLCalendarCalendarListEntry *entry) {
                             
                             REMenuItem *menuItem = [[REMenuItem alloc] initWithTitle:entry.summary
                                                                             subtitle:nil
                                                                                image:nil
                                                                     highlightedImage:nil
                                                                               action:^(REMenuItem *menuItem) {
                                                                                   UIViewController *viewController = [[ViewController alloc] initWithCalendarID:entry.identifier];
                                                                                   [self setViewControllers:@[viewController] animated:NO];
                                                                               }];
                             
                             menuItem.textColor = [UIColor colorWithHexString:entry.backgroundColor];
                             
                             return menuItem;
                         }];
                         
                         self.menu = [[REMenu alloc] initWithItems:items];
                     }];
}

- (void)toggleMenu
{
    if (self.menu.isOpen)
        return [self.menu close];
    
    [self.menu showFromNavigationController:self];
}

#pragma mark - View Helpers

- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
}

@end
