//
//  SportInformationTableManager.m
//  30000day
//
//  Created by WeiGe on 16/7/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportInformationTableManager.h"
#import "SportInformationTable.h"

@implementation SportInformationTableManager

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
    
    dbURL = [dbURL URLByAppendingPathComponent:@"SportInformationTable.data"];
    
    NSError *error = nil;
    
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:&error];
    
    //  实例化上下文
    _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [_managedObjectContext setPersistentStoreCoordinator:psc];
    
}

- (void)insertSportInformation:(SportInformationModel *)model {

    SportInformationTable *SFTable = [NSEntityDescription insertNewObjectForEntityForName:@"SportInformationTable" inManagedObjectContext:_managedObjectContext];
    
    SFTable.lastMaxID = model.lastMaxID;
    
    SFTable.userId = model.userId;
    
    SFTable.stepNumber = model.stepNumber;
    
    SFTable.distance = model.distance;
    
    SFTable.calorie = model.calorie;
    
    SFTable.time = model.time;
    
    NSError *err = nil;
    
    [_managedObjectContext save:&err];
    
    if (err) {
        
        [NSException raise:@"添加错误" format:@"%@", [err localizedDescription]];
        
    }

}

- (NSArray *)selectSportInformation:(NSNumber *)userId {

    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportInformationTable" inManagedObjectContext:_managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", userId];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *objs = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSManagedObject *obj in objs) {
        
        SportInformationModel *model = [[SportInformationModel alloc] init];
        
        model.userId = [obj valueForKey:@"userId"];
        
        model.stepNumber = [obj valueForKey:@"stepNumber"];
        
        model.distance = [obj valueForKey:@"distance"];
        
        model.calorie = [obj valueForKey:@"calorie"];
        
        model.time = [obj valueForKey:@"time"];
        
        [array addObject:model];
        
    }
    
    return [NSArray arrayWithArray:array];

}

- (void)deleteSportInformation:(NSNumber *)lastMaxID {

    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportInformationTable" inManagedObjectContext:_managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastMaxID == %@", lastMaxID];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *objs = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        
    }
    
    for (NSManagedObject *obj in objs) {
        
        [_managedObjectContext deleteObject:obj];
        
    }
    
    NSError *er = nil;
    
    [_managedObjectContext save:&er];


}


@end
