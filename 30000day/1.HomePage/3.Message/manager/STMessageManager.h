//
//  STMessageManager.h
//  30000day
//
//  Created by GuoJia on 16/3/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STMessageManager : NSObject

+ (STMessageManager *)sharedManager;

@property(nonatomic, strong) AVIMClient *client;

//这个方法要在初始化之后进行调用(目的是配置当前聊天的服务器)
- (void)configManagerWitUserId:(NSString *)userId
                       success:(void (^)(BOOL))success
                       callback:(void (^)(AVIMConversation *,AVIMTypedMessage *))callback;
//查询新消息
- (void)queryMessagesWithLimit:(NSUInteger)limit
                      callback:(AVIMArrayResultBlock)callback;

//查询消息
- (void)queryMessagesBeforeId:(NSString *)messageId
                    timestamp:(int64_t)timestamp
                        limit:(NSUInteger)limit
                     callback:(AVIMArrayResultBlock)callback;

//发送消息
- (void)sendMessageMessage:(AVIMTypedMessage *)typeMessage
               sendSuccess:(void (^)(BOOL,AVIMTypedMessage *))sendSuccess
                  callback:(void (^)(AVIMConversation *,AVIMTypedMessage *))callback;

//查询当前的
- (void)queryCurrentConversation;

@end
