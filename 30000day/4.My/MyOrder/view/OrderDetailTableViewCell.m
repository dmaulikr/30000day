//
//  OrderDetailTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "OrderDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AppointmentModel.h"

@implementation OrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configContactPersonInformation:(MyOrderDetailModel *)detailModel {
    
    AppointmentTimeModel *timeModel = [detailModel.orderCourtList firstObject];
    
    self.contactLabel.text = timeModel.reserverName;
    
    self.contactPhoneNumber.text = timeModel.reserverContactNo;
    
    if ([Common isObjectNull:timeModel.memo]) {
        
        self.remakLabel.text = @"备注：        暂无备注";
        
    } else {
        
         self.remakLabel.text = [NSString stringWithFormat:@"备注：        %@",timeModel.memo];
    }
}

- (void)configProductInformation:(MyOrderDetailModel *)detailModel {
    
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.productPhoto] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.productNameLabel.text = detailModel.productName;
    
    self.productNumber.text = [NSString stringWithFormat:@"%@",detailModel.quantity];
    
    self.productMarkNumber.text = detailModel.orderNo;
}

@end
