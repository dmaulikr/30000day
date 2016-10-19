//
//  STMediumDetailController.h
//  30000day
//
//  Created by GuoJia on 16/8/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  自媒体详情

#import "STRefreshViewController.h"
#import "STMediumModel.h"

@interface STMediumDetailController : STRefreshViewController

@property (nonatomic,strong) NSNumber *mediumMessageId;//自媒体消息ID
@property (nonatomic,strong) STMediumModel *mixedMediumModel;//传过来的模型，没经过处理的
@property (nonatomic,assign) BOOL isOriginWedia;//YES:表示原创自媒体，NO表示转发的自媒体
@property (nonatomic,strong) NSNumber *writerId;//本条自媒体发送者id
@property (nonatomic,copy)   void (^deleteBock)();
//后加的
@property (nonatomic,strong) NSNumber   *visibleType;//公开还是好友那里,用在回复是发送消息

@end
