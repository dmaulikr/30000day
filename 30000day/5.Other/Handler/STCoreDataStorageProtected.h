#import "STCoreDataStorage.h"
/**
 * 使用这个类中的方法只有STCoreDataStorage的子类。
**/

@interface STCoreDataStorage (Protected)

#pragma mark Override Me

/**
 * 如果你的子类需要为init做任何事,它可以轻易地通过重写这个方法。
 * 所有公共init方法将调用这个方法结束时实施。
 *
 * 重要:如果重载必须调用[super commonInit]。
**/
- (void)commonInit;

/**
 * 覆盖我,如果需要,提供定制的行为。
 *
 * 此方法查询以获得ManagedObjectModel在包的名称。
 * 它应该返回适当的文件的名称(*。xdatamodel / *。mom/ * .momd)无文件扩展名。
 *
 * 默认实现返回子类的名称,剥离的后缀“CoreDataStorage”。
 * 如。,如果你的子类被命名为“XMPPExtensionCoreDataStorage”,那么该方法将返回“XMPPExtension”。
 *
 * 请注意,文件扩展名不应包括在内。
**/
- (NSString *)managedObjectModelName;


/**
 * 覆盖我,如果需要,提供定制的行为。
 *
 * 此方法查询包含ManagedObjectModel的包。
**/
- (NSBundle *)managedObjectModelBundle;

/**
 * 覆盖我,如果需要,提供定制的行为。
 *
 * 如果initWithDatabaseFileName查询这个方法是:storeOptions:方法调用databaseFileName零参数。
 * 默认实现的回报:
 *
 * [NSString stringWithFormat:% @ @”。sqlite”,[self managedObjectModelName]];
 *
 * 您鼓励使用sqlite文件扩展名。
**/
- (NSString *)defaultDatabaseFileName;


/**
 * 覆盖我,如果需要,提供定制的行为。
 *
 * 如果initWithDatabaseFileName查询这个方法是:storeOptions storeOptions方法调用无参数。
 * 默认实现如下:
 *
 * @ { NSMigratePersistentStoresAutomaticallyOption:@(YES),
 * NSInferMappingModelAutomaticallyOption:@(YES)};
**/
- (NSDictionary *)defaultStoreOptions;

/**
 * 覆盖我,如果需要,提供定制的行为。
 *
 * 如果您正在使用一个数据库文件与纯粹的非持久性数据(例如内存优化目的iOS),
 * 您可能希望删除磁盘上的数据库文件是否已经存在。
 *
 * 如果通过initWithDatabaseFilename实例被创建,然后路径参数将非nil。
 * 如果通过initWithInMemoryStore实例被创建,然后路径参数将是零。
 *
 * 没有默认实现。
**/
- (void)willCreatePersistentStoreWithPath:(NSString *)storePath options:(NSDictionary *)storeOptions;

/**
 * 覆盖我,如果需要,完全自定义持久化存储。
 *
 * 持久存储路径添加到持久存储协调员。
 * 返回true,如果创建持久化存储。
 *
 * 如果通过initWithDatabaseFilename实例被创建,然后路径参数将非nil。
 * 如果通过initWithInMemoryStore实例被创建,然后路径参数将是零。
**/
- (BOOL)addPersistentStoreWithPath:(NSString *)storePath options:(NSDictionary *)storeOptions error:(NSError **)errorPtr;

/**
 * 覆盖我,如果需要,提供定制的行为。
 *
 * 例如,如果您正在使用非持久性数据的数据库和模型发生变化时,你可能想要的
 * 删除磁盘上的数据库文件是否已经存在一个核心数据迁移并不是值得的。
 *
 * 如果通过initWithDatabaseFilename实例被创建,然后路径参数将非nil。
 * 如果通过initWithInMemoryStore实例被创建,然后路径参数将是零。
 *
 * 默认实现简单地写入到XMPP错误日志。
**/
- (void)didNotAddPersistentStoreWithPath:(NSString *)storePath options:(NSDictionary *)storeOptions error:(NSError *)error;

/**
 * 覆盖我,如果需要,提供定制的行为。
 *
 * 为例,你可能想要开始使用之前执行任何非持久性数据的清理数据库。
 *
 * 没有默认实现。
**/
- (void)didCreateManagedObjectContext;

/**
 * 覆盖我之前如果你需要做任何特别的更改保存到磁盘。
 * storageQueue将调用该方法。
 * 没有默认实现。
**/
- (void)willSaveManagedObjectContext;

/**
 * 覆盖我如果你需要做任何特别的修改后保存到磁盘。
 *
 * storageQueue将调用该方法。
 * 没有默认实现。
**/
- (void)didSaveManagedObjectContext;

/**
 * 将调用此方法在主线程,
 * mainThreadManagedObjectContext合并后的变化从另一个上下文。
 *
 * 这个方法可能是有用的,如果你有更改时代码依赖于数据存储了用户界面。例如,你想玩当接收到消息。
 * 你可以播放的声音,从背景队列,但是时间可能会稍微因为
 * 用户界面不会更新直到更改已经保存到磁盘,
 * 然后根据获取的主线程。
 * 或者你可以设置一个标志,然后钩到这个方法
 * 在准确的时间玩声音传播主线程。
 *
 * 没有默认实现。
**/
- (void)mainThreadManagedObjectContextDidMergeChanges;

#pragma mark Setup

