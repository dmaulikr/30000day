//
//  PlaceObject+CoreDataProperties.h
//  30000day
//
//  Created by GuoJia on 16/3/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlaceObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlaceObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *averageLife;
@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSString *fraction;
@property (nullable, nonatomic, retain) NSNumber *dataId;
@property (nullable, nonatomic, retain) NSString *level;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *pCode;
@property (nullable, nonatomic, retain) NSString *rootCode;
@property (nullable, nonatomic, retain) NSString *isHotCity;
@property (nullable, nonatomic, retain) NSString *businessCircle;

@end

NS_ASSUME_NONNULL_END
