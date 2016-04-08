//
//  OrderDetailTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderDetailModel.h"

@interface OrderDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *remakLabel;
- (void)configContactPersonInformation:(MyOrderDetailModel *)detailModel;


@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;//商品名字
@property (weak, nonatomic) IBOutlet UILabel *productNumber;//总数
@property (weak, nonatomic) IBOutlet UILabel *productMarkNumber;//订单编号
@property (weak, nonatomic) IBOutlet UILabel *applyOrderTime;//下单时间
- (void)configProductInformation:(MyOrderDetailModel *)detailModel;

@end
