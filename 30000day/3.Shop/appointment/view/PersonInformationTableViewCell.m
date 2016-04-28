//
//  PersonInformationTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonInformationTableViewCell.h"
#import "MyOrderDetailModel.h"

@implementation PersonInformationTableViewCell

- (void)awakeFromNib {
    
    [self.remarkTextView setPlaceholder:@"备注"];
    
    self.remarkTextView.backgroundColor = [UIColor whiteColor];
    
    self.remarkTextView.layer.cornerRadius = 5;
    
    self.remarkTextView.layer.masksToBounds = YES;
    
    self.remarkTextView.layer.borderColor = RGBACOLOR(200,200 , 200, 1).CGColor;
    
    self.remarkTextView.layer.borderWidth = 1.0f;
}

+ (NSMutableAttributedString *)priceAttributeString:(float)price {
    
    NSString *priceString = [NSString stringWithFormat:@"%.2f",price];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",priceString]];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
    
    return string;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
