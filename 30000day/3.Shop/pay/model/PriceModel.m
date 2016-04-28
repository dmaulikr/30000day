//
//  PriceModel.m
//  30000day
//
//  Created by GuoJia on 16/4/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PriceModel.h"

@implementation PriceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"activityList" : [ActivityModel class]};
}

@end
