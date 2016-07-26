//
//  CDChatManager.m
//  LeanChat
//
//  Created by lzw on 15/1/21.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDChatManager.h"
#import "CDEmotionUtils.h"
#import "CDSoundManager.h"
#import "CDConversationStore.h"
#import "CDFailedMessageStore.h"
#import "CDMacros.h"
#import "CDChatManager_Internal.h"
#import "AVIMNoticationMessage.h"
#import "CDMediaMessageManager.h"

static CDChatManager *instance;

@interface CDChatManager () <AVIMClientDelegate, AVIMSignatureDataSource>

@property (nonatomic, assign, readwrite) BOOL connect;

@property (nonatomic, strong) NSMutableDictionary *cachedConversations;

@property (nonatomic, strong) NSString *plistPath;

@property (nonatomic, strong) NSMutableDictionary *conversationDatas;

@property (nonatomic, assign) NSInteger totalUnreadCount;

@end

@implementation CDChatManager

#pragma mark - lifecycle

+ (instancetype)sharedManager {
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        instance = [[CDChatManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        [AVIMClient setTimeoutIntervalInSeconds:20];
        // 以下选项也即是说 A 不在线时，有人往A发了很多条消息，下次启动时，不再收到具体的离线消息，而是收到离线消息的数目(未读通知)
//         [AVIMClient setUserOptions:@{AVIMUserOptionUseUnread:@(YES)}];
        _cachedConversations = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (NSString *)databasePathWithUserId:(NSString *)userId {
    
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [libPath stringByAppendingPathComponent:[NSString stringWithFormat:@"com.shutian.30000day.%@.db3", userId]];
}

- (void)openWithClientId:(NSString *)clientId callback:(AVIMBooleanResultBlock)callback {
    
    _clientId = clientId;
    NSString *dbPath = [self databasePathWithUserId:_clientId];
    [[CDConversationStore store] setupStoreWithDatabasePath:dbPath];
    [[CDFailedMessageStore store] setupStoreWithDatabasePath:dbPath];
    self.client = [[AVIMClient alloc] initWithClientId:clientId];//开启单点登录
    self.client.delegate = self;
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        
        if (callback) {
            
            self.connect = YES;
            callback(succeeded, error);
        }
    }];
}

- (void)closeWithCallback:(AVBooleanResultBlock)callback {
    
    [self.client closeWithCallback:callback];
}

#pragma mark ---- 新加的
- (void)fetchConversationWithOtherId:(NSString *)otherId attributes:(NSDictionary *)attributes callback:(AVIMConversationResultBlock)callback {
    
    if ([Common isObjectNull:self.client]) {//非空的
        
        NSLog(@"聊天服务器没有初始化");

    } else {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:self.client.clientId];
        [array addObject:otherId];
        [self fetchConversationWithMembers:array type:CDConversationTypeSingle attributes:attributes callback:callback];
    }
}

- (void)fetchConversationWithMembers:(NSArray *)members type:(CDConversationType)type attributes:(NSDictionary *)attributes callback:(AVIMConversationResultBlock)callback {
    
    if ([members containsObject:self.clientId] == NO) {
        
        NSLog(@"members should contain myself");
        
    } else {
        
        NSSet *set = [NSSet setWithArray:members];
        
        if (set.count != members.count) {//有重复定义的值
            
            NSLog(@"The array has duplicate value");
            
        } else {//无重复定义的值
            
            [self createConversationWithMembers:members type:type unique:YES attributes:attributes callback:callback];
        }
    }
}

- (void)createConversationWithMembers:(NSArray *)members type:(CDConversationType)type unique:(BOOL)unique attributes:(NSDictionary *)attributes callback:(AVIMConversationResultBlock)callback {
    
    NSString *name = nil;
    
    if (type == CDConversationTypeGroup) {
        // 群聊默认名字， 老王、小李
        name = @"群聊";
    }
    
    AVIMConversationOption options;
    
    if (unique) {
        // 如果相同 members 的对话已经存在，将返回原来的对话
        options = AVIMConversationOptionUnique;
        
    } else {
        
        // 创建一个新对话
        options = AVIMConversationOptionNone;
    }
    
    [self.client createConversationWithName:name clientIds:members attributes:attributes options:options callback:callback];
}

