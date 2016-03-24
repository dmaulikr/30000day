//
//  PlaceManager.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceManager : NSObject

+ (PlaceManager *)shareManager;

//app首次进来的时候会进行配置
- (void)configManagerSuccess:(void (^)(BOOL))success
                     failure:(void (^)(NSError *error))failure;

//根据城市name来获取该城市下一行政级别（区、县）
- (void)countyArrayWithCityName:(NSString *)cityName success:(void (^)(NSMutableArray *))success;

//根据地名字来获取地名字的id
- (void)placeIdWithPlaceName:(NSString *)placeName success:(void (^)(NSNumber *))success;

//根据pCode来获取商圈数组,数组里面存储的是DataModel
- (NSMutableArray *)businessCircleWithPcode:(NSString *)pCode;

@end
