//
//  DaysOfAgeOption.m
//  30000day
//
//  Created by wei on 16/5/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "DaysOfAgeOption.h"

@implementation DaysOfAgeOption

-(void)awakeFromNib {

    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0 ]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *perfectImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(perfectImageViewTapAction:)];
    
    [self.perfectImageView addGestureRecognizer:perfectImageViewTap];
    
    UITapGestureRecognizer *promoteImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promoteImageViewTapAction:)];
    
    [self.promoteImageView addGestureRecognizer:promoteImageViewTap];

}

- (void)perfectImageViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.shareButtonBlock) {
        
        self.shareButtonBlock(1,self);
        
    }
    
}

- (void)promoteImageViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.shareButtonBlock) {
        
        self.shareButtonBlock(2,self);
        
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self annimateRemoveFromSuperView];

}


- (void)annimateRemoveFromSuperView {
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.oneLeft.constant = -100;
        
        self.twoRight.constant = -100;
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

- (void)animateWindowsAddSubView {
    
    CGFloat x = (SCREEN_WIDTH - 200) / 3;
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
  
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.oneLeft.constant = x;
        
        self.twoRight.constant = x;
        
        [self layoutIfNeeded];
        
    } completion:nil];
    
}


@end
