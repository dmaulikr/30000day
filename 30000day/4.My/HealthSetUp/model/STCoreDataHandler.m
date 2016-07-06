//
//  STCoreDataHandler.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STCoreDataHandler.h"
#import "GetFactorObject.h"
#import "GetFactorModel.h"

static STCoreDataHandler *onlyInstance;

@interface STCoreDataHandler ()

@property (nonatomic, copy)NSString *modelName;

@property (nonatomic, copy)NSString *dbFileName;

@end

@implementation STCoreDataHandler

+ (STCoreDataHandler *)shareCoreDataHandler {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        onlyInstance = [[STCoreDataHandler alloc] init];
        
        [onlyInstance configModel:@"HealthModel" DbFile:@"asyncCoreDataWrapper.sqlite"];
    });
    
    return onlyInstance;
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

- (void)synchronizedHealthyDataFromServer:(void (^)(BOOL isSuccess))isSuccess {
    
    //获取所有的健康因子
    [STDataHandler sendGetFactors:^(NSMutableArray *dataArray) {
        
        for (GetFactorObject *object in [GetFactorObject filterWithContext:[STCoreDataHandler shareCoreDataHandler].mainObjectContext predicate:nil orderby:nil offset:0 limit:0]) {
            
            [GetFactorObject deleteObjectWithMainContext:[STCoreDataHandler shareCoreDataHandler].mainObjectContext object:object];
        }
        
        for (int i = 0; i < dataArray.count; i++) {
            
            GetFactorObject *object =  [GetFactorObject createObjectWithMainContext:[STCoreDataHandler shareCoreDataHandler].mainObjectContext];
            
            GetFactorModel *model = dataArray[i];
            
            object.factorId = model.factorId;
            
            object.factor = model.factor;
            
            object.pid = model.pid;
            
            object.level = model.level;
            
            object.gender = model.gender;
        }
        
        [self save:^(NSError *error) {
            
            if (error) {
                
                isSuccess(NO);
                
            } else {
                
                isSuccess(YES);
            }
        }];
        
    } failure:^(NSError *error) {
        
        isSuccess(NO);
    }];
}


@end
