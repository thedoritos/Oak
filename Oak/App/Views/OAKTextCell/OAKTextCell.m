//
//  OAKTextCell.m
//  Oak
//
//  Created by t-matsumura on 6/20/15.
//  Copyright (c) 2015 Humour Studio. All rights reserved.
//

#import "OAKTextCell.h"

@interface OAKTextCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textView;

@end

@implementation OAKTextCell

- (void)awakeFromNib {
    self.textView.delegate = self;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.deletgate && [self.deletgate respondsToSelector:@selector(oakTextCell:didChangeText:)]) {
        [self.deletgate oakTextCell:self didChangeText:textField.text];
    }
}

@end
