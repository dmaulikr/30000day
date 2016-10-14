//
//  STPraiseReplyStorageManager.h
//  30000day
//
//  Created by GuoJia on 16/9/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PraiseReplyStorageModel.h"
#import "AVIMPraiseMessage.h"
#import "AVIMReplyMessage.h"
#import "STCoreDataStorage.h"

@interface STPraiseReplyCoreDataStorage : STCoreDataStorage

+ (STPraiseReplyCoreDataStorage *)shareStorage;
//新增或者刷新消息数组
- (void)addPraiseReplyWith:(NSArray <AVIMTypedMessage *>*)messageArray visibleType:(NSNumber *)visibleType;
//批量标记消息(readState:0：阅读过 1：没阅读过 2：过渡类型)
- (void)markMessageWith:(NSArray <AVIMTypedMessage *>*)messageArray visibleType:(NSNumber *)visibleType readState:(NSNumber *)readState;
//发送消息
+ (void)sendPraiseReplyMessageWith:(AVIMTypedMessage *)message memberClientIdArray:(NSArray *)memberClientIdArray userInformationModel:(UserInformationModel *)model callBack:(void (^)(BOOL success,NSError *error,AVIMConversation *conversation))callBack;
//发送点赞消息
+ (void)sendPraiseMessage:(NSNumber *)currentUserId currentOriginHeadImg:(NSString *)currentOriginHeadImg currentOriginNickName:(NSString *)currentOriginNickName userId:(NSNumber *)userId originHeadImg:(NSString *)originalHeadImg originalNickName:(NSString *)originalNickName visibleType:(NSNumber *)visibleType;
//发送回复消息
+ (void)sendReplyMessage:(NSNumber *)currentUserId currentOriginHeadImg:(NSString *)currentOriginHeadImg currentOriginNickName:(NSString *)currentOriginNickName userId:(NSNumber *)userId originHeadImg:(NSString *)originalHeadImg originalNickName:(NSString *)originalNickName visibleType:(NSNumber *)visibleType;

//- (NSArray <AVIMPraiseMessage *>*)getPraiseMesssageArrayWithVisibleType:(NSNumber *)visibleType readState:(NSNumber *)readState offset:(int)offset limit:(int)limit;
//- (NSArray <AVIMReplyMessage *>*)geReplyMesssageArrayWithVisibleType:(NSNumber *)visibleType readState:(NSNumber *)readState offset:(int)offset limit:(int)limit;

- (void)scheduleGetPraiseMessageArrayWithVisibleType:(NSNumber *)visibleType
                                           readState:(NSNumber *)readState
                                              offset:(int)offset
                                               limit:(int)limit
                                              success:(void (^)(NSMutableArray <AVIMPraiseMessage *>*dataArray))success;

- (void)scheduleGetReplyMessageArrayWithVisibleType:(NSNumber *)visibleType
                                           readState:(NSNumber *)readState
                                              offset:(int)offset
                                               limit:(int)limit
                                             success:(void (^)(NSMutableArray <AVIMPraiseMessage *>*dataArray))success;


@end
