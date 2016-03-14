//
//  CommodityNameTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommodityNameTableViewCell.h"

@implementation CommodityNameTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:208.0/255.0 green:208.0/255.0  blue:208.0/255.0  alpha:208.0/255.0 ].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width - 0, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:208.0/255.0 green:208.0/255.0  blue:208.0/255.0  alpha:208.0/255.0 ].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width - 0, 1));
}


@end
