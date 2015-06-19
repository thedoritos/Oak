//
//  OAKTextCell.m
//  Oak
//
//  Created by t-matsumura on 6/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKTextCell.h"

@interface OAKTextCell ()

@property (weak, nonatomic) IBOutlet UITextField *textView;

@end

@implementation OAKTextCell

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

@end
