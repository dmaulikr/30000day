//
//  STPraiseReplyStorageManager.m
//  30000day
//
//  Created by GuoJia on 16/9/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STPraiseReplyStorageManager.h"
#import "NSManagedObject+handler.h"
#import "PraiseReplyStorageObject.h"
#import "CDChatManager.h"
#import "UserInformationModel.h"

typedef void(^OperationResult)(NSError *error);
static STPraiseReplyStorageManager *instance;

@interface STPraiseReplyStorageManager ()

@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;
@property (nonatomic, copy)NSString *modelName;
@property (nonatomic, copy)NSString *dbFileName;

@end

@implementation STPraiseReplyStorageManager

+ (STPraiseReplyStorageManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[STPraiseReplyStorageManager alloc] init];
        [instance configModel:@"StorageSystem" DbFile:@"StorageSystem.sqlite"];
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

//**********************************

//新增或者刷新消息数组
- (void)addPraiseReplyWith:(NSArray <AVIMTypedMessage *>*)messageArray visibleType:(NSNumber *)visibleType {
    
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        for (int i = 0; i <messageArray.count ; i++) {
            AVIMTypedMessage *message = messageArray[i];
            PraiseReplyStorageModel *model = [[PraiseReplyStorageModel alloc] init];
            model.metaData = [NSKeyedArchiver archivedDataWithRootObject:message];
            model.userId = STUserAccountHandler.userProfile.userId;
            model.readState = @1;
            model.messageId = message.messageId;
            model.messageType = [NSNumber numberWithUnsignedInteger:message.mediaType];
            model.visibleType = visibleType;
            [self _addObjectWithModel:model];
        }
        [self save:^(NSError *error) {
            if ([Common isObjectNull:error]) {
                [STNotificationCenter postNotificationName:STSameBodyReplyPraiseSendNotification object:visibleType];
            }
        }];
    }
}

- (void)markMessageWith:(NSArray <AVIMTypedMessage *>*)messageArray visibleType:(NSNumber *)visibleType readState:(NSNumber *)readState {
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i <messageArray.count ; i++) {
            AVIMTypedMessage *message = messageArray[i];
            PraiseReplyStorageModel *model = [[PraiseReplyStorageModel alloc] init];
            model.metaData = [NSKeyedArchiver archivedDataWithRootObject:message];
            model.userId = STUserAccountHandler.userProfile.userId;
            model.readState = readState;
            model.messageId = message.messageId;
            model.messageType = [NSNumber numberWithUnsignedInteger:message.mediaType];
            model.visibleType = visibleType;
            [array addObject:model];
        }
        [self _setIsReadedWithModel:array];
    }
}

- (void)_addObjectWithModel:(PraiseReplyStorageModel *)model {
    PraiseReplyStorageObject *object = [PraiseReplyStorageObject createObjectWithMainContext:self.mainObjectContext];
    object.metaData = model.metaData;
    object.readState = @1;
    object.userId = model.userId;
    object.messageId = model.messageId;
    object.messageType = model.messageType;
    object.visibleType = model.visibleType;
}

- (void)_setIsReadedWithModel:(NSArray <PraiseReplyStorageModel *>*)array {
    
    for (int i = 0; i < array.count; i++) {
        PraiseReplyStorageModel *model = array[i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND messageId == %@ AND visibleType == %@",model.userId,model.messageId,model.visibleType];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
        NSArray *dataArray = [PraiseReplyStorageObject filterWithContext:[STPraiseReplyStorageManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:0 limit:0];
        if (dataArray.count) {
            PraiseReplyStorageObject *object = dataArray[0];
            object.readState = model.readState;
        }
    }
    [self save:nil];
}

- (NSArray <AVIMPraiseMessage *>*)getPraiseMesssageArrayWithVisibleType:(NSNumber *)visibleType readState:(NSNumber *)readState offset:(int)offset limit:(int)limit {
    
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND readState == %@ AND messageType == %@ AND visibleType == %@",STUserAccountHandler.userProfile.userId,readState,@99,visibleType];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
        NSArray *dataArray = [PraiseReplyStorageObject _filterWithContext:[STPraiseReplyStorageManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:offset limit:limit];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i <dataArray.count ; i++) {
            PraiseReplyStorageObject *object = dataArray[i];
            AVIMReplyMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:object.metaData];
            [array addObject:message];
        }
        return array;
    } else {
        return [[NSMutableArray alloc] init];
    }
}

