//
//  UserHeadViewTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "UserHeadViewTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation UserHeadViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInfo:(UserInfo *)userInfo {
    
    _userInfo = userInfo;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_userInfo.HeadImg]];
    
    self.nameLabel.text =  _userInfo.NickName;
    
    self.phoneNumberLabel.text = _userInfo.PhoneNumber;
    
}

@end
