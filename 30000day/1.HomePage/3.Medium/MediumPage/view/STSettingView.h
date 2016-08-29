//
//  STSettingView.h
//  30000day
//
//  Created by GuoJia on 16/8/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  封装的转发、点赞、评论view

#import <UIKit/UIKit.h>
#import "STMediumModel.h"

@interface STSettingView : UIView

@property (nonatomic,weak) id delegate;
+ (CGFloat)heightView:(STMediumModel *)mediumModel;//高度
- (void)cofigViewWithModel:(STMediumModel *)mediumModel;//配置

@end
