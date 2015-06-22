//
//  OAKTimeCell.m
//  Oak
//
//  Created by t-matsumura on 6/22/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKTimeCell.h"

@interface OAKTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation OAKTimeCell

- (void)setPeriod:(NSArray *)period {
    self.timeLabel.text = [NSString stringWithFormat:@"%@:00 〜 %@:00", period[0], period[1]];
}

@end
