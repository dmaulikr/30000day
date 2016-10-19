//
//  ShopModel.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"activityList" : [ActivityModel class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"productId":@"id"};
}

@end
