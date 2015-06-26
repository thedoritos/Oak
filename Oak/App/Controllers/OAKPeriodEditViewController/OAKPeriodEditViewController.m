//
//  OAKPeriodEditViewController.m
//  Oak
//
//  Created by t-matsumura on 6/26/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKPeriodEditViewController.h"
#import "OAKTimeCell.h"

NSString * const kTimeCellIdentifier = @"OAKTimeCell";

@interface OAKPeriodEditViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray *period;

@end

@implementation OAKPeriodEditViewController

- (instancetype)initWithPeriod:(NSArray *)period {
    self = [super init];
    if (self) {
        self.period = period;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:kTimeCellIdentifier bundle:[NSBundle mainBundle]] forCellReuseIdentifier:kTimeCellIdentifier];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OAKTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimeCellIdentifier];
    
    [cell setTime:self.period[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
