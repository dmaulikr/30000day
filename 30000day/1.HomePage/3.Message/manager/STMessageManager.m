//
//  STMessageManager.m
//  30000day
//
//  Created by GuoJia on 16/3/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMessageManager.h"

@interface STMessageManager () <AVIMClientDelegate>
@property(nonatomic, retain) AVIMConversation *currentConversation;

@property(nonatomic,copy)void(^sendMessageBlock)(AVIMConversation *,AVIMTypedMessage *);

@end

@implementation STMessageManager

+ (STMessageManager *)sharedManager {
    
    static dispatch_once_t once;
    
    static STMessageManager *tool = nil;
    
    dispatch_once(&once, ^{
        
        tool = [[STMessageManager alloc] init];
        
        tool.client = [[AVIMClient alloc] initWithClientId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId]];
        
        tool.client.messageQueryCacheEnabled = YES;
        
        tool.client.delegate = tool;
    });
    
    return tool;
}

- (void)configManagerWitUserId:(NSString *)userId
                       success:(void (^)(BOOL))success
                      callback:(void (^)(AVIMConversation *,AVIMTypedMessage *))callback {
    //保存回调函数
    self.sendMessageBlock = callback;
    
    //开启聊天
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
       
        if (succeeded) {
            
            AVIMConversationQuery *query = [self.client conversationQuery];
            
            [query whereKey:@"m" containsAllObjectsInArray:@[self.client.clientId,userId]];//self.client.clientId,
            
            [query whereKey:@"m" sizeEqualTo:2];
            
            //[query whereKey:AVIMAttr(@"customConversationType")  equalTo:@(1)];
            query.cachePolicy = kAVCachePolicyCacheElseNetwork;
            
            [AVOSCloud setAllLogsEnabled:YES];
            
            // 执行查询
            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
                if (objects.count == 0) {
                    //NSDictionary *attributes = @{ @"customConversationType": @(1) };
                    [self.client createConversationWithName:@"" clientIds:@[userId] attributes:nil options:AVIMConversationOptionNone callback:^(AVIMConversation *conversation, NSError *error) {
                        self.currentConversation = conversation;
                    }];
                    
                } else {
                    self.currentConversation = [objects objectAtIndex:0];
                }
                
                [self.currentConversation joinWithCallback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        success(YES);
                    } else {
                        success(NO);
                    }
                }];
            }];
        
        } else {
            success(NO);
        }
        
    }];
}

- (void)queryMessagesWithLimit:(NSUInteger)limit
                      callback:(AVIMArrayResultBlock)callback {
    [self.currentConversation queryMessagesWithLimit:limit callback:^(NSArray *objects, NSError *error) {
        callback(objects,error);
    }];
}

- (void)queryMessagesBeforeId:(NSString *)messageId
                    timestamp:(int64_t)timestamp
                        limit:(NSUInteger)limit
                     callback:(AVIMArrayResultBlock)callback {
    [self.currentConversation queryMessagesBeforeId:messageId timestamp:timestamp limit:limit callback:^(NSArray *objects, NSError *error) {
        callback(objects,error);
    }];
}

- (void)sendMessageMessage:(AVIMTypedMessage *)typeMessage
               sendSuccess:(void (^)(BOOL sucess,AVIMTypedMessage *))sendSuccess
                  callback:(void (^)(AVIMConversation *,AVIMTypedMessage *))callback{
    //1.存储发送消息的回调
    self.sendMessageBlock = callback;
    [self.currentConversation sendMessage:typeMessage callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            sendSuccess(YES,typeMessage);
        } else {
            sendSuccess(NO,nil);
        }
    }];
}

//查询当前的
- (void)queryCurrentConversation {
    AVIMConversationQuery *query = [self.client conversationQuery];
    [query whereKey:@"m" containsAllObjectsInArray:@[self.client.clientId]];
    [query whereKey:@"m" sizeEqualTo:2];
    //[query whereKey:AVIMAttr(@"customConversationType")  equalTo:@(1)];
    query.cachePolicy = kAVCachePolicyCacheElseNetwork;
    [AVOSCloud setAllLogsEnabled:YES];
    // 执行查询
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
        
    }];
}

#pragma  mark --- AVIMClientDelegate
// 接收消息的回调函数
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    if ([message.conversationId isEqualToString:self.currentConversation.conversationId]) {//当前对话的消息
        self.sendMessageBlock(conversation,message);
    } else {//别的对话ID发过来的信息
        NSLog(@"新消息");
    }
}


@end
