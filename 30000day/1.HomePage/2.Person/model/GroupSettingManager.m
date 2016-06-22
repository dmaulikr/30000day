
//
//  GroupSettingManager.m
//  30000day
//
//  Created by GuoJia on 16/6/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "GroupSettingManager.h"
#import "PersonInformationsManager.h"
#import "STFriendsViewController.h"
#import "CDChatManager.h"
#import "CDConversationStore.h"
#import "AVIMNoticationMessage.h"

@implementation GroupSettingManager

//新建一个群
+ (void)createNewGroupChatFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId callBack:(void (^)(BOOL success,NSError *error,AVIMConversation *conversation))callBack {
    
    if ([Common isObjectNull:fromClientId]) {//如果用户ID不存在，则返回
        
        callBack(NO,[Common errorWithString:@"用户ID不存在"],nil);
        
        return;
    }
    
    STFriendsViewController *controller = [[STFriendsViewController alloc] init];
    
    controller.userModelArray = [PersonInformationsManager shareManager].informationsArray;//拿到之前赋值的
    
    controller.title = @"选择联系人";
    
    __weak typeof(controller) weakController = controller;
    
    //点击回调
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {
        
            NSMutableDictionary *dictonary = [UserInformationModel attributesWithInformationModelArray:modifiedArray userProfile:STUserAccountHandler.userProfile chatType:@1];
        
            [memberClientIdArray addObject:fromClientId];//注意这里
        
            [[CDChatManager sharedManager] createConversationWithMembers:memberClientIdArray type:CDConversationTypeGroup unique:NO attributes:dictonary callback:^(AVIMConversation *conversation, NSError *error) {
        
                if ([Common isObjectNull:error]) {

                    [weakController.navigationController popViewControllerAnimated:NO];
                    
                    callBack(YES,error,conversation);
                    
                    AVIMNoticationMessage *message = [AVIMNoticationMessage messageWithText:[NSString stringWithFormat:@"%@创建了一个群聊",[conversation memberName:fromClientId]] attachedFilePath:nil attributes:nil];
                    
                    [[CDChatManager sharedManager] sendMessage:message conversation:conversation callback:^(BOOL succeeded, NSError *error) {
                        
                        if (succeeded) {
                            
                            [[CDConversationStore store] updateConversations:@[conversation]];
                        }
                    }];
                    
                } else {
                    
                    callBack(NO,error,nil);
                }
            }];
    }];
    
    [viewController.navigationController pushViewController:controller animated:YES];
}

