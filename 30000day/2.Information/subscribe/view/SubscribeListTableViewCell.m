//
//  SubscribeListTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeListTableViewCell.h"

@implementation SubscribeListTableViewCell

- (void)awakeFromNib {
    
    self.willShowImageView.layer.cornerRadius = 3;
    
    self.willShowImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
