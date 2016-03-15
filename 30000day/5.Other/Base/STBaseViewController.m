//
//  STBaseViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STBaseViewController.h"
#import "LONetworkAgent.h"

@interface STBaseViewController ()
//{
//    
//    UIImageView *navBarHairlineImageView;
//    
//}

@end

@implementation STBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定制网络请求
    self.requestRecord = [[NSMutableArray alloc] init];
    
    self.dataHandler = [[LODataHandler alloc] init];
    
    self.dataHandler.delegate = self;
    
//    //IOS8吧导航栏设置透明的话会有一条黑线，，这个方法就是隐藏的
//    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
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


#pragma mark -
#pragma mark handleHTTPError

- (BOOL)handleLONetError:(LONetError *)error {
    
    if (error.lostConnection) {
        
        [self showToast:@"网络连接失败"];
        
        return YES;
    }
    
    switch (error.statusCode) {
        case 401:
        {
            [self showToast:@"登录信息失效，请重新登录"];
            
            return YES;
        }
            break;
            
        case 410:
        {
            [self showToast:@"请求失败，软件版本过旧"];
            
            return YES;
        }
            break;
            
        case 503:
        {
            [self showToast:@"服务器正在维护"];
            
            return YES;
        }
            break;
            
        default:
            
            break;
    }
    
    if (error.statusCode >= 500) {
        
        [self showToast:@"服务器开小差了"];
        
        return YES;
    }
    
    return NO;
}

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
    
    [[LONetworkAgent sharedAgent] cancelRequestsWithHashArray:_requestRecord];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
