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
    [super awakeFromNib];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 5.0;
    
    self.subscriptionButton.layer.masksToBounds = YES;
    [self.subscriptionButton.layer setBorderWidth:2.0];
    [self.subscriptionButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    self.subscriptionButton.layer.cornerRadius = 5.0;
    
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
    
    [self.synopsisLable setText:informationWriterModel.writerDescription];
    
    [self.subscriptionCountLable setText:[NSString stringWithFormat:@"%ld人已订阅",(long)informationWriterModel.subscribeCount]];

}

- (void)subscriptionButtonClick:(UIButton *)sender {

    if (self.subscriptionButtonBlock) {
        
        self.subscriptionButtonBlock(sender);
        
    }

}

@end
