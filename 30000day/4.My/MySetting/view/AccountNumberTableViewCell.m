//
//  AccountNumberTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AccountNumberTableViewCell.h"

@implementation AccountNumberTableViewCell

- (void)awakeFromNib {
    
    self.accountNumberLable.font = [UIFont systemFontOfSize:15];
    
    self.phoneNumberLable.textColor = RGBACOLOR(130, 130, 130, 1);
    
    self.phoneNumberLable.font = [UIFont systemFontOfSize:15];
    
    self.mailLable.textColor = RGBACOLOR(130, 130, 130, 1);
    
    self.mailLable.font = [UIFont systemFontOfSize:15];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
