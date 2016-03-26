//
//  ShopListTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ShopListTableViewCell

- (void)awakeFromNib {
    
    self.discountLabel.layer.cornerRadius = 2;
    
    self.discountLabel.layer.masksToBounds = YES;
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
}

- (NSMutableAttributedString *)attributeStringWithOriginalPrice:(NSNumber *)originalPrice currentPrice:(NSNumber *)currentPrice {
    
    NSString *originalPriceString = [NSString stringWithFormat:@"¥%.2f", [originalPrice floatValue]];
    
    NSString *currentPriceString = [NSString stringWithFormat:@"¥%.2f", [currentPrice floatValue]];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@", currentPriceString, originalPriceString]];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, currentPriceString.length)];
    
    [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f] range:NSMakeRange(0, originalPriceString.length)];
    
    return text;
}

@end
