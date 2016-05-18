//
//  SearchResultTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchResultTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
   
    self.headImageView.layer.cornerRadius = 4;
    
    self.headImageView.layer.masksToBounds = YES;
    
    self.addButton.layer.cornerRadius = 3;
    
    self.addButton.layer.masksToBounds = YES;
    
    //self.addButton.layer.borderColor = LOWBLUECOLOR.CGColor;
    
    self.addButton.layer.borderWidth = 0.5f;

    self.addButton.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setUserInformationModel:(UserInformationModel *)userInformationModel {
    
    _userInformationModel = userInformationModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:userInformationModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.nickName.text = userInformationModel.nickName;
  
    self.detailTitleLabel.text = userInformationModel.memo;
    
    if ([_userInformationModel.flag isEqual:@0]) {
        
        self.addButton.hidden = NO;
        
    } else {
        
        self.addButton.hidden = YES;
    }
}

- (IBAction)addUserAction:(id)sender {
    
    if (self.addUserBlock) {
        
        self.addUserBlock(_userInformationModel);
        
    }
}

@end
