//
//  SportsFunction+CoreDataProperties.h
//  30000day
//
//  Created by WeiGe on 16/7/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SportsFunction.h"

NS_ASSUME_NONNULL_BEGIN

@interface SportsFunction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *speechDistance;
@property (nullable, nonatomic, retain) NSString *mapType;
@property (nullable, nonatomic, retain) NSNumber *userId;

@end

NS_ASSUME_NONNULL_END
