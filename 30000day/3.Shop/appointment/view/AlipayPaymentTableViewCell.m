//
//  AlipayPaymentTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AlipayPaymentTableViewCell.h"

@implementation AlipayPaymentTableViewCell

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
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:208.0/255.0 green:208.0/255.0  blue:208.0/255.0  alpha:208.0/255.0 ].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, -1, rect.size.width - 0, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:208.0/255.0 green:208.0/255.0  blue:208.0/255.0  alpha:208.0/255.0 ].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, 0, 0));
}

@end
