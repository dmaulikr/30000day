//
//  NewFriendManager.m
//  30000day
//
//  Created by GuoJia on 16/5/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NewFriendManager.h"
#import "CDChatManager.h"
#import "UserInformationModel.h"

@interface NewFriendManager ()

@end

@implementation NewFriendManager

+ (void)subscribePresenceToUserWithUserProfile:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback {
    
    if ([Common isObjectNull:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]]) {//为空
        //查询conversation
        [[CDChatManager sharedManager] fetchConversationWithOtherId:[NSString stringWithFormat:@"%@",model.userId] attributes:[UserInformationModel attributesDictionay:model userProfile:STUserAccountHandler.userProfile] callback:^(AVIMConversation *conversation, NSError *error) {
            
            if (![Common isObjectNull:error]) {
                
                callback(NO,error);
                
            } else {
                
                AVIMTextMessage *messgage = [AVIMTextMessage messageWithText:REQUEST_TYPE attributes:nil];
                
                [conversation sendMessage:messgage options:AVIMMessageSendOptionNone callback:^(BOOL succeeded, NSError *error) {
                    
                    callback(succeeded,error);
                    
                }];
            }
        }];
   
    } else {//有错误
        
        NSError *error = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]}];
        
        callback(NO,error);
    }
}

+ (void)acceptPresenceSubscriptionRequestFrom:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback {
    
     if ([Common isObjectNull:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]]) {//为空
    
         //查询conversation
         [[CDChatManager sharedManager] fetchConversationWithOtherId:[NSString stringWithFormat:@"%@",model.userId] attributes:[UserInformationModel attributesDictionay:model userProfile:STUserAccountHandler.userProfile] callback:^(AVIMConversation *conversation, NSError *error) {
             
             if (![Common isObjectNull:error]) {
                 
                 callback(NO,error);
                 
             } else {
                 
                 AVIMTextMessage *messgage = [AVIMTextMessage messageWithText:ACCEPT_TYPE attributes:nil];
                 
                 [conversation sendMessage:messgage options:AVIMMessageSendOptionNone callback:^(BOOL succeeded, NSError *error) {
                     
                     callback(succeeded,error);
                     
                 }];
             }
         }];
         
     } else {
        
         NSError *error = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]}];
         
         callback(NO,error);
 
     }    
}

+ (void)drictRefresh:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback {
    
    if ([Common isObjectNull:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]]) {//为空
        
        //查询conversation
        [[CDChatManager sharedManager] fetchConversationWithOtherId:[NSString stringWithFormat:@"%@",model.userId] attributes:[UserInformationModel attributesDictionay:model userProfile:STUserAccountHandler.userProfile] callback:^(AVIMConversation *conversation, NSError *error) {
            
            if (![Common isObjectNull:error]) {
                
                callback(NO,error);
                
            } else {
                
                AVIMTextMessage *messgage = [AVIMTextMessage messageWithText:DRECT_TYPE attributes:nil];
                
                [conversation sendMessage:messgage options:AVIMMessageSendOptionNone callback:^(BOOL succeeded, NSError *error) {
                    
                    callback(succeeded,error);
                }];
            }
        }];
        
    } else {
        
        NSError *error = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:[UserInformationModel errorStringWithModel:model userProfile:STUserAccountHandler.userProfile]}];
        
        callback(NO,error);        
    }
}

@end
