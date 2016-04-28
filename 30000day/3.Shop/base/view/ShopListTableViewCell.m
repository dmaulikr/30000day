//
//  ShopListTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopListTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface ShopListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backgroundLineView_first;
@property (weak, nonatomic) IBOutlet UIView *backgroundLineView_second;


@property (weak, nonatomic) IBOutlet UIImageView *activityImageView_first;
@property (weak, nonatomic) IBOutlet UILabel *activityDescLabel_first;

@property (weak, nonatomic) IBOutlet UIImageView *activityImageView_second;
@property (weak, nonatomic) IBOutlet UILabel *activityDescLabel_second;

@end


@implementation ShopListTableViewCell

- (void)awakeFromNib {
    
    self.activityImageView_first.layer.cornerRadius = 3;
    
    self.activityImageView_first.layer.masksToBounds = YES;
    
    self.activityImageView_second.layer.cornerRadius = 3;
    
    self.activityImageView_second.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShopModel:(ShopModel *)shopModel {
    
    _shopModel = shopModel;
    
    self.titleLabel.text = _shopModel.productName;
    
    [self.willShowImageView sd_setImageWithURL:[NSURL URLWithString:_shopModel.productPhoto]];
    
    [self.priceLabel setAttributedText:[self attributeStringWithOriginalPrice:_shopModel.originalPrice currentPrice:_shopModel.presentPrice]];
    
    if (!_shopModel.twoPointsDistance) {
        
        self.addressLabel.text = _shopModel.address;
        
    } else {
        
        self.addressLabel.text = [NSString stringWithFormat:@"%.2fkm  %@",[_shopModel.twoPointsDistance doubleValue],_shopModel.address];
    }
    
    self.rateView.rate = [_shopModel.avgNumberStar doubleValue] > 5.0 ? 5.0 : [_shopModel.avgNumberStar doubleValue];
    
    //两种活动都有
    if (_shopModel.activityList.count == 2) {//两种都有
        
        self.backgroundLineView_first.hidden = NO;
        
        self.backgroundLineView_second.hidden = NO;
        
        self.activityDescLabel_first.hidden = NO;
        
        self.activityImageView_first.hidden = NO;
        
        self.activityDescLabel_second.hidden = NO;
        
        self.activityImageView_second.hidden = NO;
        
        ActivityModel *model_first = [_shopModel.activityList firstObject];
        
        ActivityModel *model_second = [_shopModel.activityList lastObject];
        
        self.activityImageView_first.image = [UIImage imageNamed:@"detail_cell_hui"];

        self.activityImageView_second.image = [UIImage imageNamed:@"detail_cell_quan"];
        
        if ([model_first.activityType isEqualToString:@"01"]) {//满减
    
            self.activityDescLabel_first.text = model_first.activityDesc;
    
            self.activityDescLabel_second.text = model_second.activityDesc;
    
        } else if ([model_first.activityType isEqualToString:@"02"]) {//优惠券
            
            self.activityDescLabel_first.text = model_second.activityDesc;
            
            self.activityDescLabel_second.text = model_first.activityDesc;
        }
        
    } else if (_shopModel.activityList.count == 1) {//只有一种
        
        self.backgroundLineView_first.hidden = NO;
        
        self.backgroundLineView_second.hidden = YES;
        
        self.activityDescLabel_first.hidden = NO;
        
        self.activityImageView_first.hidden = NO;
        
        self.activityDescLabel_second.hidden = YES;
        
        self.activityImageView_second.hidden = YES;
        
        ActivityModel *model = [_shopModel.activityList firstObject];
        
        if ([model.activityType isEqualToString:@"01"]) {//满减
            
            self.activityImageView_first.image = [UIImage imageNamed:@"detail_cell_hui"];
            
            self.activityDescLabel_first.text = model.activityDesc;
            
        } else if ([model.activityType isEqualToString:@"02"]) {//优惠券
         
            self.activityImageView_first.image = [UIImage imageNamed:@"detail_cell_quan"];
            
            self.activityDescLabel_first.text = model.activityDesc;
        }
        
    } else  {//目前默认是没活动，以后会扩展
        
        self.backgroundLineView_first.hidden = YES;
        
        self.backgroundLineView_second.hidden = YES;
        
        self.activityDescLabel_first.hidden = YES;
        
        self.activityImageView_first.hidden = YES;
        
        self.activityDescLabel_second.hidden = YES;
        
        self.activityImageView_second.hidden = YES;
    }
}

- (NSMutableAttributedString *)attributeStringWithOriginalPrice:(NSNumber *)originalPrice currentPrice:(NSNumber *)currentPrice {
    
    NSString *originalPriceString = [NSString stringWithFormat:@"¥%.2f", [originalPrice floatValue]];
    
    NSString *currentPriceString = [NSString stringWithFormat:@"¥%.2f", [currentPrice floatValue]];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@", currentPriceString, originalPriceString]];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, currentPriceString.length)];
    
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f] range:NSMakeRange(0, originalPriceString.length)];
    
    return text;
}

+ (CGFloat)heightWithShopModel:(ShopModel *)shopModel {
    
    if (shopModel.activityList.count == 2) {//两种都有
        
        return 147.0f;
    } else if (shopModel.activityList.count == 1) {//一种
        
        return 116.0f;
        
    } else {//暂定是没有，以后会扩展
        
        return 86.0f;
    }
}

@end