//添加人
+ (void)addMemberFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId fromConversation:(AVIMConversation * )conversation callBack:(void (^)(BOOL success,NSError *error))callBack {
    
    if ([Common isObjectNull:fromClientId]) {//如果用户ID不存在，则返回
        
        callBack(NO,[Common errorWithString:@"用户ID不存在"]);
        
        return;
    }
    
    STFriendsViewController *controller = [[STFriendsViewController alloc] init];
    
    controller.title = @"添加(不显示已有成员)";
    
    //过滤已有的成员
    NSArray *memberArray = conversation.members;
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[PersonInformationsManager shareManager].informationsArray];
    
    NSMutableArray *indexArray = [NSMutableArray array];//用来暂时存储标记的model
    
    for (int i = 0; i < dataArray.count; i++) {
        
        UserInformationModel *model = dataArray[i];
        
        NSString *string_model = [NSString stringWithFormat:@"%@",model.userId];
        
        if ([memberArray containsObject:string_model]) {//是否存在
            
            [indexArray addObject:model];
        }
    }
    
    [dataArray removeObjectsInArray:indexArray];
    
    controller.userModelArray = dataArray;//拿到之前赋值的

    [viewController.navigationController pushViewController:controller animated:YES];
    
    __weak typeof(controller) weakController = controller;
    
    //添加好友入群
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {
       
        __weak typeof(conversation) weakConversation = conversation;
        
        [conversation addMembersWithClientIds:memberClientIdArray callback:^(BOOL succeeded, NSError *error) {
           
            if (succeeded) {//添加成功
                
                AVIMConversationUpdateBuilder *updateBuilder = [weakConversation newUpdateBuilder];
                
                updateBuilder.attributes = weakConversation.attributes;
                
                NSString *joinGroupChatString = @"";//用来显示到底谁加入到群聊里面了
                
                for (int i = 0; i < modifiedArray.count; i++) {//循环在attributes中设置新加的个人信息
                    
                    UserInformationModel *model = modifiedArray[i];
                    
                    NSMutableDictionary *dictionary = [UserInformationModel dictionaryWithModel:model];
                    
                    [updateBuilder setObject:dictionary forKey:[NSString stringWithFormat:@"%@",model.userId]];
                    
                    if ( i == modifiedArray.count - 1) {
                        
                        joinGroupChatString = [NSString stringWithFormat:@"%@%@",joinGroupChatString,model.originalNickName];
                        
                    } else {
                        
                        joinGroupChatString = [NSString stringWithFormat:@"%@、%@",joinGroupChatString,model.originalNickName];
                    }
                }

                //将更新后的全部属性写回对话
                [weakConversation update:[updateBuilder dictionary] callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                        [[CDConversationStore store] updateConversations:@[weakConversation]];
                        
                        [weakController.navigationController popViewControllerAnimated:YES];

                        callBack(YES,error);
                        
                        //1.要在群里发送暂态消息
                        AVIMNoticationMessage *message = [AVIMNoticationMessage messageWithText:[NSString stringWithFormat:@"%@加入群聊,邀请者为%@",joinGroupChatString,[weakConversation memberName:fromClientId]] attachedFilePath:nil attributes:nil];

                        [[CDChatManager sharedManager] sendMessage:message conversation:weakConversation callback:^(BOOL succeeded, NSError *error) {
                            
                            if (succeeded) {
                                //邀请人要发送通知
                                [STNotificationCenter postNotificationName:STDidSuccessGroupChatSettingSendNotification object:message];
                            }
                            
                        }];
                        
                    } else {//信息添加的失败，要把之前添加进去的人移除,并把可能存在于attributes中的信息也移除
                        
                        [weakConversation removeMembersWithClientIds:memberClientIdArray callback:^(BOOL succeeded, NSError *error) {
                           
                            if (succeeded) {
                                
                                AVIMConversationUpdateBuilder *updateBuilder = [weakConversation newUpdateBuilder];
                                
                                updateBuilder.attributes = weakConversation.attributes;
                                
                                for (int i = 0; i < modifiedArray.count; i++) {//循环在attributes中设置新加的个人信息
                                    
                                    UserInformationModel *model = modifiedArray[i];
                                    
                                    [updateBuilder removeObjectForKey:[NSString stringWithFormat:@"%@",model.userId]];
                                }
                                
                                [weakConversation update:[updateBuilder dictionary] callback:^(BOOL succeeded, NSError *error) {//还原操作
                                   
                                    callBack(NO,[Common errorWithString:@"添加失败"]);
                                    
                                }];
                                
                            } else {//移除之前添加的失败
                                
                                callBack(NO,[Common errorWithString:@"添加失败"]);
                            }
                        }];
                    }
                }];
                
            } else {//添加失败
                
                 callBack(NO,error);
            }
        }];
        
    }];
}

