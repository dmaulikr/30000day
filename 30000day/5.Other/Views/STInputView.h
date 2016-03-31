//
//  STInputView.h
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  封装的自定义键盘

#import <UIKit/UIKit.h>

typedef enum {
    
    STInputViewButtonPictureType,
    STInputViewButtonPhotoType,
    STInputViewButtonSendType
    
}STInputViewButtonClickType;

@interface STInputView : UIView

@property (nonatomic,strong) UITextView *textView;

@property (nonatomic,copy) void (^buttonClickBlock)(STInputViewButtonClickType type);

@end
