//
//  InformationDetailDownTableViewCell.m
//  30000day
//
//  Created by wei on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationDetailDownTableViewCell.h"

@implementation InformationDetailDownTableViewCell

- (void)awakeFromNib {
    
    [self.InformationDetailShare addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.InformationDetailComment addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)shareClick:(UIButton *)sender {
    
    if (self.shareButtonBlock) {
        self.shareButtonBlock((UIButton *)sender);
    }

}

- (void)commentClick {
    
    if (self.commentButtonBlock) {
        self.commentButtonBlock();
    }
    
}


@end