//踢人操作
+ (void)removeMemberFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId fromConversation:(AVIMConversation * )conversation callBack:(void (^)(BOOL success,NSError *error))callBack {
    
    if ([Common isObjectNull:fromClientId]) {//如果用户ID不存在，则返回
        
        callBack(NO,[Common errorWithString:@"用户ID不存在"]);
        
        return;
    }
    
    STFriendsViewController *controller = [[STFriendsViewController alloc] init];
    
    controller.title = @"踢人(显示已有成员)";
    
    //只显示已有的成员
    NSArray *memberArray = conversation.members;
    
    NSMutableArray *newDataArray = [NSMutableArray array];
    
    NSDictionary *dictionary = conversation.attributes;
    
    for (int i = 0; i < memberArray.count; i++) {
        
        NSString *clientId = memberArray[i];
        
        if (![clientId isEqualToString:conversation.creator]) {//不是群主,才会加进去
            
            NSDictionary *subDictionary = [dictionary objectForKey:clientId];
            
            UserInformationModel *model = [UserInformationModel modelWitDictionary:subDictionary];
            
            NSString *userIdString = [NSString stringWithFormat:@"%@",model.userId];
            
            if ([Common isObjectNull:model.originalNickName] || (userIdString.length <= 1)) {
             
                
            } else {
                
                [newDataArray addObject:model];
            }
        }
    }
    
    controller.userModelArray = newDataArray;//拿到之前赋值的
    
    [viewController.navigationController pushViewController:controller animated:YES];
    
    __weak typeof(controller) weakController = controller;
    
    //回调
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {

        __weak typeof(conversation) weakConversation = conversation;
        
        [conversation removeMembersWithClientIds:memberClientIdArray callback:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {//移除成功
                
                NSString *joinGroupChatString = @"";//用来显示到底谁加入到群聊里面了
                
                for (int i = 0; i < modifiedArray.count; i++) {//循环在attributes中移除个人信息
                    
                    UserInformationModel *model = modifiedArray[i];
                    
                    if ( i == modifiedArray.count - 1) {
                        
                        joinGroupChatString = [NSString stringWithFormat:@"%@%@",joinGroupChatString,model.originalNickName];
                        
                    } else {
                        
                        joinGroupChatString = [NSString stringWithFormat:@"%@、%@",joinGroupChatString,model.originalNickName];
                        
                    }
                }
                
                [[CDConversationStore store] updateConversations:@[conversation]];

                [weakController.navigationController popViewControllerAnimated:YES];

                callBack(YES,error);
                
                //1.要在群里发送暂态消息
                AVIMNoticationMessage *message = [AVIMNoticationMessage messageWithText:[NSString stringWithFormat:@"%@被移出群聊,移出者为%@",joinGroupChatString,[weakConversation memberName:fromClientId]] attachedFilePath:nil attributes:nil];

                [[CDChatManager sharedManager] sendMessage:message conversation:weakConversation callback:^(BOOL succeeded, NSError *error) {

                    if (succeeded) {
                        //踢人成功后发送通知
                        [STNotificationCenter postNotificationName:STDidSuccessGroupChatSettingSendNotification object:message];
                    }
                }];
                
            } else {//添加失败
                
                callBack(NO,error);
            }
        }];
        
    }];
}

//修改群名字
+ (void)modifiedGroupChatNameWithName:(NSString *)newName fromConversation:(AVIMConversation *)conversation fromClientId:(NSString *)fromClientId callback:(void (^)(BOOL succeeded,NSError *error))callback {
    
    if ([Common isObjectNull:fromClientId]) {//如果用户ID不存在，则返回
        
        callback(NO,[Common errorWithString:@"用户ID不存在"]);
        
        return;
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (newName) {
        
        [dictionary setObject:newName forKey:@"name"];
    }
    
    [conversation update:dictionary callback:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            //1.要在群里发送暂态消息
            
            AVIMNoticationMessage *message = [AVIMNoticationMessage messageWithText:[NSString stringWithFormat:@"%@把群名修改为%@",[conversation memberName:fromClientId],newName] attachedFilePath:nil attributes:nil];
            
            [[CDChatManager sharedManager] sendMessage:message conversation:conversation callback:^(BOOL succeeded, NSError *error) {
                
                if (succeeded) {
                    
                    [STNotificationCenter postNotificationName:STDidSuccessGroupChatSettingSendNotification object:message];
                }
            }];
            
        } else {
            
            
        }
        
        callback(succeeded,error);//回调
    }];
}

//给某个特定的conversation的attributes增加或者修改键值对
+ (void)setAttributesKeyValueFromConversation:(AVIMConversation *)conversation value:(id)value key:(NSString *)key successedSentMessageBody:(NSString *)messageBody fromClientId:(NSString *)fromClientId callback:(void (^)(BOOL succeeded,NSError *error))callback {
    
    if ([Common isObjectNull:fromClientId]) {//如果用户ID不存在，则返回
        
        callback(NO,[Common errorWithString:@"用户ID不存在"]);
        
        return;
    }
    
    AVIMConversationUpdateBuilder *updateBuilder = [conversation newUpdateBuilder];
    
    // ---------  非常重要！！！--------------
    // 将所有属性转交给 updateBuilder 统一处理。
    // 如果缺失这一步，下面没有改动过的属性，如上例中的 isSticky，
    // 在保存后会被删除。
    // -------------------------------------
    updateBuilder.attributes = conversation.attributes;
    
    // 将 type 值改为 public
    [updateBuilder setObject:value forKey:key];
    
    // 将更新后的全部属性写回对话
    [conversation update:[updateBuilder dictionary] callback:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [[CDConversationStore store] updateConversations:@[conversation]];
            
            //1.要在群里发送暂态消息
            
        } else {
            
            
        }
        
        callback(succeeded,error);
    }];
}


@end
