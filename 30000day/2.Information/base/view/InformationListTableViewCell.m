//
//  InformationListTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InformationListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInformationModel:(InformationModel *)informationModel {

    [self.infoPhotosImageView sd_setImageWithURL:[NSURL URLWithString:informationModel.infoPhoto]];
    
    [self.infoTitleLable setText:informationModel.infoName];

    self.infoCommentCount.text = [NSString stringWithFormat:@"%ld评",(long)informationModel.commentCount];
    
    self.infoCategoryLable.text = informationModel.infoCategory;
    
}

@end
