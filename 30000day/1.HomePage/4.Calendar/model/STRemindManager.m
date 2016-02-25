//
//  STRemindManager.m
//  30000day
//
//  Created by GuoJia on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRemindManager.h"

@interface STRemindManager () <NSFetchedResultsControllerDelegate> {
    
    NSFetchedResultsController *fetchCtrl;
    
}

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation STRemindManager

+ (STRemindManager *)shareRemindManager {
    
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[self alloc] init];
        
    });
    
    return sharedManager;
}

//1.修改或者增加
- (BOOL)changeORAddObject:(RemindModel *)model {
    
    RemindObject *object = [self objectWithUserId:model.userId withDate:model.date];
    
    if (!object) {
        
        if ([self addObject:model]) {//添加成功的时候会加本地提醒
            
            [self addLocaleNotification:model];
            
            return YES;
        } else {
            
            return NO;
        }
        
    } else {
        
        object.userId = model.userId;
        
        object.content = model.content;
        
        object.title = model.title;
        
        object.date = model.date;
        
        NSError *error;
        
        if ([self.managedObjectContext save:&error]) {
            
            [self addLocaleNotification:model];//修改成功的时候会加修改本地提醒时间
            
            return YES;
            
        } else {
            
            return NO;
            
        }
    }
}

- (void)addLocaleNotification:(RemindModel *)model {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (notification != nil) {
    
        notification.fireDate = model.date;
        
        notification.repeatInterval = 0;
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        notification.soundName = UILocalNotificationDefaultSoundName;

        notification.alertBody = model.content;
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:model.title forKey:@"alertTitle"];
        
        notification.userInfo = dictionary; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

//2.删除一条数据
- (void)deleteOjbectWithModel:(RemindModel *)model {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RemindObject"];
    
    //设置过滤和排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userId==%@",model.userId];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort];
    
    fetchRequest.predicate = pre;
    
    NSArray *array  =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSPredicate * filter_first = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"content = %@",model.content]];
    
    array = [array filteredArrayUsingPredicate:filter_first];  //从数组中进行过滤。
    
    NSPredicate * filter_second = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"title = %@",model.title]];
    
    array = [array filteredArrayUsingPredicate:filter_second];  //从数组中进行过滤。
    
    NSPredicate * filter_third = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"date = %@",model.date]];
    
    array = [array filteredArrayUsingPredicate:filter_third];  //从数组中进行过滤。
    
    [self.managedObjectContext deleteObject:[array firstObject]];
    
    NSError *error;
    
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"Error is %@",error);
        
    }
}

//3.用userId获取所有的RemindModel
- (NSMutableArray *)allRemindModelWithUserId:(NSNumber *)userId {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RemindObject"];
    
    //设置过滤和排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userId==%@",userId];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort];
    
    fetchRequest.predicate = pre;
    
    NSArray *array  =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return [NSMutableArray arrayWithArray:array];
}

//查询特定某一个object
- (RemindObject *)objectWithUserId:(NSNumber *)userId withDate:(NSDate *)date {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RemindObject"];
    
    //设置过滤和排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userId==%@ AND date==%@",userId,date];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort];
    
    fetchRequest.predicate = pre;
    
    NSArray *array  =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return [array firstObject];
}

//增加一个object
- (BOOL)addObject:(RemindModel *)model {
    
    RemindObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"RemindObject" inManagedObjectContext:self.managedObjectContext];
    
    newObject.content = model.content;
    
    newObject.date = model.date;
    
    newObject.title = model.title;
    
    newObject.userId = model.userId;
    
    newObject.date = model.date;
    
    NSError *error;
    
    return [self.managedObjectContext save:&error];
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
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        
        return _persistentStoreCoordinator;
        
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    
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
