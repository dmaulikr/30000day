//
//  SearchVersionManager.h
//  30000day
//
//  Created by GuoJia on 16/5/13.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@interface SearchVersionManager : STManager

+ (SearchVersionManager *)shareManager;

- (void)synchronizedDataFromServer;

@end

@interface SearchTableVersion : NSObject

@property (nonatomic,strong) NSNumber *searchTableVersionId;

@property (nonatomic,copy) NSString *tableName;

@property (nonatomic,copy) NSString *version;

@end