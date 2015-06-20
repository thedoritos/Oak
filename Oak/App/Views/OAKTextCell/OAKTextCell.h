//
//  OAKTextCell.h
//  Oak
//
//  Created by t-matsumura on 6/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAKTextCell;

@protocol OAKTextCellDelegate <NSObject>

- (void)oakTextCell:(OAKTextCell *)cell didChangeText:(NSString *)text;

@end

@interface OAKTextCell : UITableViewCell

- (void)setText:(NSString *)text;

@property (nonatomic) id<OAKTextCellDelegate> deletgate;

@end
