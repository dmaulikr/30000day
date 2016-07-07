//
//  jk.h
//  30000天
//
//  Created by wei on 15/11/9.
//  Copyright © 2015年 wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface MotionData : NSObject

//判断设备是否支持
- (void)getHealtHequipmentWhetherSupport:(void (^)(BOOL scs))scs
                                 failure:(void (^)(NSError *error))failure;
//获取今天步数
- (void)getHealthUserDateOfBirthCount:(void (^)(NSString *birthString))success
                              failure:(void (^)(NSError *error))failure;

//获取爬楼梯数
- (void)getClimbStairsCount:(void (^)(NSString *climbStairsString))success
                    failure:(void (^)(NSError *error))failure;

//获取今天运动距离
- (void)getMovingDistanceCount:(void (^)(NSString *movingDistanceString))success
                       failure:(void (^)(NSError *error))failure;

@end
