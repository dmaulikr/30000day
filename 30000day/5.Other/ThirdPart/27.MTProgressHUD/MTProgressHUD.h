//
//  MTProgressHUD.h
//  17dong_ios
//
//  Created by win5 on 7/22/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTProgressHUD : UIView

+ (void)showHUD:(UIView *)view;
+ (void)hideHUD:(UIView *)view;

@end


/**************使用方法****************/
/** 
 
    1.
    [MTPMTProgressHUD showHUD:self.navigateionController.view];
    .
    .
    .
    .
    .
    [MTPMTProgressHUD hideHUD:self.navigateionController.view];
 
    2.最好在 -(void)viewWillDisapper;里面调用下【+ (void)hideHUD:(UIView *)view】防止因突发情况造成卡顿

*/