//
//  CommentView.h
//  30000day
//
//  Created by GuoJia on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView

@property (nonatomic,copy) void (^clickBlock)();

@property (nonatomic,strong) UIImageView *showImageView;

@property (nonatomic,strong) UILabel *showLabel;

@property (nonatomic,assign,getter=isSelected) BOOL selected;//是否被选中，默认是NO

- (CGFloat)getLabelWidthWithText:(NSString *)text textHeight:(CGFloat)textHeight;

@end
