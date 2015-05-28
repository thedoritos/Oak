//
//  OAKSlideView.m
//  Oak
//
//  Created by t-matsumura on 5/28/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKSlideView.h"

@implementation OAKSlideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;

}

-  (void)setup {
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"OAKSlideView" owner:self options:nil][0];
    
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self addSubview:view];
    [self setNeedsUpdateConstraints];
}

#pragma mark - UIActions

- (IBAction)didSelectLeft:(id)sender {
    if (self.delegate) {
        [self.delegate slideViewDidSelectLeft:self];
    }
}

- (IBAction)didSelectRight:(id)sender {
    if (self.delegate) {
        [self.delegate slideViewDidSelectRight:self];
    }
}

@end
