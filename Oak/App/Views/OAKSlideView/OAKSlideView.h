//
//  OAKSlideView.h
//  Oak
//
//  Created by t-matsumura on 5/28/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAKSlideView;

@protocol OAKSlideViewDelegate <NSObject>

- (void)slideViewDidSelectRight:(OAKSlideView *)slideView;
- (void)slideViewDidSelectLeft:(OAKSlideView *)slideView;

@end

@interface OAKSlideView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic) id<OAKSlideViewDelegate> delegate;

@end
