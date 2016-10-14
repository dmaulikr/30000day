//
//  STPraiseReplyStorageManager.m
//  30000day
//
//  Created by GuoJia on 16/9/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STPraiseReplyCoreDataStorage.h"
#import "NSManagedObject+handler.h"
//#import "PraiseReplyStorageObject.h"
#import "CDChatManager.h"
#import "UserInformationModel.h"
#import "STCoreDataStorageProtected.h"


typedef void(^OperationResult)(NSError *error);
static STPraiseReplyCoreDataStorage *instance;

@interface STPraiseReplyCoreDataStorage ()

@end

@implementation STPraiseReplyCoreDataStorage

+ (STPraiseReplyCoreDataStorage *)shareStorage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[STPraiseReplyCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
        
    });
    return instance;
}

- (void)commonInit {
    [super commonInit];
    
    // This method is invoked by all public init methods of the superclass
//    autoRemovePreviousDatabaseFile = NO;
//    autoRecreateDatabaseFile = YES;
}

- (void)dealloc {
#if !OS_OBJECT_USE_OBJC
    if (parentQueue)
        dispatch_release(parentQueue);
#endif
}

//新增或者刷新消息数组
- (void)addPraiseReplyWith:(NSArray <AVIMTypedMessage *>*)messageArray visibleType:(NSNumber *)visibleType {
    // 苹果官方给出方法
//    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//    [context setParentContext:self.mainThreadManagedObjectContext];
//    [context performBlock:^{
//        NSLog(@"----%@",[NSThread currentThread].description);
//        if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
//            
//            for (int i = 0; i <messageArray.count ; i++) {
//                AVIMTypedMessage *message = messageArray[i];
//                PraiseReplyStorageModel *model = [[PraiseReplyStorageModel alloc] init];
//                model.metaData = [NSKeyedArchiver archivedDataWithRootObject:message];
//                model.userId = STUserAccountHandler.userProfile.userId;
//                model.readState = @1;
//                model.messageId = message.messageId;
//                model.messageType = [NSNumber numberWithUnsignedInteger:message.mediaType];
//                model.visibleType = visibleType;
//                
//                 NSEntityDescription *entity = [NSEntityDescription entityForName:@"PraiseReplyStorageObject" inManagedObjectContext:context];
//                PraiseReplyStorageObject *object = (PraiseReplyStorageObject *)
//                [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
//                object.metaData = model.metaData;
//                object.readState = @1;
//                object.userId = model.userId;
//                object.messageId = model.messageId;
//                object.messageType = model.messageType;
//                object.visibleType = model.visibleType;
//                
//                [context insertObject:object];
//            }
//            
//            NSError *error = nil;
//            if (![context save:&error]) {
//                NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
//                abort();
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                [self.mainThreadManagedObjectContext performBlockAndWait:^{
//                    NSError *error = nil;
//                    if (![self.mainThreadManagedObjectContext save:&error]) {
//                        NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
//                        abort();
//                    } else {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [STNotificationCenter postNotificationName:STSameBodyReplyPraiseSendNotification object:visibleType];
//                        });
//                    }
//                }];
//            });
//        }
//    }];
    
    //xmppp协议所使用的方法
    [self scheduleBlock:^{
        
        if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {

            for (int i = 0; i <messageArray.count ; i++) {
                AVIMTypedMessage *message = messageArray[i];
                
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"PraiseReplyStorageObject" inManagedObjectContext:self.managedObjectContext];
                PraiseReplyStorageObject *object = (PraiseReplyStorageObject *)
                [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
                object.metaData = [NSKeyedArchiver archivedDataWithRootObject:message];
                object.readState = 1;
                object.userId = [STUserAccountHandler.userProfile.userId intValue];
                object.messageId = message.messageId;
                object.messageType = message.mediaType;
                object.visibleType = [visibleType intValue];
                
                [self.managedObjectContext insertObject:object];
                [self save];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [STNotificationCenter postNotificationName:STSameBodyReplyPraiseSendNotification object:visibleType];
                });
            }
        }
    }];
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

- (void)_setIsReadedWithModel:(NSArray <PraiseReplyStorageModel *>*)array {
    [self executeBlock:^{
        for (int i = 0; i < array.count; i++) {
            PraiseReplyStorageModel *model = array[i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND messageId == %@ AND visibleType == %@",model.userId,model.messageId,model.visibleType];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"PraiseReplyStorageObject" inManagedObjectContext:self.managedObjectContext]];
            request.predicate = predicate;
            request.sortDescriptors = @[descriptor];
            
            NSError *error = nil;
            NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:&error];
            
            if (dataArray.count) {
                PraiseReplyStorageObject *object = dataArray[0];
                object.readState = [model.readState intValue];
            }
        }
        [self save];
    }];
}

- (NSArray <AVIMPraiseMessage *>*)getPraiseMesssageArrayWithVisibleType:(NSNumber *)visibleType readState:(NSNumber *)readState offset:(int)offset limit:(int)limit {
    if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND readState == %@ AND messageType == %@ AND visibleType == %@",STUserAccountHandler.userProfile.userId,readState,@99,visibleType];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"PraiseReplyStorageObject" inManagedObjectContext:self.mainThreadManagedObjectContext]];
        request.predicate = predicate;
        request.sortDescriptors = @[descriptor];
        request.fetchOffset = offset;
        if ( offset >= 0 ) {
            [request setFetchOffset:offset];
        }
        if (limit > 0) {
            [request setFetchLimit:limit];
        }
        
        NSError *error = nil;
        NSArray *dataArray = [self.mainThreadManagedObjectContext executeFetchRequest:request error:&error];
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
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"PraiseReplyStorageObject" inManagedObjectContext:self.mainThreadManagedObjectContext]];
        request.predicate = predicate;
        request.sortDescriptors = @[descriptor];
        request.fetchOffset = offset;
        if ( offset >= 0 ) {
            [request setFetchOffset:offset];
        }
        if (limit > 0) {
            [request setFetchLimit:limit];
        }
        
        NSError *error = nil;
        NSArray *dataArray = [self.mainThreadManagedObjectContext executeFetchRequest:request error:&error];
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

