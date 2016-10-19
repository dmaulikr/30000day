//
//  FactorVerificationView.m
//  30000day
//
//  Created by wei on 16/5/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "FactorVerificationView.h"

@implementation FactorVerificationView 

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}

- (IBAction)enterClick:(UIButton *)sender {
    
    if (self.buttonBlock) {
        self.buttonBlock(sender);
    }
}


@end
