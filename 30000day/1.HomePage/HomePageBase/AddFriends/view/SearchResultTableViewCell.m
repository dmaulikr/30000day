//
//  SearchResultTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (void)awakeFromNib {
   
    self.headImageView.layer.cornerRadius = 4;
    
    self.headImageView.layer.masksToBounds = YES;
    
    self.addButton.layer.cornerRadius = 3;
    
    self.addButton.layer.masksToBounds = YES;
    
    self.addButton.layer.borderColor = RGBACOLOR(75, 136, 247, 1).CGColor;
    
    self.addButton.layer.borderWidth = 0.5f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFriendsInfo:(FriendListInfo *)friendsInfo {
    
    _friendsInfo = friendsInfo;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_friendsInfo.HeadImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.nickName.text = _friendsInfo.Nickname;
    
}

@end
