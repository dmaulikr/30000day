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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderModel:(MyOrderModel *)orderModel {
    
    _orderModel = orderModel;
    
    if ([_orderModel.status isEqualToString:@"10"]) {
        
        [self.handleButton setTitle:@"等待付款" forState:UIControlStateNormal];

    } else if ([_orderModel.status isEqualToString:@"11"]) {
        
        [self.handleButton setTitle:@"已取消" forState:UIControlStateNormal];

    } else if ([_orderModel.status isEqualToString:@"12"]) {
        
        [self.handleButton setTitle:@"已超时" forState:UIControlStateNormal];

        
    } else if ([_orderModel.status isEqualToString:@"2"]) {
        
        [self.handleButton setTitle:@"支付成功" forState:UIControlStateNormal];

    }
    
    self.productNumberLabel.text = [NSString stringWithFormat:@"%@",_orderModel.quantity];//数量
    
    self.titleLabel.text = _orderModel.productName;
    
    //根据网络链接去下载图片
    [self.willShowImageView sd_setImageWithURL:[NSURL URLWithString:_orderModel.productPhoto] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [_priceLabel setAttributedText:[Common attributedStringWithPrice:[_orderModel.totalPrice floatValue]]];
    
    [self configTimerWithTimeInter:_orderModel.orderDate];
}

- (void)countNumberOfData {
    
    self.dateLabel.text = [NSString stringWithFormat:@"%d",_count--];

    
    if (_count == -1) {
        
        _count = 60;
        
        [_timer invalidate];
    }
}

- (void)configTimerWithTimeInter:(NSNumber *)timeNumber {
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval currentTimeInterval = [date timeIntervalSince1970];
    
    NSTimeInterval a = [timeNumber doubleValue]/1000;
    
    if ((currentTimeInterval - a ) > 300) {//超过5分钟了
        
        
    } else {//在5分钟之内
        
        NSTimeInterval b = 300 + a - currentTimeInterval;//剩余的时间
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumberOfData) userInfo:nil repeats:YES];
        
        _count = (int)b;
        
        [_timer fire];
    }
}

@end
