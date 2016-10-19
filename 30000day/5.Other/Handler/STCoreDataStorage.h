//
//  STCoreDataStorage.h
//  30000day
//
//  Created by GuoJia on 16/10/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>

@interface STCoreDataStorage : NSObject {
@private
    
    OSAtomic_int64_aligned64_t pendingRequests;
    
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *mainThreadManagedObjectContext;
    
    NSMutableArray *willSaveManagedObjectContextBlocks;
    NSMutableArray *didSaveManagedObjectContextBlocks;
    
@protected
    
    NSString *databaseFileName;
    NSDictionary *storeOptions;
    NSUInteger saveThreshold;
    NSUInteger saveCount;
    
    BOOL autoRemovePreviousDatabaseFile;
    BOOL autoRecreateDatabaseFile;
    BOOL autoAllowExternalBinaryDataStorage;
    
    dispatch_queue_t storageQueue;
    void *storageQueueTag;
}

/**
 * 初始化一个核心数据存储实例,SQLite的支持下,与给定的数据库存储文件名。
 * 建议数据库filname使用文件扩展名(如“sqlite”。“XMPPRoster.sqlite”)。
 * 如果你通过nil,文件名会自动使用默认数据库。
 * 这个默认来源于类名,
 * 意味着子类将默认数据库文件名来自该子类名称。
 *
 * 如果您尝试创建该类的实例相同的databaseFileName作为另一个现有的实例,这个方法将返回nil。
 **/
- (id)initWithDatabaseFilename:(NSString *)databaseFileName storeOptions:(NSDictionary *)storeOptions;

/**
 * 初始化一个核心数据存储实例,由一个内存中的存储。
 **/
- (id)initWithInMemoryStore;

/**
 * 只读存取databaseFileName初始化期间使用。
 * 如果nil是传递给init方法,返回实际databaseFileName(默认文件名)使用。
 **/
@property (readonly) NSString *databaseFileName;

/**
 * 只读存取databaseOptions初始化期间使用。
 * 如果nil是传递给init方法,返回实际databaseOptions(默认databaseOptions)使用。
 **/
@property (readonly) NSDictionary *storeOptions;

/**
 * saveThreshold指定的最大数量未保存的更改nsmanagedobject保存之前触发。
 *
 * 自NSManagedObjectContext保留任何改变对象,直到他们保存到磁盘
 * 这是一个重要的内存管理关注改变对象的数量保持在健康的范围。
 *
 * 500(默认)
 **/
@property (readwrite) NSUInteger saveThreshold;

/**
 * 提供访问的线程安全组件CoreData堆栈。
 *
 * 请注意:
 * 获取storageQueue是私人的。
 * 如果你在主线程可以使用mainThreadManagedObjectContext。
 * 否则你必须创建和使用自己的获取。
 *
 * 如果你认为你可以简单地添加一个属性为私营,获取
 * 然后你需要去阅读核心数据的文档,
 * 专门一节题为“与核心数据并发性”。
 *
 * @see mainThreadManagedObjectContext
 **/
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 * 方便的方法去获取适合使用在主线程。
 * 这里应该只用于从主线程。
 *
 * NSManagedObjectContext CoreData堆栈是一个轻量级的线程不安全的组成部分。
 * 因此获取只能从一个线程访问,或从一个序列化的队列。
 *
 * 获取与持久化存储。
 * 在大多数情况下,持久化存储是一个sqlite数据库文件。
 * 所以想获取作为底层数据库表的缓存。
 *
 * 此方法懒洋洋地创建一个适当的获取,
 * 与持久性存储的实例相关联,
 * 和配置为自动从其他线程合并变更集。
 **/
@property (strong, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;

/**
 * 之前的数据库文件是之前创建一个持久性存储中删除。
 *
 * 默认 NO
 **/
@property (readwrite) BOOL autoRemovePreviousDatabaseFile;

/**
 * 自动重新创建数据库文件如果持久性存储不能读它如模型更改或文件变得腐败。
 *  For greater control overide  didNotAddPersistentStoreWithPath:
 *
 * 默认NO
 **/
@property (readwrite) BOOL autoRecreateDatabaseFile;

/**
 * 这个方法调用setAllowsExternalBinaryDataStorage:是的所有二进制数据属性的管理对象模型。
 * 操作系统版本不支持外部的二进制数据存储,这个属性没有。
 *
 * Default NO
 **/
@property (readwrite) BOOL autoAllowExternalBinaryDataStorage;

@end
