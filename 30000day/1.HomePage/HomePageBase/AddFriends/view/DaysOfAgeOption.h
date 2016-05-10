//
//  DaysOfAgeOption.h
//  30000day
//
//  Created by wei on 16/5/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysOfAgeOption : UIView

@property (weak, nonatomic) IBOutlet UIImageView *perfectImageView;

@property (weak, nonatomic) IBOutlet UIImageView *promoteImageView;

@property (nonatomic , copy) void (^(shareButtonBlock))(NSInteger ,DaysOfAgeOption *);

//类方法，动画般的把ShareAnimatonView从父视图上移除
+ (void)annimateRemoveFromSuperView:(DaysOfAgeOption *)animationview;

//类方法，动画般的把ShareAnimatonView从加载到UIWindow上
+ (void)animateWindowsAddSubView:(DaysOfAgeOption *)animationview;

@end
