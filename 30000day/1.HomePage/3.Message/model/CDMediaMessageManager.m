//
//  CDMediaMessageManager.m
//  30000day
//
//  Created by GuoJia on 16/7/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CDMediaMessageManager.h"
#import "NSManagedObject+handler.h"
#import "CDMediaMessageObject.h"

static CDMediaMessageManager *instance;

@interface CDMediaMessageManager ()

@property (nonatomic, copy)NSString *modelName;
@property (nonatomic, copy)NSString *dbFileName;

@end

@implementation CDMediaMessageManager

+ (CDMediaMessageManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[CDMediaMessageManager alloc] init];
        [instance configModel:@"CDMediaMessageStore" DbFile:@"CDMediaMessageStore.sqlite"];
    });
    
    return instance;
}

- (void)configModel:(NSString *)model DbFile:(NSString *)filename {
    
    _modelName = model;
    _dbFileName = filename;

    [self initCoreDataStack];
}

- (void)initCoreDataStack {
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        
        _bgObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_bgObjectContext setPersistentStoreCoordinator:coordinator];
        
        _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainObjectContext setParentContext:_bgObjectContext];
    }
}

- (NSManagedObjectContext *)createPrivateObjectContext {
    
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [ctx setParentContext:_mainObjectContext];
    return ctx;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    NSManagedObjectModel *managedObjectModel;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_dbFileName];
    NSError *error = nil;
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSError *)save:(OperationResult)handler {
    
    NSError *error;
    
    if ([_mainObjectContext hasChanges]) {
        
        [_mainObjectContext save:&error];
        [_bgObjectContext performBlock:^{
            
            __block NSError *inner_error = nil;
            [_bgObjectContext save:&inner_error];
            
            if (handler) {
                
                [_mainObjectContext performBlock:^{
                
                    handler(error);
                    
                }];
            }
        }];
    }
    
    return error;
}

//新增一条数据
- (void)addMediaMessageWithModel:(CDMediaMessageModel *)model {
    
    [self addObjectWithModel:model];
    
    [self save:^(NSError *error) {
        
    }];
}

- (void)refreshMediaMessageWithModelArray:(NSMutableArray *)modelArray userId:(NSString *)userId withConversationId:(NSString *)conversationId callback:(void (^)(BOOL successed,NSError *error))callback {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND conversationId == %@",userId,conversationId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageDate" ascending:YES];
    
    //获取模型数组和object数组
    NSArray *dataArray = [CDMediaMessageObject filterWithContext:[CDMediaMessageManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    NSMutableArray *storeModelArray = [[NSMutableArray alloc] init];//该数组为数据库查询出来的，modelArray为被分割的数组
    for (int i = 0; i < dataArray.count; i++) {
        
        CDMediaMessageObject *object = dataArray[i];
        CDMediaMessageModel *model = [[CDMediaMessageModel alloc] init];
        model.userId = object.userId;
        model.conversationId = object.conversationId;
        model.imageMessageId = object.imageMessageId;
        model.image = object.image;
        model.localURLString = object.localURLString;
        model.remoteURLString = object.remoteURLString;
        model.messageDate = object.messageDate;
        [storeModelArray addObject:model];
    }
    //异步处理数据
    dispatch_async(dispatch_queue_create("aaa", DISPATCH_QUEUE_SERIAL), ^{
        
        NSMutableArray *existModelArray = [[NSMutableArray alloc] init];//筛选出那些已经存在数据库的数据
        
        for (int i = 0; i < storeModelArray.count; i++) {
            
            CDMediaMessageModel *model = storeModelArray[i];
            NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"userId == %@ AND conversationId == %@ AND imageMessageId == %@",model.userId,model.conversationId,model.imageMessageId];
            NSArray *array = [modelArray filteredArrayUsingPredicate:subPredicate];
            [existModelArray addObjectsFromArray:array];
        }
        
        //1.留下需要保存的
        [modelArray removeObjectsInArray:existModelArray];
        //2.保存数据库不存在的数据
        for (int i = 0; i < modelArray.count; i++) {
            
            CDMediaMessageModel *model = modelArray[i];
            [self addMediaMessageWithModel:model];
        }
        //3.更新数据库存在的数据
        for (int i = 0 ; i < existModelArray.count; i++) {//先筛选出数据库之前存在的数据
            
            CDMediaMessageModel *oldModel = existModelArray[i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND conversationId == %@ AND imageMessageId == %@",oldModel.userId,oldModel.conversationId,oldModel.imageMessageId];
            CDMediaMessageObject *object = [dataArray filteredArrayUsingPredicate:predicate][0];
            [self refreshObject:object withModel:oldModel];//开始更新
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{//主线程保存
           
            [self save:^(NSError *error) {
                if (error) {
                    callback(NO,error);
                } else {
                    callback(YES,error);
                }
            }];
        });

    });
}

- (void)refreshObject:(CDMediaMessageObject *)object withModel:(CDMediaMessageModel *)model {
    
    object.conversationId = model.conversationId;
    object.imageMessageId = model.imageMessageId;
    object.userId = model.userId;
    
    if (model.image) {
        object.image = model.image;
    }
    
    if (model.localURLString) {
       object.localURLString = model.localURLString;
    }
    
    if (model.remoteURLString) {
        object.remoteURLString = model.remoteURLString;
    }
    
    if (model.messageDate) {
        object.messageDate = model.messageDate;
    }
}

- (void)addObjectWithModel:(CDMediaMessageModel *)model {
    
    CDMediaMessageObject *object = [CDMediaMessageObject createObjectWithMainContext:self.mainObjectContext];
    object.conversationId = model.conversationId;
    object.imageMessageId = model.imageMessageId;
    object.userId = model.userId;
    
    if (model.image) {
        object.image = model.image;
    }
    
    if (model.localURLString) {
        object.localURLString = model.localURLString;
    }
    
    if (model.remoteURLString) {
        object.remoteURLString = model.remoteURLString;
    }
    
    if (model.messageDate) {
        object.messageDate = model.messageDate;
    }
}

+ (NSMutableArray *)mediaModelArrayUserId:(NSString *)userId withConversationId:(NSString *)conversationId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND conversationId == %@",userId,conversationId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageDate" ascending:YES];
    NSArray *dataArray = [CDMediaMessageObject filterWithContext:[CDMediaMessageManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    NSMutableArray *modelsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        
        CDMediaMessageObject *object = dataArray[i];
        CDMediaMessageModel *model = [[CDMediaMessageModel alloc] init];
        model.userId = object.userId;
        model.conversationId = object.conversationId;
        model.imageMessageId = object.imageMessageId;
        model.image = object.image;
        model.localURLString = object.localURLString;
        model.remoteURLString = object.remoteURLString;
        model.messageDate = object.messageDate;
        [modelsArray addObject:model];
    }
    return modelsArray;
}

//根据conversationId和userId来删除聊天信息图片消息
- (void)deleteMediaModelArrayWithUserId:(NSString *)userId withConversationId:(NSString *)conversationId callback:(void (^)(BOOL successed,NSError *error))callback {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND conversationId == %@",userId,conversationId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageDate" ascending:YES];
    
    for (CDMediaMessageObject *object in [CDMediaMessageObject filterWithContext:self.mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0]) {
        
        [CDMediaMessageObject deleteObjectWithMainContext:self.mainObjectContext object:object];
    }
    
    [self save:^(NSError *error) {
        if (error) {
            callback(NO,error);
        } else {
            callback(YES,error);
        }
    }];
}

@end
