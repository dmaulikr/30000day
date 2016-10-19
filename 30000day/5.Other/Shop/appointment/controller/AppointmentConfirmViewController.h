//
//  AppointmentConfirmViewController.h
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShowBackItemViewController.h"

@interface AppointmentConfirmViewController : ShowBackItemViewController

@property (nonatomic,strong) NSMutableArray *timeModelArray;

@property (nonatomic,strong) NSDate *selectorDate;//选中的日期

@property (nonatomic,strong) NSNumber *productId;//商品id

@property (nonatomic,copy) NSString *productName;//商品的名字

@end
