//
//  STChooseItemManager.h
//  30000day
//
//  Created by GuoJia on 16/8/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"
#import "STChooseItemView.h"
#import "STChooseItemObject.h"

typedef void(^OperationResult)(NSError *error);
@interface STChooseItemManager : NSObject

@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

@property (nonatomic, copy)NSString *modelName;
@property (nonatomic, copy)NSString *dbFileName;

+ (STChooseItemManager *)shareManager;
- (NSError *)save:(OperationResult)handler;
- (NSManagedObjectContext *)createPrivateObjectContext;

- (void)addChooseItemDataUserId:(NSNumber *)userId
                       success:(void (^)(BOOL success))success
                        failure:(void (^)(NSError *error))failure;
- (BOOL)isSaveDataWithUserID:(NSNumber *)userId;//判断某一个用户本地是否保存了请求自媒体类型数据
- (BOOL)isSaveData;
+ (NSMutableArray <STChooseItemModel *>*)choosedItemArrayWithUserId:(NSNumber *)userId  visibleType:(NSNumber *)visibleType;
+ (NSMutableArray <STChooseItemModel *>*)willChooseItemArrayWithUserId:(NSNumber *)userId  visibleType:(NSNumber *)visibleType;
+ (NSMutableArray <STChooseItemModel *>*)originChooseItemArrayWithUserId:(NSNumber *)userId  visibleType:(NSNumber *)visibleType;
- (void)setChoosedItemWithModel:(STChooseItemModel *)itemModel;//设置类型
- (void)setWillChoosedItemWithModel:(STChooseItemModel *)itemModel;//还原

@end