- (NSArray <AVIMPraiseMessage *>*)geReplyMesssageArrayWithVisibleType:(NSNumber *)visibleType readState:(NSNumber *)readState offset:(int)offset limit:(int)limit {
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND readState == %@ AND messageType == %@ AND visibleType == %@",STUserAccountHandler.userProfile.userId,readState,@98,visibleType];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
        NSArray *dataArray = [PraiseReplyStorageObject _filterWithContext:[STPraiseReplyStorageManager shareManager].mainObjectContext predicate:predicate orderby:@[descriptor] offset:offset limit:limit];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i = 0; i <dataArray.count ; i++) {
            PraiseReplyStorageObject *object = dataArray[i];
            AVIMPraiseMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:object.metaData];
            [array addObject:message];
        }
        return array;
    } else {
        return [[NSMutableArray alloc] init];
    }
}

+ (void)sendPraiseReplyMessageWith:(AVIMTypedMessage *)message memberClientIdArray:(NSArray *)memberClientIdArray userInformationModel:(UserInformationModel *)model callBack:(void (^)(BOOL success,NSError *error,AVIMConversation *conversation))callBack {
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile]) {
        callBack(NO,nil,nil);
    } else {
        NSMutableDictionary *dictonary = [UserInformationModel attributesWithInformationModelArray:@[model] userProfile:STUserAccountHandler.userProfile chatType:@0];
//        [dictonary addParameter:@"reply" forKey:@"conversationType"];
//        [dictonary addParameter:@"praise" forKey:@"conversationType"];
        
        [[CDChatManager sharedManager] createConversationWithMembers:memberClientIdArray type:CDConversationTypeSingle unique:YES attributes:dictonary callback:^(AVIMConversation *conversation, NSError *error) {
            
            if ([Common isObjectNull:error]) {
                [[CDChatManager sharedManager] sendMessage:message conversation:conversation callback:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        callBack(YES,nil,conversation);
                    } else {
                        callBack(NO,error,conversation);
                    }
                }];
                
            } else {
                callBack(NO,error,nil);
            }
        }];
    }
}

//发送消息点赞
+ (void)sendPraiseMessage:(NSNumber *)currentUserId currentOriginHeadImg:(NSString *)currentOriginHeadImg currentOriginNickName:(NSString *)currentOriginNickName userId:(NSNumber *)userId originHeadImg:(NSString *)originalHeadImg originalNickName:(NSString *)originalNickName visibleType:(NSNumber *)visibleType {
    if (![currentUserId isEqualToNumber:userId]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary addParameter:currentOriginHeadImg forKey:ORIGINAL_IMG_URL];
        [dictionary addParameter:visibleType forKey:VISIBLETYPE];
        [dictionary addParameter:currentOriginNickName forKey:ORIGINAL_NICK_NAME];
        AVIMPraiseMessage *message = [AVIMPraiseMessage messageWithText:nil file:nil attributes:dictionary];
        //数组
        NSMutableArray *userIdArray = [[NSMutableArray alloc] init];
        [userIdArray addObject:[NSString stringWithFormat:@"%@",currentUserId]];
        [userIdArray addObject:[NSString stringWithFormat:@"%@",userId]];
        //模型
        UserInformationModel *model = [[UserInformationModel alloc] init];
        model.originalHeadImg = originalHeadImg;
        model.originalNickName = originalNickName;
        model.userId = userId;
        //发送消息
        [STPraiseReplyStorageManager sendPraiseReplyMessageWith:message memberClientIdArray:userIdArray userInformationModel:model callBack:^(BOOL success, NSError *error, AVIMConversation *conversation) {
        }];
    }
}

//发送回复消息
+ (void)sendReplyMessage:(NSNumber *)currentUserId currentOriginHeadImg:(NSString *)currentOriginHeadImg currentOriginNickName:(NSString *)currentOriginNickName userId:(NSNumber *)userId originHeadImg:(NSString *)originalHeadImg originalNickName:(NSString *)originalNickName visibleType:(NSNumber *)visibleType {
    
    if (![currentUserId isEqualToNumber:userId]) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary addParameter:currentOriginHeadImg forKey:ORIGINAL_IMG_URL];
        [dictionary addParameter:visibleType forKey:VISIBLETYPE];
        [dictionary addParameter:currentOriginNickName forKey:ORIGINAL_NICK_NAME];
        AVIMReplyMessage *message = [AVIMReplyMessage messageWithText:nil file:nil attributes:dictionary];
        //数组
        NSMutableArray *userIdArray = [[NSMutableArray alloc] init];
        [userIdArray addObject:[NSString stringWithFormat:@"%@",currentUserId]];
        [userIdArray addObject:[NSString stringWithFormat:@"%@",userId]];
        //模型
        UserInformationModel *model = [[UserInformationModel alloc] init];
        model.originalHeadImg = originalHeadImg;
        model.originalNickName = originalNickName;
        model.userId = userId;
        //发送消息
        [STPraiseReplyStorageManager sendPraiseReplyMessageWith:message memberClientIdArray:userIdArray userInformationModel:model callBack:^(BOOL success, NSError *error, AVIMConversation *conversation) {
        }];
    }
}

@end
