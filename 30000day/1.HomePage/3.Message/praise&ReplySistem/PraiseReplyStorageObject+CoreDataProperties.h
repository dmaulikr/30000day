//
//  PraiseReplyStorageObject+CoreDataProperties.h
//  30000day
//
//  Created by GuoJia on 16/7/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PraiseReplyStorageObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PraiseReplyStorageObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *metaData;
@property (nullable, nonatomic, retain) NSString *messageId;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSNumber *readState;//1：表示未读，0：表示已读
@property (nullable, nonatomic, retain) NSNumber *messageType;//消息类型,99:点赞 98:回复
@property (nullable, nonatomic, retain) NSNumber *visibleType;//0自己，1好友 2公开

@end

NS_ASSUME_NONNULL_END
