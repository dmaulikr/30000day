//
//  STLocationMananger.h
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocationModel;

@interface STLocationMananger : NSObject

+ (STLocationMananger *)shareManager;

- (void)synchronizedLocationDataFromServer;//从服务器同步数据

- (NSMutableArray *)getHotCity;

@end
