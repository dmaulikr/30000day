//
//  STHealthyManager.m
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STHealthyManager.h"
#import "GetFactorObject.h"
#import "GetFactorModel.h"

@interface STHealthyManager ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation STHealthyManager

+ (STHealthyManager *)shareManager {
    
    static STHealthyManager *manager;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        manager = [[STHealthyManager alloc] init];

    });
    
    return manager;
}

- (void)synchronizedHealthyDataFromServer {
    
    //获取所有的健康因子
    [STDataHandler sendGetFactors:^(NSMutableArray *dataArray) {
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GetFactorObject"];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"factorId" ascending:YES];
        
        fetchRequest.sortDescriptors = @[sort];
        
        NSArray *array  = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        for (GetFactorObject *object in array) {
            
            [self.managedObjectContext deleteObject:object];
        }
        
        for (int i = 0; i < dataArray.count; i++) {
            
            GetFactorObject *object =  [NSEntityDescription insertNewObjectForEntityForName:@"GetFactorObject" inManagedObjectContext:self.managedObjectContext];
            
            GetFactorModel *model = dataArray[i];
            
            object.factorId = model.factorId;
            
            object.factor = model.factor;
            
            object.pid = model.pid;
            
            object.level = model.level;
        }
        
        [self saveContext];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (NSMutableArray *)array {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GetFactorObject"];
    
    //设置过滤和排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"level == 1"];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"factorId" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort];
    
    fetchRequest.predicate = pre;
    
    NSMutableArray *getFactorArray = [NSMutableArray array];
    
    NSArray *array  = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (GetFactorObject *object in array) {
        
        GetFactorModel *model = [[GetFactorModel alloc] init];
        
        model.factorId = object.factorId;
        
        model.factor = object.factor;
        
        model.level = object.level;
        
        model.pid = object.pid;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"GetFactorObject"];
        
        //设置过滤和排序
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"level == 2 AND pid == %@",model.factorId];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"factorId" ascending:YES];
        
        fetchRequest.sortDescriptors = @[sort];
        
        fetchRequest.predicate = pre;
        
        NSArray *subFactorArray  =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        model.subFactorArray  = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < subFactorArray.count; j++) {
            
            GetFactorObject *_object = subFactorArray[j];
            
            GetFactorModel *_model = [[GetFactorModel alloc] init];
            
            _model.factorId = _object.factorId;
            
            _model.factor = _object.factor;
            
            _model.level = _object.level;
            
            _model.pid = _object.pid;
            
            [model.subFactorArray addObject:_model];
        }
        
        [getFactorArray addObject:model];
    }
    
    return getFactorArray;
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;

@synthesize managedObjectModel = _managedObjectModel;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (_managedObjectModel != nil) {
        
        return _managedObjectModel;
        
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HealthModel" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        
        return _persistentStoreCoordinator;
        
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HealthModel.sqlite"];
    
    NSError *error = nil;
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        
        dict[NSUnderlyingErrorKey] = error;
        
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (!coordinator) {
        
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        
        NSError *error = nil;
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
        }
    }
}
@end
