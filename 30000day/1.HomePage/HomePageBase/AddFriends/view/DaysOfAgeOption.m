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

    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];

}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [DaysOfAgeOption annimateRemoveFromSuperView:self];

}


+ (void)annimateRemoveFromSuperView:(DaysOfAgeOption *)animationview {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        //animationview.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_WIDTH * 50/75);
        
    } completion:^(BOOL finished) {
        
        [animationview removeFromSuperview];
        
    }];
    
}

+ (void)animateWindowsAddSubView:(DaysOfAgeOption *)animationview {
    
    [animationview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    //animationview.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_WIDTH * 50/75);
    
    [[[UIApplication sharedApplication].delegate window] addSubview:animationview];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        //animationview.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_WIDTH * 50/75, SCREEN_WIDTH, SCREEN_WIDTH * 50/75);
        
    } completion:nil];
    
}


@end
