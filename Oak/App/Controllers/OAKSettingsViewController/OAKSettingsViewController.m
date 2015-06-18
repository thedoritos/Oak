//
//  OAKSettingsViewController.m
//  Oak
//
//  Created by t-matsumura on 6/17/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKSettingsViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "OAKEventTemplateStore.h"

@interface OAKSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSString *calendarID;
@property (nonatomic) OAKEventTemplateStore *templateStore;

@end

@implementation OAKSettingsViewController

- (instancetype)initWithCalendarID:(NSString *)calendarID {
    self = [super init];
    if (self) {
        self.calendarID = calendarID;
        self.templateStore = [OAKEventTemplateStore storeForCalendarID:calendarID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] bk_initWithBarButtonSystemItem:UIBarButtonSystemItemDone handler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    closeButton.accessibilityLabel = @"close";
    
    self.navigationItem.rightBarButtonItem = closeButton;
    
    self.title = @"Settings";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Title";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"TitleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.textLabel.text = [self.templateStore loadTitle];
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end
