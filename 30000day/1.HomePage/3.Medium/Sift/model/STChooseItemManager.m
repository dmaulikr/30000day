//
//  STChooseItemManager.m
//  30000day
//
//  Created by GuoJia on 16/8/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STChooseItemManager.h"
#import "NSManagedObject+handler.h"


static STChooseItemManager *instance;

@implementation STChooseItemManager

+ (STChooseItemManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[STChooseItemManager alloc] init];
        [instance configModel:@"chooseItemModel" DbFile:@"chooseItemModel.sqlite"];
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

- (void)addChooseItemDataUserId:(NSNumber *)userId
                        success:(void (^)(BOOL success))success
                        failure:(void (^)(NSError *error))failure {
    
    [STDataHandler sendGetWeMediaInfoTypesSuccess:^(NSMutableArray<STChooseItemModel *> *modelArray) {
        
        if (modelArray.count) {
            
            if ([Common isObjectNull:userId]) {
                
                failure([Common errorWithString:@"用户的ID为空"]);
                
            } else {
                
                [self checkVersionFromServer:modelArray visibleType:@0 userId:userId];
                [self checkVersionFromServer:modelArray visibleType:@1 userId:userId];
                [self checkVersionFromServer:modelArray visibleType:@2 userId:userId];
                
                [self save:^(NSError *error) {
                    if ([Common isObjectNull:error]) {
                        success(YES);
                    } else {
                        failure(error);
                    }
                }];
            }
            
        } else {
            
            failure([Common errorWithString:@"请求服务器失败"]);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)checkVersionFromServer:(NSMutableArray <STChooseItemModel *>*)modelArray visibleType:(NSNumber *)visibleType userId:(NSNumber *)userId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visibleType == %@ AND userId == %@",visibleType,userId];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemTag" ascending:YES];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    //数据库查出来和服务器比对，如果本地数据库没有说明是新增的--->存入数据【第一次都是新增，后来单个更新】
    for (STChooseItemModel *model in modelArray) {
        
        NSPredicate *firstPredicate = [NSPredicate predicateWithFormat:@"itemTag == %@ AND title == %@ AND userId == %@",model.itemTag,model.title,userId];
        NSArray *firstArray = [dataArray filteredArrayUsingPredicate:firstPredicate];
        
        if (firstArray.count == 0) {//本地数据没有
            [self addObjectWithVisibleType:visibleType userId:userId itemTag:model.itemTag title:model.title];
        }
    }
    
    //数据库查出来和服务器比对，如果服务器的没有，说明是需要删除的---->更新数据
    for (STChooseItemObject *object in dataArray) {
        
        NSPredicate *secondPredicate = [NSPredicate predicateWithFormat:@"itemTag == %@ AND title == %@",object.itemTag,object.title,userId];
        NSArray *secondArray = [dataArray filteredArrayUsingPredicate:secondPredicate];
        
        if (secondArray.count == 0) {//删除数据
            [STChooseItemObject deleteObjectWithMainContext:[STChooseItemManager shareManager].mainObjectContext object:object];
        }
    }
}

//新增一个一条数据
- (void)addObjectWithVisibleType:(NSNumber *)visibleType userId:(NSNumber *)userId itemTag:(NSNumber *)itemTag title:(NSString *)title {
    
        STChooseItemObject *object = [STChooseItemObject createObjectWithMainContext:self.mainObjectContext];
        object.userId = userId;
        object.visibleType = visibleType;
        object.isChoosed = @1;
        object.title = title;
        object.itemTag = itemTag;
}

+ (NSMutableArray <STChooseItemModel *>*)choosedItemArrayWithUserId:(NSNumber *)userId  visibleType:(NSNumber *)visibleType {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND visibleType == %@ AND isChoosed == %@",userId,visibleType,@1];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemTag" ascending:YES];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    NSMutableArray *modelsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
       
        STChooseItemObject *object = dataArray[i];
        STChooseItemModel *model = [[STChooseItemModel alloc] init];
        model.useId = object.userId;
        model.visibleType = object.visibleType;
        model.isChoosed = object.isChoosed;
        model.itemTag = object.itemTag;
        model.title = object.title;
        [modelsArray addObject:model];
    }
    return modelsArray;
}

+ (NSMutableArray <STChooseItemModel *>*)willChooseItemArrayWithUserId:(NSNumber *)userId  visibleType:(NSNumber *)visibleType {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND visibleType == %@ AND isChoosed == %@",userId,visibleType,@0];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemTag" ascending:YES];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    NSMutableArray *modelsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        
        STChooseItemObject *object = dataArray[i];
        STChooseItemModel *model = [[STChooseItemModel alloc] init];
        model.useId = object.userId;
        model.visibleType = object.visibleType;
        model.isChoosed = object.isChoosed;
        model.itemTag = object.itemTag;
        model.title = object.title;
        [modelsArray addObject:model];
    }
    return modelsArray;
}

+ (NSMutableArray <STChooseItemModel *>*)originChooseItemArrayWithUserId:(NSNumber *)userId  visibleType:(NSNumber *)visibleType {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND visibleType == %@",userId,visibleType];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemTag" ascending:YES];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    NSMutableArray *modelsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < dataArray.count; i++) {
        
        STChooseItemObject *object = dataArray[i];
        STChooseItemModel *model = [[STChooseItemModel alloc] init];
        model.useId = object.userId;
        model.visibleType = object.visibleType;
        model.isChoosed = object.isChoosed;
        model.itemTag = object.itemTag;
        model.title = object.title;
        [modelsArray addObject:model];
    }
    return modelsArray;
}

- (void)setChoosedItemWithModel:(STChooseItemModel *)itemModel {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND visibleType == %@ AND isChoosed == %@ AND itemTag == %@ AND title == %@",itemModel.useId,itemModel.visibleType,@0,itemModel.itemTag,itemModel.title];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[] offset:0 limit:0];
    
    if (dataArray.count > 0) {
        STChooseItemObject *object = dataArray[0];
        object.isChoosed = itemModel.isChoosed;
        [self save:nil];
    }
}

- (void)setWillChoosedItemWithModel:(STChooseItemModel *)itemModel {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND visibleType == %@ AND isChoosed == %@ AND itemTag == %@ AND title == %@",itemModel.useId,itemModel.visibleType,@1,itemModel.itemTag,itemModel.title];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[] offset:0 limit:0];
    
    if (dataArray.count > 0) {
        STChooseItemObject *object = dataArray[0];
        object.isChoosed = itemModel.isChoosed;
        [self save:nil];
    }
}

//判断某一用户本地是否保存了请求自媒体类型数据
- (BOOL)isSaveDataWithUserID:(NSNumber *)userId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND visibleType == %@",userId,@0];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemTag" ascending:YES];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    if (dataArray.count) {
        return YES;
    } else {
        return NO;
    }
}

//判断本地是否保存了请求自媒体类型数据
- (BOOL)isSaveData {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"visibleType == %@",@0];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemTag" ascending:YES];
    NSArray *dataArray = [STChooseItemObject filterWithContext:[STChooseItemManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    
    if (dataArray.count) {
        return YES;
    } else {
        return NO;
    }
}

@end
