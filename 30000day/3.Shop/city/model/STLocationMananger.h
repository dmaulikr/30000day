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

- (void)cacheDataWithLocationModel:(LocationModel *)model;

@end
