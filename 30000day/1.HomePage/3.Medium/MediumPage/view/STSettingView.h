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
+ (CGFloat)heightView:(STMediumModel *)mixedMediumModel;//mixedMediumModel:有可能是原创自媒体模型，也有可能是转发自媒体模型
- (void)configureViewWithModel:(STMediumModel *)mixedMediumModel;//mixedMediumModel:有可能是原创自媒体模型，也有可能是转发自媒体模型

@end