#pragma mark - conversation

- (void)fecthConversationWithConversationId:(NSString *)conversationId callback:(AVIMConversationResultBlock)callback {
    
    NSAssert(conversationId.length > 0, @"Conversation id is nil");
    AVIMConversationQuery *q = [self.client conversationQuery];
    q.cachePolicy = kAVCachePolicyNetworkElseCache;
    [q whereKey:@"objectId" equalTo:conversationId];
    [q findConversationsWithCallback: ^(NSArray *objects, NSError *error) {
        
        if (error) {
            
            callback(nil, error);
            
        } else {
            
            if (objects.count == 0) {
                
                callback(nil, [CDChatManager errorWithText:[NSString stringWithFormat:@"conversation of %@ not exists", conversationId]]);
                
            } else {
                
                callback([objects objectAtIndex:0], error);
            }
        }
    }];
}

- (void)fetchConversationWithMembers:(NSArray *)members callback:(AVIMConversationResultBlock)callback {
    
    [self fetchConversationWithMembers:members type:CDConversationTypeGroup attributes:nil callback:callback];
}

- (void)findGroupedConversationsWithBlock:(AVIMArrayResultBlock)block {
    
    [self findGroupedConversationsWithNetworkFirst:NO block:block];
}

- (void)findGroupedConversationsWithNetworkFirst:(BOOL)networkFirst block:(AVIMArrayResultBlock)block {
    
    AVIMConversationQuery *q = [self.client conversationQuery];
    
    if (![Common isObjectNull:self.clientId]) {
        
        [q whereKey:AVIMAttr(CONVERSATION_TYPE) equalTo:@(CDConversationTypeGroup)];
        [q whereKey:kAVIMKeyMember containedIn:@[self.clientId]];
        
        if (networkFirst) {
            
            q.cachePolicy = kAVCachePolicyNetworkElseCache;
            
        } else {
            
            q.cachePolicy = kAVCachePolicyCacheElseNetwork;
            q.cacheMaxAge = 60 * 30; // 半小时
        }
        // 默认 limit 为10
        q.limit = 1000;
        [q findConversationsWithCallback:block];
        
    } else {
        
        block([NSMutableArray array],[Common errorWithString:@"用户ID不存在"]);
    }
}

- (void)fetchConversationsWithConversationIds:(NSSet *)conversationIds callback:(AVIMArrayResultBlock)callback {
    
    if (conversationIds.count > 0) {
        
        AVIMConversationQuery *q = [self.client conversationQuery];
        [q whereKey:@"objectId" containedIn:[conversationIds allObjects]];
        q.cachePolicy = kAVCachePolicyNetworkElseCache;
        q.limit = 1000;  // default limit:10
        [q findConversationsWithCallback:callback];
        
    } else {
        
        callback([NSMutableArray array], nil);
    }
}

#pragma mark - utils