/**
 * 这是标准配置的方法使用xmpp扩展配置存储类。
 *
 * 如果需要随时覆盖这个方法,
 * 就调用超在某种程度上,以确保一切都是犹太在这个级别。
 *
 * 请注意,要使用的默认实现允许存储类由多个xmpp流。
 * 如果你设计你的存储类使用一个单独的数据流,然后你应该实现这个方法
 * 确保你们班只能由一个父配置。
 * 如果你,别忘了调用超级。
**/
- (BOOL)configureWithParent:(id)aParent queue:(dispatch_queue_t)queue;

#pragma mark Core Data

/**
 *  标准persistentStoreDirectory方法。
**/
- (NSString *)persistentStoreDirectory;

/**
 * 提供获取。
 *
 * 记住NSManagedObjectContext不是线程安全的。
 * 所以你只能访问该属性的上下文中storageQueue。
 *
 * 重要:
 * 这门课的主要目的是优化磁盘IO的缓冲保存操作来获取。
 * 它使用中概述的方法下面的性能优化的部分。
 * 如果你手动保存获取摧毁这些优化。
 * 参见下面文档executeBlock & scheduleBlock周围适当的使用优化。
**/
@property (readonly) NSManagedObjectContext *managedObjectContext;

#pragma mark Performance Optimizations

/**
 * 查询获取确定未保存的managedObjects的数量。
**/
- (NSUInteger)numberOfUnsavedChanges;

/**
 * 你不会经常需要手动调用这个方法。
 * 它叫做自动,适当的和优化的时候,通过executeBlock和scheduleBlock方法。
 *
 * 一个例外是当你插入/删除/更新大量的对象在一个循环中。
 * 建议您调用保存从内部循环。
 * E.g.:
 * 
 * NSUInteger unsavedCount = [self numberOfUnsavedChanges];
 * for (NSManagedObject *obj in fetchResults)
 * {
 *     [[self managedObjectContext] deleteObject:obj];
 *     
 *     if (++unsavedCount >= saveThreshold)
 *     {
 *         [self save];
 *         unsavedCount = 0;
 *     }
 * }
 * 
 * 参见下面的文档executeBlock和scheduleBlock。
**/
- (void)save; // Read the comments above !

/**
 * 你很少需要手动调用这个方法。
 * 它叫做自动,适当的和优化的时候,通过executeBlock和scheduleBlock方法。
 *
 * 此方法使明智的决定是否应该获取更改保存到磁盘。
 * 因为这个磁盘IO是一个缓慢的过程,最好是缓冲区写在高需求。
 * 此方法考虑挂起的请求等待存储实例的数量,
 * 以及未保存的更改的数量(位于NSManagedObjectContext的内存)。
 *
 * 请参见下面文档executeBlock和scheduleBlock。
**/
- (void)maybeSave; // Read the comments above !

/**
 * 此方法同步调用storageQueue给定的块(dispatch_sync)。
 *
 * 在派遣之前阻止它的增量(自动)挂起的请求的数量。
 * 块被执行后,它将(自动)挂起的请求的数量,
 * 然后调用maybeSave方法实现优化磁盘IO背后的逻辑。
 *
 * 如果使用executeBlock和scheduleBlock方法你所有的数据库操作,
 * 免费你会自动继承优化磁盘IO。
 *
 * 如果你手动调用[获取保存:]你破坏这个类提供的优化。
 *
 * 块交给该方法自动NSAutoreleasePool包裹在一起,
 * 所以没有需要创建这些自己是该方法自动为您处理。
 *
 * 这门课的架构故意给一个单独的dispatch_queue CoreDataStorage实例从父母XmppExtension *。这不仅允许单个存储实例服务多个扩展
 * 实例,但它提供了磁盘IO优化的机制。背后的理论优化
 * 是推迟一个保存的数据(一个缓慢的操作),直到不再使用存储类。与xmpp
 * 它通常情况下的数据引起的一系列查询和/或更新存储类。
 * 因此,理论才缓慢的保存操作后的热潮已经结束,存储
 * 类不再有任何挂起的请求。
 *
 * 调用该方法被设计成在XmppExtension存储协议的方法。换句话说,它是希望从dispatch_queue除了storageQueue被调用。
 * 如果你试图从storageQueue中调用这个方法,就会抛出一个异常。
 * 因此应该小心当设计实现。
 * 推荐的程序如下:
 *
 * 所有的方法实现XmppExtension存储协议调用executeBlock或scheduleBlock。
 * 不过,这些方法调用彼此(他们只从XmppExtension调用实例)。
 * 相反,创建内部可能被调用的实用方法。
 *
 * 为例,看看_userForJID XMPPRosterCoreDataStorage实现:xmppStream:方法。
**/
- (void)executeBlock:(dispatch_block_t)block;

/**
 * 此异步方法调用给定块storageQueue(设置)。
 * 它的工作原理非常类似于executeBlock的方法。
 * 看到上述executeBlock方法充分讨论。
**/
- (void)scheduleBlock:(dispatch_block_t)block;

/**
 * 有时你想调用一个方法之前调用节省管理对象上下文如willSaveObject:
 *
 * addWillSaveManagedObjectContextBlock允许您添加一个代码块被称为储蓄管理对象上下文之前,
 * without the overhead of having to call save at that moment.
**/
- (void)addWillSaveManagedObjectContextBlock:(void (^)(void))willSaveBlock;

/**
 * 有时你想调用一个方法调用后节省管理对象上下文如didSaveObject:
 *
 * addDidSaveManagedObjectContextBlock允许您添加一个代码块保存管理对象上下文之后,
 * without the overhead of having to call save at that moment.
**/
- (void)addDidSaveManagedObjectContextBlock:(void (^)(void))didSaveBlock;

@end
