//
//  OrderDetailViewController.h
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"

@interface OrderDetailViewController : ShowBackItemViewController

@property (nonatomic,copy)NSString *orderNumber;//订单标号

@property (nonatomic,assign) BOOL isPaid;//是否付款了

//点击底部左按钮的回调
@property (nonatomic,copy) void (^buttonClickBlock)();

@end
