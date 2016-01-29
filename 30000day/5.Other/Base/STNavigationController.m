
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
    
    self.navigationBar.shadowImage = [[UIImage alloc]init];
    
    [self navigationBar].layer.shadowColor = [UIColor blackColor].CGColor; //shadowColor阴影颜色
    
    [self navigationBar].layer.shadowOffset = CGSizeMake(2.0f , 2.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
    
    [self  navigationBar].layer.shadowOpacity = 0.25f;//阴影透明度，默认0
    
    [self  navigationBar].layer.shadowRadius = 4.0f;//阴影半径
    
    [self backBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航栏返回按钮封装
- (void)backBarButtonItem {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor colorWithRed:69.0/255.0 green:69.0/255.0 blue:69.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [button setFrame:CGRectMake(0, 0, 60, 30)];
    
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0?20:0)){
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -10;
        
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButton];
        
    } else {
        
        self.navigationItem.leftBarButtonItem = leftButton;
        
    }
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
}


- (void)backClick {
    
    if (self.clickBlock) {
        
        self.clickBlock();
        
    }
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
