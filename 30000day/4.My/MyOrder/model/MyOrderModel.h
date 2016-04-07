//
//  MyOrderModel.h
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic,copy) NSString *status;//1表示 

@property (nonatomic,strong) NSNumber *orderId;

@property (nonatomic,strong) NSNumber *orderDate;//订单日期

@property (nonatomic,strong) NSNumber *userId;//用户Id

@property (nonatomic,copy) NSString *orderNumber;//订单编号

@property (nonatomic,copy) NSString *totalPrice;//订单价格

@property (nonatomic,copy) NSString *productName;//标题

@property (nonatomic,copy) NSString *productPhoto;//图标

@property (nonatomic,strong) NSNumber *quantity;//数量

@end
