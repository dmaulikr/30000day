//
//  STRemindManager.m
//  30000day
//
//  Created by GuoJia on 16/2/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRemindManager.h"

@interface STRemindManager ()

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

//1.修改
- (BOOL)changeObjectWithOldModel:(RemindModel *)oldModel willChangeModel:(RemindModel *)newModel {
    
    RemindObject *object = [self objectWithRemindModel:oldModel];
    
    object.userId = newModel.userId;
    
    object.content = newModel.content;
    
    object.title = newModel.title;
    
    object.date = newModel.date;
    
    object.dateString = newModel.dateString;
    
    object.calenderNumber = newModel.calenderNumber;
    
    NSError *error;
    
    BOOL success = [self.managedObjectContext save:&error];
    
    //修改通知中心的提醒时间
    [self changeLocaleNotificationWithOldModel:oldModel newModel:newModel];
    
    return success;
}

//增加一个object
- (BOOL)addObject:(RemindModel *)model {
    
    RemindObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"RemindObject" inManagedObjectContext:self.managedObjectContext];
    
    newObject.content = model.content;
    
    newObject.date = model.date;
    
    newObject.title = model.title;
    
    newObject.userId = model.userId;
    
    newObject.date = model.date;
    
    newObject.dateString = model.dateString;
    
    newObject.calenderNumber = model.calenderNumber;
    
    NSError *error;
    
    BOOL success = [self.managedObjectContext save:&error];
    
    if (success) {
        
        [self addLocaleNotification:model];
        
    }
    
    return success;
}

//6.删除若干数据-数组里装的是model
- (BOOL)deleteOjbectWithArray:(NSMutableArray *)modelArray {
    
    BOOL success = NO;
    
    for (RemindModel *model in modelArray) {
        
       success = [self deleteOjbectWithModel:model];
    }
    return success;
}

//2.删除一条数据
- (BOOL)deleteOjbectWithModel:(RemindModel *)model {
    
    //1.查询数据库数据并删除
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RemindObject"];
    
    //设置过滤和排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userId==%@ AND date == %@ AND title == %@ AND dateString == %@",model.userId,model.date,model.title,model.dateString];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort];
    
    fetchRequest.predicate = pre;
    
    NSArray *array  =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
   [self.managedObjectContext deleteObject:[array firstObject]];
    
    NSError *error;
    
    //删除一条本地通知
    [self deleteNotificationWithModel:model];
    
    return [self.managedObjectContext save:&error];
}

//3.用userId获取所有的RemindModel
- (NSMutableArray *)allRemindModelWithUserId:(NSNumber *)userId {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RemindObject"];
    
    //设置过滤和排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort];
    
    fetchRequest.predicate = pre;
    
    NSArray *array  =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0;  i < array.count ; i++) {
        
        RemindModel *model = [[RemindModel alloc] init];
        
        RemindObject *object = array[i];
        
        model.userId = object.userId;
        
        model.content = object.content;
        
        model.title = object.title;
        
        model.date = object.date;
        
        model.calenderNumber = object.calenderNumber;
        
        model.dateString = object.dateString;
        
        [dataArray addObject:model];
    }
    
    return [NSMutableArray arrayWithArray:dataArray];
}

//5.用userI和date来获取到所有的
- (NSMutableArray *)allRemindModelWithUserId:(NSNumber *)userId dateString:(NSString *)dateString {
    
    if ([Common isObjectNull:userId] || [Common isObjectNull:dateString]) {
        
        return [NSMutableArray array];
    }
    
    //设置过滤和排序
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RemindObject" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND dateString == %@",userId,dateString];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                   ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    
    NSArray *array = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0;  i < array.count ; i++) {
        
        RemindModel *model = [[RemindModel alloc] init];
        
        RemindObject *object = array[i];
        
        model.userId = object.userId;
        
        model.content = object.content;
        
        model.title = object.title;
        
        model.date = object.date;
        
        model.dateString = object.dateString;
        
        model.calenderNumber = object.calenderNumber;
        
        [dataArray addObject:model];
    }
    
    return [NSMutableArray arrayWithArray:dataArray];
    
}

