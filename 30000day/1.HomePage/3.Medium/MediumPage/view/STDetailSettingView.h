//
//  STDetailSettingView.h
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STDetailSettingView : UIView

@property (weak, nonatomic) IBOutlet UIButton *WeChatFriendsBtn;
@property (weak, nonatomic) IBOutlet UIButton *WeChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *QQspaceBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (nonatomic , copy) void (^(shareButtonBlock))(NSInteger ,STDetailSettingView *);

//类方法，动画般的把ShareAnimatonView从父视图上移除
+ (void)annimateRemoveFromSuperView:(STDetailSettingView *)animationview completion:(void (^)(BOOL finished))completion;
//类方法，动画般的把ShareAnimatonView从加载到UIWindow上
+ (void)animateWindowsAddSubView:(STDetailSettingView *)animationview;

@end
