//
//  STMediumCommentController.h
//  30000day
//
//  Created by GuoJia on 16/8/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  自媒体评论

#import "STRefreshViewController.h"

@interface STMediumCommentController : STRefreshViewController

@property (nonatomic,assign) NSInteger  weMediaId;
@property (nonatomic,strong) NSNumber   *userId;//第一层发送自媒体的人Id,用在回复是发送消息
@property (nonatomic,copy)   NSString   *originHeadImg;//第一层发送自媒体的人的头像，用在回复是发送消息
@property (nonatomic,copy)   NSString   *originNickName;//第一层发送自媒体的人的昵称，用在回复是发送消息
@property (nonatomic,strong) NSNumber   *visibleType;//公开还是好友那里,用在回复是发送消息

@end
