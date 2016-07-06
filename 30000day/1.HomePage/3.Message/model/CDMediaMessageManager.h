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

@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

+ (CDMediaMessageManager *)shareManager;
- (NSError *)save:(OperationResult)handler;
- (NSManagedObjectContext *)createPrivateObjectContext;

- (void)addMediaMessageWithModel:(CDMediaMessageModel *)model;//新增或者刷新
+ (NSMutableArray *)mediaModelArrayUserId:(NSString *)userId withConversationId:(NSString *)conversationId;
+ (NSInteger)indexModelsArray:(NSMutableArray *)modelsArray WithModel:(CDMediaMessageModel *)model;

@end
