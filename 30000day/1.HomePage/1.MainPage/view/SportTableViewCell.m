//
//  SportTableViewCell.m
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportTableViewCell.h"

@implementation SportTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.beginButton.layer.masksToBounds = YES;
    
    self.beginButton.layer.cornerRadius = 40;
    
    [self.beginButton addTarget:self action:@selector(beginSport:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)beginSport:(UIButton *)sender {

    if (self.buttonBlock) {
        self.buttonBlock(sender);
    }
    
}

@end
