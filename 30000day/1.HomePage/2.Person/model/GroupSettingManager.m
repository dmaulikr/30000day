
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

@implementation GroupSettingManager

//新建一个群
+ (void)createNewGroupChatFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId callBack:(void (^)(BOOL success,NSError *error))callBack {
    
    STFriendsViewController *controller = [[STFriendsViewController alloc] init];
    
    controller.userModelArray = [PersonInformationsManager shareManager].informationsArray;//拿到之前赋值的
    
    controller.title = @"选择联系人";
    
    STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:controller];
    
    //点击回调
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {
        
            NSMutableDictionary *dictonary = [UserInformationModel attributesWithInformationModelArray:modifiedArray userProfile:STUserAccountHandler.userProfile chatType:@1];
        
            [memberClientIdArray addObject:fromClientId];//注意这里
        
            [[CDChatManager sharedManager] createConversationWithMembers:memberClientIdArray type:CDConversationTypeGroup unique:NO attributes:dictonary callback:^(AVIMConversation *conversation, NSError *error) {
        
                if ([Common isObjectNull:error]) {
        
                    [navigationController dismissViewControllerAnimated:YES completion:nil];
                    
                    callBack(YES,error);
        
                    //1.并发送一条群创建成功暂态消息
                    
                    
                } else {
                    
                    callBack(NO,error);
                }
            }];
    }];
    
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

//添加人
+ (void)addMemberFromController:(UIViewController *)viewController fromClientId:(NSString *)fromClientId fromConversation:(AVIMConversation * )conversation callBack:(void (^)(BOOL success,NSError *error))callBack {
    
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
    
    STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:controller];
    
    [viewController presentViewController:navigationController animated:YES completion:nil];
    
    //添加好友入群
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {
       
        __weak typeof(conversation) weakConversation = conversation;
        
        [conversation addMembersWithClientIds:memberClientIdArray callback:^(BOOL succeeded, NSError *error) {
           
            if (succeeded) {//添加成功
                
                AVIMConversationUpdateBuilder *updateBuilder = [weakConversation newUpdateBuilder];
                
                updateBuilder.attributes = weakConversation.attributes;
                
                for (int i = 0; i < modifiedArray.count; i++) {//循环在attributes中设置新加的个人信息
                    
                    UserInformationModel *model = modifiedArray[i];
                    
                    NSMutableDictionary *dictionary = [UserInformationModel dictionaryWithModel:model];
                    
                    [updateBuilder setObject:dictionary forKey:[NSString stringWithFormat:@"%@",model.userId]];
                }

                //将更新后的全部属性写回对话
                [weakConversation update:[updateBuilder dictionary] callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                        [[CDConversationStore store] updateConversations:@[weakConversation]];
                        
                        [navigationController dismissViewControllerAnimated:YES completion:nil];

                        callBack(YES,error);
                        
                        //1.要在群里发送暂态消息
                        
                        
                        
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
            
            [newDataArray addObject:model];
        }
    }
    
    controller.userModelArray = newDataArray;//拿到之前赋值的
    
    STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:controller];
    
    [viewController presentViewController:navigationController animated:YES completion:nil];
    //回调
    [controller setDoneBlock:^(UIViewController *viewController, NSMutableArray *memberClientIdArray, NSMutableArray *modifiedArray) {

        __weak typeof(conversation) weakConversation = conversation;
        
        [conversation removeMembersWithClientIds:memberClientIdArray callback:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {//移除成功
                
                AVIMConversationUpdateBuilder *updateBuilder = [weakConversation newUpdateBuilder];
                
                updateBuilder.attributes = weakConversation.attributes;
                
                for (int i = 0; i < modifiedArray.count; i++) {//循环在attributes中移除个人信息
                    
                    UserInformationModel *model = modifiedArray[i];
                    
                    [updateBuilder removeObjectForKey:[NSString stringWithFormat:@"%@",model.userId]];//移除
                }
                
                //将更新后的全部属性写回对话
                [weakConversation update:[updateBuilder dictionary] callback:^(BOOL succeeded, NSError *error) {
                    
                    if (succeeded) {
                        
                        [[CDConversationStore store] updateConversations:@[weakConversation]];
                        
                        [navigationController dismissViewControllerAnimated:YES completion:nil];
                        
                        callBack(YES,error);
                        //1.要在群里发送暂态消息
                        
                        
                        
                    } else {//移除信息添加的失败，要把之前添加进去的人移除,并把可能存在于attributes中的信息也移除
                        
                        [weakConversation addMembersWithClientIds:memberClientIdArray callback:^(BOOL succeeded, NSError *error) {
                            
                            if (succeeded) {
                                
                                AVIMConversationUpdateBuilder *updateBuilder = [weakConversation newUpdateBuilder];
                                
                                updateBuilder.attributes = weakConversation.attributes;
                                
                                for (int i = 0; i < modifiedArray.count; i++) {//循环在attributes中设置新加的个人信息
                                    
                                    UserInformationModel *model = modifiedArray[i];
                                    
                                    NSMutableDictionary *dictionary = [UserInformationModel dictionaryWithModel:model];
                                    
                                    [updateBuilder setObject:dictionary forKey:[NSString stringWithFormat:@"%@",model.userId]];
                                }
                                
                                [weakConversation update:[updateBuilder dictionary] callback:^(BOOL succeeded, NSError *error) {//还原操作
                                    
                                    callBack(NO,[Common errorWithString:@"移除失败"]);
                                }];
                                
                            } else {//移除之前添加的失败
                                
                                callBack(NO,[Common errorWithString:@"移除失败"]);
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


@end


//更新对话


//1.邀请人

//2.踢人

//3.群公告，群名称