//
//  STShowReplyPraiseTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/9/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowReplyPraiseTableViewCell.h"

@implementation STShowReplyPraiseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 3;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
