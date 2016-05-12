//
//  NewFriendManager.h
//  30000day
//
//  Created by GuoJia on 16/5/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@interface NewFriendManager : STManager

+ (NewFriendManager *)shareManager;

//同步数据
- (void)synchronizedDataFromServer;

//获取角标
- (void)getBadgeNumber:(void (^)(NSInteger badgeNumber))success;

//获取所有的数据
- (void)getDataArray:(void (^)(NSMutableArray *dataArray))success;

//清除申请好友的角标
- (void)cleanApplyFiendBadgeNumber:(void (^)(NSInteger badgerNumber))success;

@end
