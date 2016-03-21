//
//  ShopListTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopListTableViewCell.h"

@implementation ShopListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopModel:(ShopModel *)shopModel {
    
    _shopModel = shopModel;
    
    self.titleLabel.text = _shopModel.productName;

}


@end