- (void)scheduleGetPraiseMessageArrayWithVisibleType:(NSNumber *)visibleType
                                           readState:(NSNumber *)readState
                                              offset:(int)offset
                                               limit:(int)limit
                                             success:(void (^)(NSMutableArray <AVIMPraiseMessage *>*dataArray))success {
    [self scheduleBlock:^{
       
        if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND readState == %@ AND messageType == %@ AND visibleType == %@",STUserAccountHandler.userProfile.userId,readState,@99,visibleType];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"PraiseReplyStorageObject" inManagedObjectContext:self.managedObjectContext]];
            request.predicate = predicate;
            request.sortDescriptors = @[descriptor];
            request.fetchOffset = offset;
            if ( offset >= 0 ) {
                [request setFetchOffset:offset];
            }
            if (limit > 0) {
                [request setFetchLimit:limit];
            }
            
            NSError *error = nil;
            NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:&error];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 0; i <dataArray.count ; i++) {
                PraiseReplyStorageObject *object = dataArray[i];
                AVIMReplyMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:object.metaData];
                [array addObject:message];
            }
            success(array);
        } else {
            success([[NSMutableArray alloc] init]);
        }
    }];
}

- (void)scheduleGetReplyMessageArrayWithVisibleType:(NSNumber *)visibleType
                                          readState:(NSNumber *)readState
                                             offset:(int)offset
                                              limit:(int)limit
                                            success:(void (^)(NSMutableArray <AVIMPraiseMessage *>*dataArray))success {
    [self scheduleBlock:^{
        
        if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND readState == %@ AND messageType == %@ AND visibleType == %@",STUserAccountHandler.userProfile.userId,readState,@98,visibleType];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"messageId" ascending:YES];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"PraiseReplyStorageObject" inManagedObjectContext:self.managedObjectContext]];
            request.predicate = predicate;
            request.sortDescriptors = @[descriptor];
            request.fetchOffset = offset;
            if ( offset >= 0 ) {
                [request setFetchOffset:offset];
            }
            if (limit > 0) {
                [request setFetchLimit:limit];
            }
            
            NSError *error = nil;
            NSArray *dataArray = [self.managedObjectContext executeFetchRequest:request error:&error];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i = 0; i <dataArray.count ; i++) {
                PraiseReplyStorageObject *object = dataArray[i];
                AVIMReplyMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:object.metaData];
                [array addObject:message];
            }
            success(array);
        } else {
            success([[NSMutableArray alloc] init]);
        }
    }];
}

+ (void)sendPraiseReplyMessageWith:(AVIMTypedMessage *)message memberClientIdArray:(NSArray *)memberClientIdArray userInformationModel:(UserInformationModel *)model callBack:(void (^)(BOOL success,NSError *error,AVIMConversation *conversation))callBack {
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile]) {
        callBack(NO,nil,nil);
    } else {
        NSMutableDictionary *dictonary = [UserInformationModel attributesWithInformationModelArray:@[model] userProfile:STUserAccountHandler.userProfile chatType:@0];
        
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
        [STPraiseReplyCoreDataStorage sendPraiseReplyMessageWith:message memberClientIdArray:userIdArray userInformationModel:model callBack:^(BOOL success, NSError *error, AVIMConversation *conversation) {
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
        [STPraiseReplyCoreDataStorage sendPraiseReplyMessageWith:message memberClientIdArray:userIdArray userInformationModel:model callBack:^(BOOL success, NSError *error, AVIMConversation *conversation) {
        }];
    }
}

@end
