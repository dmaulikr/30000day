//
//  STDenounceModel.m
//  30000day
//
//  Created by GuoJia on 16/9/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STDenounceModel.h"

@implementation STDenounceModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"denounceType":@"id",@"title":@"value"};
}

@end
