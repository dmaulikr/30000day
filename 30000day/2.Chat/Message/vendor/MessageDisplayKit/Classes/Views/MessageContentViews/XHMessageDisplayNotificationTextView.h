//
//  XHMessageDisplayNotificationTextView.h
//  30000day
//
//  Created by GuoJia on 16/6/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFICATION_TEXT_VIEW_MARGIN 50

#define  KXHNoticationView   SCREEN_WIDTH - 2 * NOTIFICATION_TEXT_VIEW_MARGIN //算XHMessageDisplayNotificationTextView的高度需要传个宽度过去，就是这个作用

#define  KXHNoticationViewStandard   22.0f                      //用来比较的标准 如果 >= 22.0f 表达大于一行，如果 <= 22.0f 比较只有一行

@interface XHMessageDisplayNotificationTextView : UIView

/**
 * 显示通知类型消息正文的label
 *
 */
@property (nonatomic,strong) UILabel *displayNotificationTextLabel;

//给定宽度算高
+ (CGFloat)textViewHeightWithDisplayText:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont *)font;
//给定高度算宽
+ (CGFloat)textViewWidthWithDisplayText:(NSString *)text withHeight:(CGFloat)height withFont:(UIFont *)font;

@end
