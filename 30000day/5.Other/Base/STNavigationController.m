
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
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bs.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    
    [self navigationBar].layer.shadowColor = [UIColor blackColor].CGColor; //shadowColor阴影颜色
    
    [self navigationBar].layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
    
    [self  navigationBar].layer.shadowOpacity = 0.25f;//阴影透明度，默认0
    
    [self  navigationBar].layer.shadowRadius = 4.0f;//阴影半径
    
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
