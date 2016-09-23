//
//  STRelayTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/8/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRelayTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation STRelayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.placeholder = @"说说分享心得";
    self.headImageView.layer.cornerRadius = 3;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.headImageView.backgroundColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setMediumModel:(STMediumModel *)mediumModel {
    
    _mediumModel = mediumModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:mediumModel.originalHeadImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = mediumModel.originalNickName;
    self.contentLabel.text = [mediumModel.infoContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
