//
//  MoreInfo.h
//  30000天
//
//  Created by 30000天_001 on 14-12-18.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreInfo : NSObject

@property (nonatomic, copy) NSString * title;//标题

@property (nonatomic, copy) NSString * content;//内容

@property (nonatomic, copy) NSString * date;//日期

@property (nonatomic, copy) NSString * time;//时间

@property (nonatomic, copy) NSString * number;//本地推送标记。

@property (nonatomic, copy) NSString * userid;//用户的账号。这条通知是哪个用户的

@end
