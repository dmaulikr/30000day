//
//  MTProgressHUD.m
//  17dong_ios
//
//  Created by win5 on 7/22/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import "MTProgressHUD.h"

/**************注意self.navegationController里面的view.tag别和这里重复,否则会混乱****************/
#define  MTProgressHUDTag        (1314)
#define  MTProgressActivityTag   (1315)
#define  MTProgressHUDBackRoundViewTag (1316)

@interface MTProgressHUD ()

@property(nonatomic,assign)BOOL isHiding;

@end

@implementation MTProgressHUD

- (id)init {
    if (self = [super init]) {
        self.isHiding = NO;
        self.bounds = CGRectMake(0, 0,37,37);
        self.tag = MTProgressHUDTag;
        self.backgroundColor = [UIColor clearColor];
        [self creatIndicatorView];
    }
    return self;
}

- (void)creatIndicatorView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicator.hidesWhenStopped = YES;
    indicator.color = LOWBLUECOLOR;//指示器颜色可以自定义
    indicator.center = CGPointMake(37.0f/2.0f,37.0f/2.0f);
    indicator.tag = MTProgressActivityTag;
    [self addSubview:indicator];
    [indicator startAnimating];
}

#pragma mark --- 实现方法
+ (void)showHUD:(UIView *)view {
    UIView *lastHud = [view viewWithTag:MTProgressHUDTag];
    UIView *lastBackRoundView = (UIView *)[view viewWithTag:MTProgressHUDBackRoundViewTag];
    if (lastHud) {
        
        [lastHud removeFromSuperview];
        lastHud = nil;
        
    }if (lastBackRoundView) {
        
        [lastBackRoundView removeFromSuperview];
        lastBackRoundView  = nil;
        
    }
    
    MTProgressHUD *hud = [[MTProgressHUD alloc] init];
    hud.center = view.center;
    [view addSubview:hud];
    
/**************在MTProgressHUD上面建立一个模态窗口，增强界面操作的流程性****************/
    UIView *backRoundView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    backRoundView.tag = MTProgressHUDBackRoundViewTag;
    [view addSubview:backRoundView];
    [view bringSubviewToFront:backRoundView];
}

+ (void)hideHUD:(UIView *)view {
    MTProgressHUD *hud = (MTProgressHUD *)[view viewWithTag:MTProgressHUDTag];
    
    UIView *backRoundView = (UIView *)[view viewWithTag:MTProgressHUDBackRoundViewTag];
    
    if (backRoundView) {
        
        [backRoundView removeFromSuperview];
         backRoundView = nil;
    }
    
/**************保证每次动画结束的时候才进行下次的hide****************/
    if (hud && hud.isHiding == NO ) {
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[hud viewWithTag:MTProgressActivityTag];
        hud.isHiding = YES;
        [UIView animateWithDuration:0.6 animations:^{
            hud.alpha = 0;
        } completion:^(BOOL finished) {
            [hud removeFromSuperview];
            hud.isHiding = NO;
            if (indicator) {
                [indicator stopAnimating];
                [indicator removeFromSuperview];
            }
        }];
    }
}

@end
