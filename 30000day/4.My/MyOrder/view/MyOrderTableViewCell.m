//
//  MyOrderTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "UIImage+WF.h"

@implementation MyOrderTableViewCell

- (void)awakeFromNib {
    
    self.backImageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:@"back"] imageWithTintColor:RGBACOLOR(0, 93, 193, 1)].CGImage scale:2 orientation:UIImageOrientationUpMirrored];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
    
    _orderModel = orderModel;
    
    if ([_orderModel.status isEqualToString:@"1"]) {
        
        [self.handleButton setTitle:@"等待付款" forState:UIControlStateNormal];
    }
    
    [_priceLabel setAttributedText:[Common attributedStringWithPrice:[_orderModel.totalPrice floatValue]]];
}



@end
