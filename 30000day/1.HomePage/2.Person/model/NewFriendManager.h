//
//  NewFriendManager.h
//  30000day
//
//  Created by GuoJia on 16/5/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  邀请好友，同意好友的请求管理类

#import "STManager.h"

@interface NewFriendManager : STManager

//请求加某人为好友
+ (void)subscribePresenceToUserWithUserProfile:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback;
//同意某人的请求
+ (void)acceptPresenceSubscriptionRequestFrom:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback;
//直接加某人为好友
+ (void)drictRefresh:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback;

@end
