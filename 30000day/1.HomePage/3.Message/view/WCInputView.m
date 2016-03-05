//
//  WCInputView.m
//  weChat
//
//  Created by guojia on 15/6/25.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import "WCInputView.h"
@implementation WCInputView

+ (instancetype)inputView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil] lastObject];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textView.layer.cornerRadius = 5;
    
    self.textView.layer.masksToBounds = YES;
    
    self.textView.enablesReturnKeyAutomatically = NO;
}

- (IBAction)addAction:(id)sender {
    
    UIButton *button = sender;

    if (self.addButonBlock) {
        
        if (button.selected) {
            
            self.addButonBlock(WCShowInputView);
            
            [self.sendBtn setImage:[UIImage imageNamed:@"icon_add_more"] forState:UIControlStateNormal];
            
        } else {
            
            self.addButonBlock(WCShowSystemKeybord);
            
            
            [self.sendBtn setImage:[UIImage imageNamed:@"keyborad"] forState:UIControlStateNormal];
        }
    }

     button.selected = !button.isSelected;
    
}

@end
