//
//  CountDownTableViewCell.m
//  30000day
//
//  Created by WeiGe on 16/6/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CountDownTableViewCell.h"

@implementation CountDownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.timeButton addTarget:self action:@selector(timeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)timeButtonClick {

    if (self.chooseAgeBlock) {
        self.chooseAgeBlock();
    }
    
}

@end
