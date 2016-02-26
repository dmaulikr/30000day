//
//  STTabBarViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STTabBarViewController.h"

@interface STTabBarViewController ()

@end

@implementation STTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *controllerArray = self.viewControllers;
    
    for (int i = 0; i < controllerArray.count; i++) {
        
        UIViewController *controller = controllerArray[i];
        
        if (i == 0) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectHomePage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        } else if (i == 1) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectInformation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        } else if (i == 2) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectMall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        } else if (i == 3) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectMy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        
    }
    
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