- (void)sendMessage:(AVIMTypedMessage*)message conversation:(AVIMConversation *)conversation callback:(AVBooleanResultBlock)block {
    
    if (self.client.status != AVIMClientStatusOpened) {
        
            NSLog(@"client status is not opened");
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    // 云代码中获取到用户名，来设置推送消息, 老王:今晚约吗？
    
    if (STUserAccountHandler.userProfile.nickName) {
        
        [attributes setObject:STUserAccountHandler.userProfile.nickName forKey:@"username"];
    }
    
    if (message.attributes == nil) {
        
        message.attributes = attributes;
        
    } else {
        
        [attributes addEntriesFromDictionary:message.attributes];
        
        message.attributes = attributes;
    }
    
    [conversation sendMessage:message options:AVIMMessageSendOptionRequestReceipt callback:block];
}

#pragma mark - query msgs

- (void)queryTypedMessagesWithConversation:(AVIMConversation *)conversation timestamp:(int64_t)timestamp limit:(NSInteger)limit block:(AVIMArrayResultBlock)block {
    
    AVIMArrayResultBlock callback = ^(NSArray *messages, NSError *error) {
        
        //以下过滤为了避免非法的消息，引起崩溃
        NSMutableArray *typedMessages = [NSMutableArray array];
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
        for (AVIMTypedMessage *message in messages) {
            
            if ([message isKindOfClass:[AVIMTypedMessage class]]) {
                
                if ([message.text isEqualToString:REQUEST_TYPE]) {//请求添好友
    
                } else if ([message.text isEqualToString:ACCEPT_TYPE]) {//同意请求
                    
                } else if ([message.text isEqualToString:DRECT_TYPE]) {//直接添加好友
                    
                } else { //正常的消息
                    
                    [typedMessages addObject:message];
                    
                    if ([message isKindOfClass:[AVIMImageMessage class]]) {
                        
                        //把图片类型的消息缓存到本地
                        CDMediaMessageModel *model = [[CDMediaMessageModel alloc] init];
                        model.userId = self.clientId;
                        model.conversationId = message.conversationId;
                        model.imageMessageId = message.messageId;
                        model.messageDate = [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp/1000];
                        model.remoteURLString = message.file.url;
                        model.localURLString = message.file.localPath;
                        if ([message.file isDataAvailable]) {
                            model.image = [message.file getData];
                        }
                        [dataArray addObject:model];
                    }
                }
            }
        }
        
        //保存或者刷新
        [[CDMediaMessageManager shareManager] refreshMediaMessageWithModelArray:dataArray userId:self.clientId withConversationId:conversation.conversationId callback:^(BOOL successed, NSError *error) {
            
        }];
        
        block(typedMessages, error);
    };
    
    if (timestamp == 0) {
        // sdk 会设置好 timestamp
        [conversation queryMessagesWithLimit:limit callback:callback];
        
    } else {
        
        [conversation queryMessagesBeforeId:nil timestamp:timestamp limit:limit callback:callback];
    }
}

#pragma mark - remote notification

- (BOOL)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (userInfo[@"convid"]) {
        
        self.remoteNotificationConvid = userInfo[@"convid"];
        return YES;
    }
    
    return NO;
}

#pragma mark - AVIMClientDelegate

- (void)imClientPaused:(AVIMClient *)imClient {
    
    [self updateConnectStatus];
}

- (void)imClientResuming:(AVIMClient *)imClient {
    
    [self updateConnectStatus];
}

- (void)imClientResumed:(AVIMClient *)imClient {
    
    [self updateConnectStatus];
}

#pragma mark - status

// 除了 sdk 的上面三个回调调用了，还在 open client 的时候调用了，好统一处理
- (void)updateConnectStatus {
    
    self.connect = self.client.status == AVIMClientStatusOpened;
    [STNotificationCenter postNotificationName:kCDNotificationConnectivityUpdated object:@(self.connect)];
}

#pragma mark - receive message handle

- (void)receiveMessage:(AVIMTypedMessage *)message conversation:(AVIMConversation *)conversation {
    
    [[CDConversationStore store] insertConversation:conversation];
    
    if (![self.chattingConversationId isEqualToString:conversation.conversationId]) {
        
        // 没有在聊天的时候才增加未读数和设置mentioned
        [[CDConversationStore store] increaseUnreadCountWithConversation:conversation];
        
        if ([self isMentionedByMessage:message]) {
            
            [[CDConversationStore store] updateMentioned:YES conversation:conversation];
        }
        
        [STNotificationCenter postNotificationName:kCDNotificationUnreadsUpdated object:nil];
    }
    
    if (!self.chattingConversationId) {
        
        if (!conversation.muted) {
            
            [[CDSoundManager manager] playLoudReceiveSoundIfNeed];
            [[CDSoundManager manager] vibrateIfNeed];
        }
    }
    
    [STNotificationCenter postNotificationName:kCDNotificationMessageReceived object:message];
    
    //增加缓存
    CDMediaMessageModel *model = [[CDMediaMessageModel alloc] init];
    model.userId = self.clientId;
    model.conversationId = message.conversationId;
    model.imageMessageId = message.messageId;
    model.messageDate = [NSDate dateWithTimeIntervalSince1970:message.sendTimestamp / 1000];
    model.remoteURLString = message.file.url;
    model.localURLString = message.file.localPath;
    if ([message.file isDataAvailable]) {//如果可以获取到数据
        model.image = [message.file getData];
    }
    [[CDMediaMessageManager shareManager] addMediaMessageWithModel:model];
}

