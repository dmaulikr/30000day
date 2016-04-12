//
//  PaymentViewController.h
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : ShowBackItemViewController

@property (nonatomic,strong) NSDate *selectorDate;//选中的日期

@property (nonatomic,strong) NSMutableArray *timeModelArray;

@property (nonatomic,copy) NSString *productName;//商品名字

@property (nonatomic,copy) NSString *orderNumber;//订单编号

@property (nonatomic,strong) NSNumber *productId;//商品id

@end
