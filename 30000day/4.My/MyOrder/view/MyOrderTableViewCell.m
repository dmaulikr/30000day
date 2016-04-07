//
//  MyOrderTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/4/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "UIImage+WF.h"
#import "UIImageView+WebCache.h"

@implementation MyOrderTableViewCell {
    
    NSTimer *_timer;
    int _count;
}

- (void)awakeFromNib {
    
    _count = 60;
    
    self.backImageView.image = [UIImage imageWithCGImage:[[UIImage imageNamed:@"back"] imageWithTintColor:RGBACOLOR(0, 93, 193, 1)].CGImage scale:2 orientation:UIImageOrientationUpMirrored];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
    
    _orderModel = orderModel;
    
    if ([_orderModel.status isEqualToString:@"10"]) {
        
        [self.handleButton setTitle:@"等待付款" forState:UIControlStateNormal];
        
        self.backImageView.hidden = NO;
        
    } else if ([_orderModel.status isEqualToString:@"11"]) {
        
        [self.handleButton setTitle:@"已取消" forState:UIControlStateNormal];
        
        self.backImageView.hidden = YES;
        
    } else if ([_orderModel.status isEqualToString:@"12"]) {
        
        [self.handleButton setTitle:@"已超时" forState:UIControlStateNormal];
        
        self.backImageView.hidden = YES;
        
    } else if ([_orderModel.status isEqualToString:@"2"]) {
        
        [self.handleButton setTitle:@"支付成功" forState:UIControlStateNormal];
        
        self.backImageView.hidden = YES;
    }
    
    self.productNumberLabel.text = [NSString stringWithFormat:@"%@",_orderModel.quantity];//数量
    
    self.titleLabel.text = _orderModel.productName;
    
    //根据网络链接去下载图片
    [self.willShowImageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.productPhoto] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [_priceLabel setAttributedText:[Common attributedStringWithPrice:[_orderModel.totalPrice floatValue]]];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumberOfData) userInfo:nil repeats:YES];
    
    [_timer fire];
}

- (void)countNumberOfData {
    
    self.dateLabel.text = [NSString stringWithFormat:@"%d",_count--];
    
    if (_count == -1) {
        
        _count = 60;
        
        [_timer invalidate];
    }
}

@end
