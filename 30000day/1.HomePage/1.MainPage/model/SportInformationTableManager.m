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
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:optionsDictionary error:&error];

    //实例化上下文
    _managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [_managedObjectContext setPersistentStoreCoordinator:psc];
    
}

- (void)insertSportInformation:(SportInformationModel *)model {

    SportInformationTable *SFTable = [NSEntityDescription insertNewObjectForEntityForName:@"SportInformationTable" inManagedObjectContext:_managedObjectContext];
    
    SFTable.lastMaxID = model.lastMaxID;
    
    SFTable.userId = model.userId;
    
    SFTable.stepNumber = model.steps;
    
    SFTable.distance = [NSNumber numberWithFloat:[model.distance floatValue]];
    
    SFTable.calorie = [NSNumber numberWithFloat:[model.calorie floatValue]];
    
    SFTable.time = [NSNumber numberWithInteger:[model.period integerValue]];
    
    SFTable.x = model.xcoordinate;
    
    SFTable.y = model.ycoordinate;
    
    SFTable.dateTime = model.startTime;
    
    SFTable.isSave = model.isSave;
    
    SFTable.sportNo = [NSNumber numberWithInteger:[model.sportNo integerValue]];
    
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
        
        model.lastMaxID = [obj valueForKey:@"lastMaxID"];
        
        model.userId = [obj valueForKey:@"userId"];
        
        model.steps = [obj valueForKey:@"stepNumber"];
        
        model.distance = [[obj valueForKey:@"distance"] stringValue];
        
        model.calorie = [[obj valueForKey:@"calorie"] stringValue];
        
        model.period = [[obj valueForKey:@"time"] stringValue];
        
        model.xcoordinate = [obj valueForKey:@"x"];
        
        model.ycoordinate = [obj valueForKey:@"y"];
        
        model.startTime = [obj valueForKey:@"dateTime"];
        
        model.isSave = [obj valueForKey:@"isSave"];
        
        model.sportNo = [[obj valueForKey:@"sportNo"] stringValue];
        
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

- (void)deleteAllSportInformation {
    
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportInformationTable" inManagedObjectContext:_managedObjectContext];
    
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

- (void)updateSportInformationWithLastMaxID:(NSNumber *)lastMaxID isSave:(NSNumber *)isSave {
    
    NSFetchRequest *request =[[NSFetchRequest alloc] init];
    
    request.entity = [NSEntityDescription entityForName:@"SportInformationTable" inManagedObjectContext:_managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastMaxID == %@", lastMaxID];
    
    request.predicate = predicate;
    
    NSError *error = nil;
    
    NSArray *objs = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error) {
        
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        
    }
    
    for (SportInformationTable *obj in objs) {
        
        obj.isSave = isSave;
        
    }
    
    NSError *err = nil;
    
    if ([_managedObjectContext save:&err]) {
        
        NSLog(@"更新成功");
        
    }
    
}


@end
