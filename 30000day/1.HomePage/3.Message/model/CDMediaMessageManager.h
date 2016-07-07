//
//  CDMediaMessageManager.h
//  30000day
//
//  Created by GuoJia on 16/7/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDMediaMessageModel.h"

typedef void(^OperationResult)(NSError *error);
@interface CDMediaMessageManager : NSObject

+ (CDMediaMessageManager *)shareManager;
- (NSError *)save:(OperationResult)handler;
- (NSManagedObjectContext *)createPrivateObjectContext;

- (void)addMediaMessageWithModel:(CDMediaMessageModel *)model;//新增或者刷新
+ (NSMutableArray *)mediaModelArrayUserId:(NSString *)userId withConversationId:(NSString *)conversationId;
//用于下拉刷新,注意如果这个方法调用次数太多依然很卡
- (void)refreshMediaMessageWithModelArray:(NSMutableArray *)modelArray userId:(NSString *)userId withConversationId:(NSString *)conversationId callback:(void (^)(BOOL successed,NSError *error))callback;

//根据conversationId和userId来删除聊天信息图片消息
- (void)deleteMediaModelArrayWithUserId:(NSString *)userId withConversationId:(NSString *)conversationId callback:(void (^)(BOOL successed,NSError *error))callback;

@end
