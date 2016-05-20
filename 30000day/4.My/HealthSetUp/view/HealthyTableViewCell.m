//
//  HealthyTableViewCell.m
//  Healthy
//
//  Created by wei on 15/10/14.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "HealthyTableViewCell.h"

@implementation HealthyTableViewCell

- (void)awakeFromNib {

    [self.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)setButtonClick:(id)sender {
    
    if (self.setButtonClick) {
        
        self.setButtonClick(self.cellIndexPath);
    }
}


- (void)setFactorModel:(GetFactorModel *)factorModel {
    
    _factorModel = factorModel;
    
    self.titleLabel.text = _factorModel.factor;
    
    //如果用户有选择设置健康因子，那么就要显示该健康因子,如果用户没有选择健康因子，那么要显示设置
    [self.setButton setTitle:[Common isObjectNull:factorModel.userSubFactorModel.factor] ? @"设置" : factorModel.userSubFactorModel.factor  forState:UIControlStateNormal];
    
    [self.setButton setTitleColor:[Common isObjectNull:factorModel.userSubFactorModel.factor] ? LOWBLUECOLOR : [UIColor blackColor] forState:UIControlStateNormal];
}

@end
