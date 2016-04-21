//
//  SubscribeTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/4/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeTableViewCell.h"

@implementation SubscribeTableViewCell

- (void)awakeFromNib {
    
    self.secondSucribeButton.layer.borderColor = LOWBLUECOLOR.CGColor;
    
    self.secondSucribeButton.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
