//
//  SubscribeListTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SubscribeListTableViewCell

- (void)awakeFromNib {
    
    self.willShowImageView.layer.cornerRadius = 3;
    
    self.willShowImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInformationMySubscribeModel:(InformationMySubscribeModel *)informationMySubscribeModel {

    [self.willShowImageView sd_setImageWithURL:[NSURL URLWithString:informationMySubscribeModel.headImg]];
    
    self.writerName.text = informationMySubscribeModel.writerName;
    
    self.memoLable.text = informationMySubscribeModel.memo;

}

- (void)setSubscriptionModel:(SubscriptionModel *)subscriptionModel {

    [self.willShowImageView sd_setImageWithURL:[NSURL URLWithString:subscriptionModel.headImg]];
    
    self.writerName.text = subscriptionModel.writerName;
    
    self.memoLable.text = subscriptionModel.writerDescription;

}

@end
