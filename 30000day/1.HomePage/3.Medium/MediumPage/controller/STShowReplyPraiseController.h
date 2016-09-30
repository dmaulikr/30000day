//
//  STShowReplyPraiseController.h
//  30000day
//
//  Created by GuoJia on 16/9/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  显示点赞和评论的控制器

#import "STRefreshViewController.h"

@interface STShowReplyPraiseController : STRefreshViewController

@property (nonatomic,strong) NSNumber *visibleType;//类型
@property (nonatomic,strong) NSNumber *messageType;//消息类型,99:点赞 98:回复

@end
