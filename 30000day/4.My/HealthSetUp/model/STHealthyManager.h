//
//  STHealthyManager.h
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@interface STHealthyManager : STManager

@property (nonatomic,strong) NSMutableArray *healthyArray;

+ (STHealthyManager *)shareManager;

- (void)synchronizedHealthyDataFromServer;

- (NSMutableArray *)array;

@end