#pragma mark - AVIMMessageDelegate
//接受自定义消息
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message {
    //可以看做跟 AVIMTypedMessage 两个频道。构造消息和收消息的接口都不一样，互不干扰。
}

// content : "{\"_lctype\":-1,\"_lctext\":\"sdfdf\"}"  sdk 会解析好
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    
    NSString *text = message.text;
    
    if ([text isEqualToString:REQUEST_TYPE]) {
        
        [STNotificationCenter postNotificationName:STDidApplyAddFriendSendNotification object:nil];
        
        if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {//如果有人申请加好友，那么就存下
            
            [Common saveAppIntegerDataForKey:USER_BADGE_NUMBER withObject:1];
        }
        
    } else if ([text isEqualToString:ACCEPT_TYPE]) {
        
        [STNotificationCenter postNotificationName:STDidApplyAddFriendSuccessSendNotification object:nil];
        
    } else if ([text isEqualToString:DRECT_TYPE]) {
        
        [STNotificationCenter postNotificationName:STDidApplyAddFriendSuccessSendNotification object:nil];
        
    } else {//普通版消息
        
        if (message.messageId) {
            
            if (conversation.creator == nil && [[CDConversationStore store] isConversationExists:conversation] == NO) {
                
                [conversation fetchWithCallback:^(BOOL succeeded, NSError *error) {
                    
                    if (error) {
                        
                        DLog(@"%@", error);
                        
                    } else {
                        
                        [self receiveMessage:message conversation:conversation];
                    }
                }];
                
            } else {
                
                [self receiveMessage:message conversation:conversation];
            }
            
        } else {
            
            DLog(@"Receive Message , but MessageId is nil");
        }
    }
}

- (void)conversation:(AVIMConversation *)conversation messageDelivered:(AVIMMessage *)message {
    
    DLog();
    
    if (message != nil) {
        
        [STNotificationCenter postNotificationName:kCDNotificationMessageDelivered object:message];
    }
}

- (void)conversation:(AVIMConversation *)conversation didReceiveUnread:(NSInteger)unread {
    
    // 需要开启 AVIMUserOptionUseUnread 选项，见 init
    DLog(@"conversatoin:%@ didReceiveUnread:%@", conversation, @(unread));
    
    [conversation markAsReadInBackground];
}

#pragma mark - AVIMClientDelegate

