//
//  SportInformationTable+CoreDataProperties.h
//  30000day
//
//  Created by WeiGe on 16/7/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SportInformationTable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SportInformationTable (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *lastMaxID;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSNumber *stepNumber;
@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *calorie;
@property (nullable, nonatomic, retain) NSNumber *time;
@property (nullable, nonatomic, retain) NSString *x;
@property (nullable, nonatomic, retain) NSString *y;

@end

NS_ASSUME_NONNULL_END
