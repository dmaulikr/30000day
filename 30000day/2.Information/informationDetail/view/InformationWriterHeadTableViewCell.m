//
//  InformationWriterHeadTableViewCell.m
//  30000day
//
//  Created by wei on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationWriterHeadTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InformationWriterHeadTableViewCell

- (void)awakeFromNib {

    [self.subscriptionButton addTarget:self action:@selector(subscriptionButtonClick:) forControlEvents:UIControlEventTouchDown];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInformationWriterModel:(InformationWriterModel *)informationWriterModel {

    if (informationWriterModel.isMineSubscribe) {
        
        [self.subscriptionButton setTitle:@"取消订阅" forState:UIControlStateNormal];
        
    } else {
    
        [self.subscriptionButton setTitle:@"订阅" forState:UIControlStateNormal];
        
    }
    
    self.subscriptionButton.tag = informationWriterModel.isMineSubscribe;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:informationWriterModel.headImg]];
    
    [self.nameLable setText:informationWriterModel.writerName];
    
    [self.synopsisLable setText:informationWriterModel.writerDescription];
    
    [self.subscriptionCountLable setText:[NSString stringWithFormat:@"%ld",informationWriterModel.subscribeCount]];

}

- (void)subscriptionButtonClick:(UIButton *)sender {

    if (self.subscriptionButtonBlock) {
        
        self.subscriptionButtonBlock(sender);
        
    }

}

@end
