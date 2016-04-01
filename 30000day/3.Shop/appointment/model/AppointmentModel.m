//
//  AppointmentModel.m
//  30000day
//
//  Created by GuoJia on 16/4/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentModel.h"

@implementation AppointmentModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"timeRangeList" : [AppointmentTimeModel class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"courtId":@"id"};
}

@end

@implementation AppointmentTimeModel


@end