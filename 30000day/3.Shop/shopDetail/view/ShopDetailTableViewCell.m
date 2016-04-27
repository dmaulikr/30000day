//
//  ShopDetailHeadTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailTableViewCell.h"

@implementation ShopDetailTableViewCell

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

- (void)setActivityModel:(ActivityModel *)activityModel {
    
    _activityModel = activityModel;
    
    if ([activityModel.activityType isEqualToString:@"01"]) {//优惠
        
        self.imageView_third.image = [UIImage imageNamed:@"detail_cell_hui"];
        
        self.label_third.text = activityModel.activityDesc;
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
    } else if ([activityModel.activityType isEqualToString:@"02"]) {//券
        
        self.imageView_third.image = [UIImage imageNamed:@"detail_cell_quan"];
        
        self.label_third.text = activityModel.activityDesc;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

@end
