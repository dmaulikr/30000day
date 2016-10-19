//
//  SportsFunctionManager.m
//  30000day
//
//  Created by WeiGe on 16/7/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportsFunctionManager.h"
#import "SportsFunction.h"

@implementation SportsFunctionManager

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        [self initContext];
        
    }
    
    return self;
}

- (void)initContext {
    
    // 实例化数据模型
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SportInformation" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    // 实例化持久化储存
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSURL *dbURL = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    
    dbURL = [dbURL URLByAppendingPathComponent:@"SportsFunction.data"];
    
    NSError *error = nil;
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:optionsDictionary error:&error];
    
    //实例化上下文
    _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [_managedObjectContext setPersistentStoreCoordinator:psc];
    
}

- (void)insertSportsFunction:(SportsFunctionModel *)model {

    SportsFunction *sportsFunction = [NSEntityDescription insertNewObjectForEntityForName:@"SportsFunction" inManagedObjectContext:_managedObjectContext];
    
    sportsFunction.speechDistance = model.speechDistance;
    
    sportsFunction.mapType = model.mapType;
    
    sportsFunction.userId = model.userId;
    
    sportsFunction.compass = model.compass;
    
    NSError *err = nil;
    
    [_managedObjectContext save:&err];
    
    if (err) {
        
        [NSException raise:@"添加错误" format:@"%@", [err localizedDescription]];
        
    }
    
}

- (SportsFunctionModel *)selectSportsFunction:(NSNumber *)userId {
    
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportsFunction" inManagedObjectContext:_managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", userId];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *objs = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        
    }
    
    SportsFunctionModel *model = [[SportsFunctionModel alloc] init];
    
    for (NSManagedObject *obj in objs) {
        
        model.speechDistance = [obj valueForKey:@"speechDistance"];
        
        model.mapType = [obj valueForKey:@"mapType"];
        
        model.userId = [obj valueForKey:@"userId"];
        
        model.compass = [obj valueForKey:@"compass"];
        
    }
    
    return model;
    
}

- (void)updateSportsFunction:(NSNumber *)userId speechDistance:(NSString *)speechDistance {
    
    
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportsFunction" inManagedObjectContext:_managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *objs = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        
    }
    
    for (SportsFunction *obj in objs) {
        
        obj.speechDistance = speechDistance;

    }

    NSError *err = nil;
    
    if ([_managedObjectContext save:&err]) {
        
        NSLog(@"更新成功");
        
    }
    
}


- (void)updateSportsFunction:(NSNumber *)userId mapType:(NSString *)mapType {
    
    
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportsFunction" inManagedObjectContext:_managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *objs = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        
    }
    
    for (SportsFunction *obj in objs) {
        
        obj.mapType = mapType;
        
    }
    
    NSError *err = nil;
    
    if ([_managedObjectContext save:&err]) {
        
        NSLog(@"更新成功");
        
    }
    
}

- (void)updateSportsFunction:(NSNumber *)userId compass:(NSNumber *)compass {
    
    
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportsFunction" inManagedObjectContext:_managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *objs = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        
    }
    
    for (SportsFunction *obj in objs) {
        
        obj.compass = compass;
        
    }
    
    NSError *err = nil;
    
    if ([_managedObjectContext save:&err]) {
        
        NSLog(@"更新成功");
        
    }
    
}



@end
