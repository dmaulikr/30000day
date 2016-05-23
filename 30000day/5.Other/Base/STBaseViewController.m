//
//  STBaseViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STBaseViewController.h"
#import "STNetworkAgent.h"
#import "JZNavigationExtension.h"

@interface STBaseViewController () <UIGestureRecognizerDelegate>
//{
//    
//    UIImageView *navBarHairlineImageView;
//    
//}

@end

@implementation STBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataHandler = [STDataHandler sharedHandler];
    
//    //IOS8吧导航栏设置透明的话会有一条黑线，，这个方法就是隐藏的
//    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    //定制返回按钮
    [self backBarButtonItem];
    
    self.navigationController.jz_fullScreenInteractivePopGestureEnabled = YES;
}

#pragma mark - 导航栏返回按钮封装
- (void)backBarButtonItem {
    
    UIImage *image = [UIImage imageNamed:@"back.png"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    
    [item setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.backBarButtonItem = item;
    
    self.navigationItem.backBarButtonItem.title = @"";
}

//- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
//    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
//        return (UIImageView *)view;
//    }
//    for (UIView *subview in view.subviews) {
//        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
//        if (imageView) {
//            return imageView;
//        }
//    }
//    return nil;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    navBarHairlineImageView.hidden = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsCompact];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    navBarHairlineImageView.hidden = NO;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
//}

- (void)ShowAlert:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil message:message delegate:nil
                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark MBProgressHUD

- (void)showToast:(NSString *)content {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    
//  hud.yOffset = SCREEN_HEIGHT / 2 - 100;
    
    hud.labelText = content;
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:0.8];
}

- (void)showToast:(NSString *)content complition:(MBProgressHUDCompletionBlock)complitionBlock {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    
    hud.yOffset = SCREEN_HEIGHT / 2 - 100;
    
    hud.labelText = content;
    
    hud.removeFromSuperViewOnHide = YES;
    
    hud.completionBlock = complitionBlock;
    
    [hud hide:YES afterDelay:0.5];
}

- (void)showHUD:(BOOL)animated {
    
    [self showHUDWithContent:nil animated:animated];
}

- (void)showHUDWithContent:(NSString *)content animated:(BOOL)animated{
    
    self.HUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window]];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self.HUD];
    
    self.HUD.labelText = content;
    
    self.HUD.removeFromSuperViewOnHide = YES;
    
    [self.HUD show:animated];
}

- (void)hideHUD:(BOOL)animated {
    
    [self.HUD hide:animated];
}

- (void)dealloc {
    
    self.dataHandler = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"内存警告");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
