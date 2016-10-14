//
//  STMediumRemindDetailController.h
//  30000day
//
//  Created by GuoJia on 16/10/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"

@interface STMediumRemindDetailController : STRefreshViewController

@property (nonatomic,strong) NSNumber *weMediaId;
@property (nonatomic,strong) NSNumber   *visibleType;//公开还是好友那里,（LeanCloud发送提醒消息用到）

@end
