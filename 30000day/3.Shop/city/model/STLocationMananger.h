//
//  STLocationMananger.h
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  把地址数据写入文件进行本地缓存

#import <Foundation/Foundation.h>

@class LocationModel;

@interface STLocationMananger : NSObject

@property (nonatomic,strong) NSMutableArray *locationArray;

@property (nonatomic,strong) NSMutableArray *subWayArray;

+ (STLocationMananger *)shareManager;

- (void)synchronizedLocationDataFromServer;//从服务器同步数据

- (NSMutableArray *)getHotCity;

@end
