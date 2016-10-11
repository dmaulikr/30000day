//
//  STMediumVisibleTypeCoreDataObject.h
//  30000day
//
//  Created by GuoJia on 16/10/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <CoreData/CoreData.h>
@class STMediumSiftCoreDataObject;

@interface STMediumVisibleTypeCoreDataObject : NSManagedObject

@property (nonatomic,strong) NSNumber *status;//0,原始状态 1.被选择了
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSNumber *visibleType;
@property (nonatomic,strong) STMediumSiftCoreDataObject *sift;

@end
