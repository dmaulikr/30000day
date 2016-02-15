//
//  HeadViewTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/15.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "HeadViewTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation HeadViewTableViewCell

- (void)awakeFromNib {
    
    self.headImageView.layer.cornerRadius = 3;
    
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeadImageViewURLString:(NSString *)headImageViewURLString {
    
    _headImageViewURLString = headImageViewURLString;
    
    if (![Common isObjectNull:_headImageViewURLString]) {
        
        [self.headImageView  sd_setImageWithURL:[NSURL URLWithString:_headImageViewURLString]];
    }
    
}

@end
