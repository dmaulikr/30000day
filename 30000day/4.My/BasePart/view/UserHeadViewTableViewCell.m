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
    
    self.headImageView.layer.cornerRadius = 3;
    
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserProfile:(UserProfile *)userProfile {
    
    _userProfile = userProfile;
    
    self.nameLabel.text =  _userProfile.nickName;
    
    self.phoneNumberLabel.text = _userProfile.userName;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_userProfile.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        [self.activityView startAnimating];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [self.activityView stopAnimating];
    }];
}

@end
