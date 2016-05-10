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
    
    [DaysOfAgeOption annimateRemoveFromSuperView:self];

}


+ (void)annimateRemoveFromSuperView:(DaysOfAgeOption *)animationview {
 
    animationview.perfectImageView.frame = CGRectMake(SCREEN_WIDTH / 2 - 120, SCREEN_HEIGHT - 250, 100, 100);
    
    animationview.promoteImageView.frame = CGRectMake(SCREEN_WIDTH / 2 + 70, SCREEN_HEIGHT - 250, 100, 100);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        animationview.perfectImageView.frame = CGRectMake(-100, SCREEN_HEIGHT - 250, 100, 100);
        
        animationview.promoteImageView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 250, 100, 100);
        
    } completion:^(BOOL finished) {
        
        [animationview removeFromSuperview];
        
    }];
    
}

+ (void)animateWindowsAddSubView:(DaysOfAgeOption *)animationview {
    
    [animationview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    animationview.perfectImageView.frame = CGRectMake(0, SCREEN_HEIGHT - 250, 100, 100);
    
    animationview.promoteImageView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 250, 100, 100);
    
    [[[UIApplication sharedApplication].delegate window] addSubview:animationview];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        animationview.perfectImageView.frame = CGRectMake(SCREEN_WIDTH / 2 - 120, SCREEN_HEIGHT - 250, 100, 100);
        
        animationview.promoteImageView.frame = CGRectMake(SCREEN_WIDTH / 2 + 70, SCREEN_HEIGHT - 250, 100, 100);
        
    } completion:nil];
    
}


@end
