//
//  STChooseItemObject+CoreDataProperties.h
//  30000day
//
//  Created by GuoJia on 16/8/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "STChooseItemObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface STChooseItemObject (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *itemTag;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSNumber *visibleType;
@property (nullable, nonatomic, retain) NSNumber *isChoosed;//@0未被选择的；@1被选中的；@3初始状态

@end

NS_ASSUME_NONNULL_END
