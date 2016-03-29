//
//  ShopDetailHeadTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailHeadTableViewCell.h"

@implementation ShopDetailHeadTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopDetailModel:(ShopDetailModel *)shopDetailModel {

    _shopDetailModel = shopDetailModel;

    self.storeLable.text = shopDetailModel.productName;
    self.positionLable.text = shopDetailModel.productKeyword;
    self.businessHoursLable.text = shopDetailModel.businessTime;
    
}

@end
