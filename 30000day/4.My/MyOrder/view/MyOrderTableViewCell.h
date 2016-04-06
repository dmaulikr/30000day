//
//  MyOrderTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"

@interface MyOrderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIButton *handleButton;

@property (nonatomic,strong) MyOrderModel *orderModel;

@property (weak, nonatomic) IBOutlet UIImageView *willShowImageView;//将要显示的imageView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题label

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格label

@property (weak, nonatomic) IBOutlet UILabel *productNumberLabel;//总数个数label

@end
