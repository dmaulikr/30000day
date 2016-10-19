//
//  ActivityModel.h
//  30000day
//
//  Created by GuoJia on 16/4/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  封装的活动模型

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (nonatomic,copy) NSString *activityDesc;//活动描述

@property (nonatomic,copy) NSString *activityName;//活动名称

@property (nonatomic,copy) NSString *activityType;//活动类型,"01"-> 满减  "02" -> "优惠券"

@property (nonatomic,copy) NSString *discountAmount;//优惠的金额

@end
