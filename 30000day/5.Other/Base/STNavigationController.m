
//
//  STNavigationController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STNavigationController.h"

@interface STNavigationController () 

@end

@implementation STNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor :[UIColor whiteColor]];
}

//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]; // UITextAttributeTextColor

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    [super pushViewController:viewController animated:animated];
//}
//
//- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    
//    [self popViewControllerSendNotification];
//    
//   return [super popViewControllerAnimated:animated];
//}
//
//- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    
//    [self popViewControllerSendNotification];
//    
//    return [super popToViewController:viewController animated:animated];
//}
//
//- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
//    
//    [self popViewControllerSendNotification];
//    
//    return [super popToRootViewControllerAnimated:animated];
//}
//
//- (void)popViewControllerSendNotification {
//    
//    [STNotificationCenter postNotificationName:STWillPopViewControllerSendNotification object:nil];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
