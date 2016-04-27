//
//  ShopDetailModel.m
//  30000day
//
//  Created by wei on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailModel.h"

@implementation ShopDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"activityList" : [ActivityModel class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"shopDetailId":@"id"};
}


@end