//查询特定某一个object
- (RemindObject *)objectWithRemindModel:(RemindModel *)remindModel {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RemindObject"];
    
    //设置过滤和排序
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"userId == %@ AND date == %@ AND title == %@ AND dateString == %@",remindModel.userId,remindModel.date,remindModel.title,remindModel.dateString];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    fetchRequest.sortDescriptors = @[sort];
    
    fetchRequest.predicate = pre;
    
    NSArray *array  =[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return [array firstObject];
}

//*************************************对本地通知的一些操作***********************************//
//增加一个本地通知
- (void)addLocaleNotification:(RemindModel *)model {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = model.date;
    
    notification.repeatInterval = 0;
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    notification.alertBody = model.content;
    
    if ([model.calenderNumber isEqual:@1]) {
    
        notification.repeatInterval = NSCalendarUnitMinute;
        
    } else if ([model.calenderNumber isEqual:@2]) {
        
        notification.repeatInterval = NSCalendarUnitHour;
        
    } else if ([model.calenderNumber isEqual:@3]) {
        
        notification.repeatInterval = NSCalendarUnitDay;
        
    } else if ([model.calenderNumber isEqual:@4]) {
        
       notification.repeatInterval = NSCalendarUnitWeekday;
        
    } else if ([model.calenderNumber isEqual:@5]) {
        
        notification.repeatInterval = NSCalendarUnitMonth;
        
    } else if ([model.calenderNumber isEqual:@6]) {
        
         notification.repeatInterval = NSCalendarUnitYear;
    }

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[@"alertTitle"] = model.title;
    
    dictionary[CALENDAR_NOTIFICATION] = CALENDAR_NOTIFICATION;
    
    notification.userInfo = dictionary; //添加额外的信息
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

//修改本地通知
- (void)changeLocaleNotificationWithOldModel:(RemindModel *)oldModel newModel:(RemindModel *)newModel {
    
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    BOOL isExist = NO;//表示这个旧的通知是否存在，默认是不存在的
    
    for (int i = 0 ; i < notificationArray.count; i++) {
        
         UILocalNotification *localNotification = [notificationArray objectAtIndex:i];
        
         NSDictionary *userInfo = localNotification.userInfo;
        
         if ([userInfo[CALENDAR_NOTIFICATION] isEqualToString:CALENDAR_NOTIFICATION]) {//表示这个通知是我们自己注册的
             
             NSDateFormatter *formattor = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm:ss"];
             
             NSString *fireDateString = [formattor stringFromDate:localNotification.fireDate];//当前需要修改的通知开火时间
             
             NSString *oldFireDateString = [formattor stringFromDate:oldModel.date];//原来新增通知的时候设置开火时间
             
             if ([fireDateString isEqualToString:oldFireDateString]) {
                 
                 //先删除
                 [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                 
                 //在添加
                 [self addLocaleNotification:newModel];
                 
                 isExist = YES;
                 
                 break;
             }
         }
    }

    if (isExist == NO) {//表示该通知不存在，可能已经过了提醒时间，系统自动取消了
        
        
        [self addLocaleNotification:newModel];//新增加一个提醒
    }
    
}

//删除一个本地通知
- (void)deleteNotificationWithModel:(RemindModel *)model {
    
    //2.删除注册在通知中心的通知
    NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i = 0; i < notificationArray.count; i++) {
        
        UILocalNotification *localNotification = [notificationArray objectAtIndex:i];
        
        NSDictionary *userInfo = localNotification.userInfo;
        
        if ([userInfo[@"myNotification"] isEqualToString:@"myNotification"]) {//表示这个通知是我们自己注册的
            
            NSDateFormatter *formattor = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString *fireDateString = [formattor stringFromDate:localNotification.fireDate];//当前需要修改的通知开火时间
            
            NSString *oldFireDateString = [formattor stringFromDate:model.date];//原来新增通知的时候设置开火时间
        
            if ([fireDateString isEqualToString:oldFireDateString]) {
            
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
            
        }
    }
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
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RemindModel" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (_persistentStoreCoordinator != nil) {
        
        return _persistentStoreCoordinator;
        
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RemindModel.sqlite"];
    
    NSError *error = nil;
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        
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