- (void)conversation:(AVIMConversation *)conversation membersAdded:(NSArray *)clientIds byClientId:(NSString *)clientId {
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation membersRemoved:(NSArray *)clientIds byClientId:(NSString *)clientId {
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation invitedByClientId:(NSString *)clientId {
    DLog();
}

- (void)conversation:(AVIMConversation *)conversation kickedByClientId:(NSString *)clientId {
    
    [self deleteAndDeleteConversation:conversation callBack:^(BOOL successed, NSError *error) {
        //被移除群，暂时重新刷新界面
        if (successed) {
         
            [STNotificationCenter postNotificationName:STDidSuccessQuitGroupChatSendNotification object:nil];
        }
    }];
}

/* 如果开启了单点登陆，需要使用代码方法进行监控 */
- (void)client:(AVIMClient *)client didOfflineWithError:(NSError *)error {
    
    if ([error code] == 4111) {
        
        //适当的弹出友好提示，告知当前用户的 Client Id 在其他设备上登陆了
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"检测到您已在其他设备登录，请重新登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }
}

#pragma mark - signature

- (id)conversationSignWithSelfId:(NSString *)clientId conversationId:(NSString *)conversationId targetIds:(NSArray *)targetIds action:(NSString *)action {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:clientId forKey:@"self_id"];
    
    if (conversationId) {
        
        [dict setObject:conversationId forKey:@"convid"];
    }
    
    if (targetIds) {
        
        [dict setObject:targetIds forKey:@"targetIds"];
    }
    
    if (action) {
        
        [dict setObject:action forKey:@"action"];
    }
    
    //这里是从云代码获取签名，也可以从你的服务器获取
    return [AVCloud callFunction:@"conv_sign" withParameters:dict];
}

- (AVIMSignature *)getAVSignatureWithParams:(NSDictionary *)fields peerIds:(NSArray *)peerIds {
    
    AVIMSignature *avSignature = [[AVIMSignature alloc] init];
    
    NSNumber *timestampNum = [fields objectForKey:@"timestamp"];
    
    long timestamp = [timestampNum longValue];
    
    NSString *nonce = [fields objectForKey:@"nonce"];
    
    NSString *signature = [fields objectForKey:@"signature"];
    
    [avSignature setTimestamp:timestamp];
    
    [avSignature setNonce:nonce];
    
    [avSignature setSignature:signature];
    
    return avSignature;
}

- (AVIMSignature *)signatureWithClientId:(NSString *)clientId
                          conversationId:(NSString *)conversationId
                                  action:(NSString *)action
                       actionOnClientIds:(NSArray *)clientIds {
    do {
        if ([action isEqualToString:@"open"] || [action isEqualToString:@"start"]) {
            action = nil;
            break;
        }
        if ([action isEqualToString:@"remove"]) {
            action = @"kick";
            break;
        }
        if ([action isEqualToString:@"add"]) {
            action = @"invite";
            break;
        }
    } while (0);
    
    NSDictionary *dict = [self conversationSignWithSelfId:clientId conversationId:conversationId targetIds:clientIds action:action];
    
    if (dict != nil) {
        
        return [self getAVSignatureWithParams:dict peerIds:clientIds];
        
    } else {
        
        return nil;
    }
}


+ (NSError *)errorWithText:(NSString *)text {
    
    return [NSError errorWithDomain:@"LeanChatLib" code:0 userInfo:@{NSLocalizedDescriptionKey:text}];
}

#pragma mark - Conversation cache

- (NSString *)localKeyWithConversationId:(NSString *)conversationId {
    
    return [NSString stringWithFormat:@"conv_%@", conversationId];
}

- (AVIMConversation *)lookupConversationById:(NSString *)conversationId {
    //FIXME:the convid is not exist in the table when log out
    AVIMConversation *conversation = [self.client conversationForId:conversationId];
    return conversation;
}

- (void)cacheConversationsWithIds:(NSMutableSet *)conversationIds callback:(AVBooleanResultBlock)callback {
    
    NSMutableSet *uncacheConversationIds = [[NSMutableSet alloc] init];
    
    for (NSString *conversationId in conversationIds) {
        
        AVIMConversation  *conversation = [self lookupConversationById:conversationId];
        
        if (conversation == nil) {
            
            [uncacheConversationIds addObject:conversationId];
        }
    }
    
    [self fetchConversationsWithConversationIds:uncacheConversationIds callback: ^(NSArray *objects, NSError *error) {
        
        if (error) {
            
            callback(NO, error);
            
        } else {
            
            callback(YES, nil);
        }
    }];
}

- (void)selectOrRefreshConversationsWithBlock:(AVIMArrayResultBlock)block {
    
//    NSArray *conversations = [[CDConversationStore store] selectAllConversations];
//    
//    __block NSInteger refreshedFromServer = 0;
//    
//    if (refreshedFromServer == 0 && self.connect) {
//        
//        NSMutableSet *conversationIds = [NSMutableSet set];
//        
//        for (AVIMConversation *conversation in conversations) {
//            
//            [conversationIds addObject:conversation.conversationId];
//        }
//        
//        [self fetchConversationsWithConversationIds:conversationIds callback:^(NSArray *objects, NSError *error) {
//            
//            if (error) {
//                
//                block(conversations, nil);
//                
//            } else {
//
//                [[CDConversationStore store] updateConversations:objects];
//                
//                NSArray *dataArray = [[CDConversationStore store] selectAllConversations];
//            
//                block(dataArray, nil);
//            }
//            
//            refreshedFromServer = 1;
//        }];
//        
//    } else {
//        
//        block(conversations, nil);
//    }
    
    static BOOL refreshedFromServer = NO;
    NSArray *conversations = [[CDConversationStore store] selectAllConversations];
    if (refreshedFromServer == NO && self.connect) {
        NSMutableSet *conversationIds = [NSMutableSet set];
        for (AVIMConversation *conversation in conversations) {
            [conversationIds addObject:conversation.conversationId];
        }
        [self fetchConversationsWithConversationIds:conversationIds callback:^(NSArray *objects, NSError *error) {
            if (error) {
                block(conversations, nil);
            } else {
                refreshedFromServer = YES;
                [[CDConversationStore store] updateConversations:objects];
                block([[CDConversationStore store] selectAllConversations], nil);
            }
        }];
    } else {
        block(conversations, nil);
    }
}

- (void)findRecentConversationsWithBlock:(CDRecentConversationsCallback)block {
    
    [self selectOrRefreshConversationsWithBlock:^(NSArray *conversations, NSError *error) {
        
        NSMutableSet *userIds = [NSMutableSet set];
        NSUInteger totalUnreadCount = 0;
        NSMutableArray *conversation_array = [NSMutableArray arrayWithArray:conversations];
        
        for (int i = 0; i < conversation_array.count; i++) {//过滤非法的conversation
            
            AVIMConversation *conversation = conversation_array[i];
            if ([conversation.otherId isEqualToString:INVALID_CONVERSATION]) {
                
                [conversation_array removeObject:conversation];
            }
        }
        
        for (AVIMConversation *conversation in conversation_array) {
            
            NSArray *lastestMessages = [conversation queryMessagesFromCacheWithLimit:50];//这里暂时取50个缓存数据然后进行检索
            
            for (int i = 0 ; i < lastestMessages.count; i++) {//过滤非法的消息
                
                AVIMTypedMessage *message = lastestMessages[lastestMessages.count - 1 - i];
                
                if ([message isKindOfClass:[AVIMTypedMessage class]]) {//过滤非法的消息
                    
                    if ([message.text isEqualToString:REQUEST_TYPE]) {//请求加为好友
                        
                        
                    } else if ([message.text isEqualToString:ACCEPT_TYPE]) {//接受请求加为好友
                        
                        
                    } else if ([message.text isEqualToString:DRECT_TYPE]) {//直接刷新
                        
                    } else {//正常的消息
                        
                        if (message.mediaType == AVIMMessageMediaTypeNotification) {//通知类型的消息，也显示
                            
                            conversation.lastMessage = message;
                            
                            break;
                            
                        } else {//非通知类型的消息，才显示最后一条消息
                            
                            conversation.lastMessage = message;
                            
                            break;
                        }
                    }
                }
            }

            if (conversation.type == CDConversationTypeSingle) {
                
                [userIds addObject:conversation.otherId];
                
            } else {
                
                if (conversation.lastMessage) {
                    
                    [userIds addObject:conversation.lastMessage.clientId];
                }
            }
            
            if (conversation.muted == NO) {
                
                totalUnreadCount += [conversation.unreadCount intValue];
            }
        }
        
        NSArray *sortedRooms = [conversation_array sortedArrayUsingComparator:^NSComparisonResult(AVIMConversation *conv1, AVIMConversation *conv2) {
            return (NSComparisonResult)(conv2.lastMessage.sendTimestamp - conv1.lastMessage.sendTimestamp);
        }];
        block(sortedRooms, totalUnreadCount, error);
    }];
}

#pragma mark - mention

- (BOOL)isMentionedByMessage:(AVIMTypedMessage *)message {
    
    if (![message isKindOfClass:[AVIMTextMessage class]]) {
        return NO;
    } else {
        
        NSString *text = ((AVIMTextMessage *)message).text;
        NSString *pattern = [NSString stringWithFormat:@"@%@",STUserAccountHandler.userProfile.nickName];
        
        if([text rangeOfString:pattern].length > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

/**
 * 退出对话并删除聊天记录
 */
- (void)deleteAndDeleteConversation:(AVIMConversation *)conversation callBack:(void (^)(BOOL successed,NSError *error))callBack {
    
    [[CDConversationStore store] deleteConversation:conversation];
    //删除本地缓存的图片消息
    [[CDMediaMessageManager shareManager] deleteMediaModelArrayWithUserId:self.clientId withConversationId:conversation.conversationId callback:^(BOOL successed, NSError *error) {
    }];
    callBack(YES,nil);
}

@end
