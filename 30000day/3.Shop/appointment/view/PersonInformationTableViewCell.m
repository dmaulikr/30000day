//
//  PersonInformationTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonInformationTableViewCell.h"
#import "MyOrderDetailModel.h"

@implementation PersonInformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configTotalPriceWith:(NSMutableArray *)timeModelArray {
    
    //设置价格
    float price ;
    
    for (AppointmentTimeModel *time_model  in timeModelArray) {
        
        price += [time_model.price floatValue];
    }
    
    [_totalPriceLabel setAttributedText:[PersonInformationTableViewCell priceAttributeString:price]];
}

+ (NSMutableAttributedString *)priceAttributeString:(float)price {
    
    NSString *priceString = [NSString stringWithFormat:@"%.2f",price];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",priceString]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
    
    return string;
}

- (void)configOrderWithAppointmentTimeModel:(AppointmentTimeModel *)timeModel {

    if ([Common isObjectNull:timeModel.uniqueKey] && ![Common isObjectNull:timeModel.courtName]) {//订单详情使用
        
        _contentLabel.text = [NSString stringWithFormat:@"%@ %@ %@元",timeModel.timeRange,timeModel.courtName,timeModel.price];
        
    } else {//提交订单的时候使用
        
        _contentLabel.text = [NSString stringWithFormat:@"%@ %@号场 %@元",timeModel.timeRange,[timeModel.uniqueKey substringWithRange:NSMakeRange(8, 1)],timeModel.price];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
