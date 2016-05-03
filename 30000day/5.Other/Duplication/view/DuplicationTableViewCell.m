//
//  DuplicationTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/4/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "DuplicationTableViewCell.h"

@implementation DuplicationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellWithActivityModel:(ActivityModel *)model {
    
    self.contentLabel_first.textColor = [UIColor redColor];
    
    if ([model.activityType isEqualToString:@"01"]) {//满减
        
        self.titleLabel_first.text = @"满减";
        
        self.contentLabel_first.text = [NSString stringWithFormat:@"- ￥: %.2f",[model.discountAmount floatValue]];
        
    } else if ([model.activityType isEqualToString:@"02"]) {//券
        
        self.titleLabel_first.text = @"优惠券";
        
        self.contentLabel_first.text = [NSString stringWithFormat:@"- ￥: %.2f",[model.discountAmount floatValue]];
    }
}

//配置预约场次
- (void)configCellWithAppointmentTimeModel:(AppointmentTimeModel *)timeModel {
    
    self.contentLabel_first.textColor = [UIColor darkGrayColor];
    
    if ([Common isObjectNull:timeModel.uniqueKey] && ![Common isObjectNull:timeModel.courtName]) {//订单详情使用
        
        self.contentLabel_first.text = [NSString stringWithFormat:@"%@ %@ %@元",timeModel.timeRange,timeModel.courtName,timeModel.price];
        
    } else {//提交订单的时候使用
        
        self.contentLabel_first.text = [NSString stringWithFormat:@"%@ %@号场 %@元",timeModel.timeRange,[timeModel.uniqueKey substringWithRange:NSMakeRange(8, 1)],timeModel.price];
    }
}

@end
