//
//  OrderDetailViewController.h
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

typedef NS_ENUM(NSInteger,OrderStatus) {
    
    OrderStatusPay,//已经付款
    
    OrderStatusWillPay,//等待付款
    
    OrderStatusOvertime,//超时
    
    OrderStatusCancel,//已取消
    
};

#import "ShowBackItemViewController.h"

@interface OrderDetailViewController : STRefreshViewController

@property (nonatomic,copy)NSString *orderNumber;//订单标号

@end
