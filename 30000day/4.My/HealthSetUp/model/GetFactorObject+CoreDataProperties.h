//
//  GetFactorObject+CoreDataProperties.h
//  30000day
//
//  Created by GuoJia on 16/5/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GetFactorObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetFactorObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *factorId;
@property (nullable, nonatomic, retain) NSString *factor;
@property (nullable, nonatomic, retain) NSNumber *pid;
@property (nullable, nonatomic, retain) NSString *level;

@end

NS_ASSUME_NONNULL_END
