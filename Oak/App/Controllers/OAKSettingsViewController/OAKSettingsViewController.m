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
#import "OAKTimeCell.h"
#import "OAKPeriodEditViewController.h"

NSString * const kTextCell = @"OAKTextCell";
NSString * const kTimeCell = @"OAKTimeCell";

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
    [self.tableView registerNib:[UINib nibWithNibName:kTimeCell bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTimeCell];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return [self.templateStore loadPeriodCount];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Title";
    }
    
    return @"Time";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        OAKTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kTextCell];
        
        [cell setDeletgate:self];
        [cell setText:[self.templateStore loadTitle]];
        
        return cell;
    }
    
    OAKTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeCell];
    
    [cell setPeriod:[self.templateStore loadPeriodAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    
    NSArray *period = [self.templateStore loadPeriodAtIndex:indexPath.row];
    OAKPeriodEditViewController *editViewController = [[OAKPeriodEditViewController alloc] initWithPeriod:period];
    [self.navigationController pushViewController:editViewController animated:YES];
}

#pragma mark - OAKTextCellDelegate

- (void)oakTextCell:(OAKTextCell *)cell didChangeText:(NSString *)text {
    [self.templateStore saveTitle:text];
}

@end
