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

//踢人
+ (void)removeMemberFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId fromConversation:(AVIMConversation * )conversation callBack:(void (^)(BOOL success,NSError *error))callBack;

//修改群名字
+ (void)modifiedGroupChatNameWithName:(NSString *)newName fromConversation:(AVIMConversation *)conversation fromClientId:(NSString *)fromClientId callback:(void (^)(BOOL succeeded,NSError *error))callback;

/**
 * 给某个特定的conversation的attributes增加或者修改键值对
 * @param conversation 带更新的conversation
 * @param value conversation的attributes需要设置键值对的值
 * @param key   conversation的attributes需要设置键值对的键
 * @param messageBody 发送成功后发送message（这里暂定为暂态消息）的消息主体
 * @param fromClientId 操作者Id
 */
+ (void)setAttributesKeyValueFromConversation:(AVIMConversation *)conversation value:(id)value key:(NSString *)key successedSentMessageBody:(NSString *)messageBody fromClientId:(NSString *)fromClientId callback:(void (^)(BOOL succeeded,NSError *error))callback;

@end
