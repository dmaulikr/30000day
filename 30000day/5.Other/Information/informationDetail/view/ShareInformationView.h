//
//  ShareInformationView.h
//  30000day
//
//  Created by wei on 16/4/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareInformationView : UIView

@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (nonatomic , copy) void (^(shareButtonBlock))(NSInteger ,ShareInformationView *);

//类方法，动画般的把ShareAnimatonView从父视图上移除
+ (void)annimateRemoveFromSuperView:(ShareInformationView *)animationview;

//类方法，动画般的把ShareAnimatonView从加载到UIWindow上
+ (void)animateWindowsAddSubView:(ShareInformationView *)animationview;

@end
