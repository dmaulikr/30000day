//
//  XHMessageDisplayNotificationTextView.h
//  30000day
//
//  Created by GuoJia on 16/6/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHMessageDisplayNotificationTextView : UIView

/**
 * 显示通知类型消息正文的label
 *
 */
@property (nonatomic,weak,readonly) UILabel *displayNotificationTextLabel;

+ (CGFloat)textViewHeightWithWidth:(CGFloat)width withFont:(UIFont *)font;

@end
