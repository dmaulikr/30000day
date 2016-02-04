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

@end
