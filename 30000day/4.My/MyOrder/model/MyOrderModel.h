//
//  MyOrderModel.h
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic,copy) NSString *status;

@property (nonatomic,strong) NSNumber *orderId;

@property (nonatomic,strong) NSNumber *orderDate;//订单日期

@property (nonatomic,strong) NSNumber *userId;//用户Id

@property (nonatomic,copy) NSString *orderNo;//用户编号

@property (nonatomic,copy) NSString *totalPrice;//订单价格

@end
