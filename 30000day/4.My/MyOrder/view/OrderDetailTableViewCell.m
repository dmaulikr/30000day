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
    [super awakeFromNib];
    // Initialization code
    self.firstButton.layer.cornerRadius = 5;
    self.firstButton.layer.masksToBounds = YES;
    self.firstButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.firstButton.layer.borderWidth = 1.0f;
    
    self.secondButton.layer.cornerRadius = 5;
    self.secondButton.layer.masksToBounds = YES;
    self.secondButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.secondButton.layer.borderWidth = 1.0f;
    
    self.thirdButton.layer.cornerRadius = 5;
    self.thirdButton.layer.masksToBounds = YES;
    self.thirdButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.thirdButton.layer.borderWidth = 1.0f;
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
    
    self.applyOrderTime.text = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:[NSDate dateWithTimeIntervalSince1970:[detailModel.orderDate doubleValue]/1000]];
}

- (IBAction)buttonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (self.buttonClick) {
        
        self.buttonClick(button.tag);
        
    }
}

- (IBAction)secondButtonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (self.buttonClick) {
        
        self.buttonClick(button.tag);
        
    }
}

- (IBAction)thirdButtonAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (self.buttonClick) {
        
        self.buttonClick(button.tag);
        
    }
}

@end
