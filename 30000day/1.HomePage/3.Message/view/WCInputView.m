//
//  WCInputView.m
//  weChat
//
//  Created by guojia on 15/6/25.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import "WCInputView.h"
@implementation WCInputView
+ (instancetype)inputView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil] lastObject];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.enablesReturnKeyAutomatically = NO;
}

@end
