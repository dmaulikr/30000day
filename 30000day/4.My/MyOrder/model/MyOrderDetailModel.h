//
//  MyOrderDetailModel.h
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppointmentModel.h"

@interface MyOrderDetailModel : NSObject

@property (nonatomic,strong) NSNumber *orderDate;//创建时间

@property (nonatomic,strong) NSNumber *orderId;//订单id

@property (nonatomic,strong) NSNumber *quantity;//数量

@property (nonatomic,strong) NSNumber *orderDetailId;//id

@property (nonatomic,strong) NSMutableArray *orderCourtList;

@property (nonatomic,copy) NSString *orderNo;//订单编号

@property (nonatomic,strong) NSNumber *productId;//商品id

@property (nonatomic,copy) NSString *productName;//商品名字

@property (nonatomic,copy) NSString *productPhoto;//图片url

@property (nonatomic,copy) NSString *status;//商品状态

@property (nonatomic,copy) NSString *totalPrice;//价格

@end


