//
//  SelectFriendTableViewCell.m
//  30000day
//
//  Created by WeiGe on 16/8/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SelectFriendTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SelectFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setInformationModel:(UserInformationModel *)informationModel {
    
    _informationModel = informationModel;
    
    //头像
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[informationModel showHeadImageUrlString]] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //昵称
    self.nameLable.text = [informationModel showNickName];

    
}

- (void)setIsSelect:(BOOL)isSelect {

    _isSelect = isSelect;
    
    if (isSelect) {
    
        [self.selectImage setImage:[UIImage imageNamed:@"oneSelect"]];
        
    } else {
    
        [self.selectImage setImage:[UIImage imageNamed:@"oneNoSelect"]];
        
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
