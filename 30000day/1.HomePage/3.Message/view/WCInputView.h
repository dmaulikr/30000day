//
//  WCInputView.h
//  weChat
//
//  Created by guojia on 15/6/25.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    WCShowSystemKeybord,
    
    WCShowInputView
    
}WCShowKeybordType;

@interface WCInputView : UIView

+ (instancetype)inputView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIButton *videoButton;

@property (nonatomic,copy) void (^addButonBlock)(WCShowKeybordType type);

@end

//这里要进行深度分装

