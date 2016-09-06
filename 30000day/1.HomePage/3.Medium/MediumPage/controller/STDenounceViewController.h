//
//  STDenounceViewController.h
//  30000day
//
//  Created by GuoJia on 16/9/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  举报界面

#import "STRefreshViewController.h"
#import "STMediumModel.h"

@interface STDenounceViewController : STRefreshViewController

@property (nonatomic,strong) STMediumModel *retweeted_status;//经过处理的
@property (nonatomic,strong) NSNumber *writerId;//本条自媒体发送者id

@end
