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
@property (nonatomic,strong) NSNumber   *visibleType;//公开还是好友那里,用在回复是发送消息
+ (CGFloat)heightView:(STMediumModel *)mixedMediumModel;//mixedMediumModel 没经过处理的模型
- (void)configureViewWithModel:(STMediumModel *)mixedMediumModel;//mixedMediumModel 没经过处理的模型

@end
