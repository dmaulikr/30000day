//
//  ShareAnimatonView.h
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareAnimatonView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (nonatomic , copy) void (^(shareButtonBlock))(NSInteger ,ShareAnimatonView *);

//类方法，动画般的把ShareAnimatonView从父视图上移除
+ (void)annimateRemoveFromSuperView:(ShareAnimatonView *)animationview;

//类方法，动画般的把ShareAnimatonView从加载到UIWindow上
+ (void)animateWindowsAddSubView:(ShareAnimatonView *)animationview;

@end
