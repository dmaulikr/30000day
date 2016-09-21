//
//  STShowTextView.h
//  30000day
//
//  Created by GuoJia on 16/9/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STShowTextView : UIView

@property (nonatomic,assign) id delegate;
//开始展示内容
- (void)showContent:(NSAttributedString *)mediaContent;
//根据文字内容以及显示宽度算出本视图的高度（注：如果文字超过约定的最高的高度(80+)的话返回最高的高度多余文字显示...并且显示一个按钮【全文】）
+ (CGFloat)heightContentViewWith:(NSAttributedString *)mediaContent contenteViewWidth:(CGFloat)width;

@end
