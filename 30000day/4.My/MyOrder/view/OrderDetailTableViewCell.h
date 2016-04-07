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
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumber;
@property (weak, nonatomic) IBOutlet UILabel *productMarkNumber;
- (void)configProductInformation:(MyOrderDetailModel *)detailModel;

@end
