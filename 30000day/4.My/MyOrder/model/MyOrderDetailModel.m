//
//  MyOrderDetailModel.m
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MyOrderDetailModel.h"

@implementation MyOrderDetailModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"orderCourtList" : [AppointmentTimeModel class]};
}

@end
