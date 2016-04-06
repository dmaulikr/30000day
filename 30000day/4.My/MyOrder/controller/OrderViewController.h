//
//  OrderViewController.h
//  30000day
//
//  Created by GuoJia on 16/4/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STBaseViewController.h"

typedef NS_ENUM(NSInteger,OrderType) {
    
    OrderTypeAll,//所有的
    
    OrderTypeWillPay,//即将付款
    
    OrderTypepaid//已付款
};

@interface OrderViewController : STRefreshViewController

@property(nonatomic, assign) OrderType type;

@end
