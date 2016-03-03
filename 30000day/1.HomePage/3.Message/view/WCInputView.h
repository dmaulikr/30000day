//
//  WCInputView.h
//  weChat
//
//  Created by guojia on 15/6/25.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInputView : UIView

+ (instancetype)inputView;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

//这里要进行深度分装

