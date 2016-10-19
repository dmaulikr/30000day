//
//  STMediumTypeController.h
//  30000day
//
//  Created by GuoJia on 16/7/25.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  主界面

#import "STRefreshViewController.h"

@interface STMediumTypeController : STRefreshViewController

@property (nonatomic,strong) NSNumber *visibleType;//0自己，1好友 2公开
@property (nonatomic,copy) void (^showRedBadgeBlock)(BOOL isShow,NSNumber *visibleType,NSNumber *messageType);

@end
