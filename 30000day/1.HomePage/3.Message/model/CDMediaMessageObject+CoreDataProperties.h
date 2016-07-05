//
//  CDMediaMessageObject+CoreDataProperties.h
//  30000day
//
//  Created by GuoJia on 16/7/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDMediaMessageObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDMediaMessageObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *conversationId;
@property (nullable, nonatomic, retain) NSString *imageMessageId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *localURLString;
@property (nullable, nonatomic, retain) NSString *remoteURLString;
@property (nullable, nonatomic, retain) NSDate *messageDate;

@end

NS_ASSUME_NONNULL_END
