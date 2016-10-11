//
//  STMediumSiftCoreDataObject.h
//  30000day
//
//  Created by GuoJia on 16/10/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface STMediumSiftCoreDataObject : NSManagedObject

@property (nonatomic,strong) NSNumber *index;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSSet *visible;

@end
