//
//  GroupSettingManager.h
//  30000day
//
//  Created by GuoJia on 16/6/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  邀请人进群，踢人出群，各种群设置，创建群

#import <Foundation/Foundation.h>
#import "AVIMConversation+Custom.h"

@interface GroupSettingManager : NSObject

//新建一个群
+ (void)createNewGroupChatFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId callBack:(void (^)(BOOL success,NSError *error))callBack;

//添加人
+ (void)addMemberFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId fromConversation:(AVIMConversation * )conversation callBack:(void (^)(BOOL success,NSError *error))callBack;

//踢人操作
+ (void)removeMemberFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId fromConversation:(AVIMConversation * )conversation callBack:(void (^)(BOOL success,NSError *error))callBack;



@end
