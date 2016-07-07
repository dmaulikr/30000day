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

- (void)addMediaMessageWithModel:(CDMediaMessageModel *)model {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND imageMessageId == %@ AND conversationId == %@",model.userId,model.imageMessageId,model.conversationId];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageDate" ascending:YES];
    NSArray *dataArray = [CDMediaMessageObject filterWithContext:self.mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
    if (dataArray.count) {
        
        for (int i = 0; i < dataArray.count; i++) {
            
            CDMediaMessageObject *object = dataArray[i];
            if ([CDMediaMessageManager object:object isDifferentWithModel:model]) {//不同
                [self refreshObject:object withModel:model];//刷新
            }
        }
    } else {
        
         [self addObjectWithModel:model];
    }
    
    [self save:^(NSError *error) {
        
    }];
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

//是否相同，如果YES表示两个不同，NO表示相同
+ (BOOL)object:(CDMediaMessageObject *)object isDifferentWithModel:(CDMediaMessageModel *)model {
    
    if ([object.userId isEqualToString:model.userId] && [object.conversationId isEqualToString:model.conversationId] && [object.imageMessageId isEqualToString:model.imageMessageId]) {
        
        return NO;
        
    } else {
        
        return YES;
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

+ (NSInteger)indexModelsArray:(NSMutableArray *)modelsArray WithModel:(CDMediaMessageModel *)model {
    
    NSInteger index = 0;
    
    for (int i = 0; i < modelsArray.count; i++) {
        
        CDMediaMessageModel *localModel = modelsArray[i];
        
        if ([localModel.userId isEqualToString:model.userId] && [localModel.conversationId isEqualToString:localModel.conversationId] && [localModel.imageMessageId isEqualToString:model.imageMessageId]) {
            
            index = i;
        }
    }
    return index;
}

@end
