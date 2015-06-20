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
#import "OAKTextCell.h"

NSString * const kTextCell = @"OAKTextCell";

@interface OAKSettingsViewController () <UITableViewDataSource, UITableViewDelegate, OAKTextCellDelegate>

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
    
    [self.tableView registerNib:[UINib nibWithNibName:kTextCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTextCell];
    
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
    OAKTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCell];
    
    [cell setDeletgate:self];
    [cell setText:[self.templateStore loadTitle]];
    
    return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark - OAKTextCellDelegate

- (void)oakTextCell:(OAKTextCell *)cell didChangeText:(NSString *)text {
    [self.templateStore saveTitle:text];
}

@end
