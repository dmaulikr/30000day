//
//  MyOrderViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MyOrderViewController.h"
#import "Win5SwitchTitleView.h"
#import "OrderViewController.h"

@interface MyOrderViewController () <Win5SwitchTitleViewDelegate>

@property (weak, nonatomic) IBOutlet Win5SwitchTitleView *switchTitle;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //1.第一个
    OrderViewController *firstController = [[OrderViewController alloc] init];
    firstController.title = @"全部";
    firstController.view.backgroundColor = [UIColor redColor];
    firstController.type = OrderTypeAll;
    [self addChildViewController:firstController];//如果想要push效果 需加上
    
    //2.第二个
    OrderViewController *secondController = [[OrderViewController alloc] init];
    secondController.title = @"已付款";
    secondController.view.backgroundColor = [UIColor yellowColor];
    secondController.type = OrderTypepaid;
    [self addChildViewController:secondController];//如果想要push效果 需加上
    
    //3.第三个
    OrderViewController *thirdController = [[OrderViewController alloc] init];
    thirdController.title = @"未付款";
    thirdController.type = OrderTypeWillPay;
    thirdController.view.backgroundColor = [UIColor purpleColor];
    [self addChildViewController:thirdController];//如果想要push效果 需加上
    
    self.switchTitle.titleBarHeight = 44;
    
    self.switchTitle.titleBarColor = [UIColor whiteColor];
    
    self.switchTitle.btnNormalColor = [UIColor lightGrayColor];
    
    self.switchTitle.btnSelectedColor = [UIColor darkGrayColor];
    
    self.switchTitle.btnSelectedBgImage = [UIImage imageNamed:@"tiao"];
    
    self.switchTitle.titleViewDelegate = self;
    
    [self.switchTitle reloadData];//要放在最下面调用
}

#pragma ---
#pragma mark ---- Win5SwitchTitleViewDelegate

- (NSUInteger)numberOfTitleBtn:(Win5SwitchTitleView *)View {
    
    return 3;
}

- (UIViewController *)titleView:(Win5SwitchTitleView *)View viewControllerSetWithTilteIndex:(NSUInteger)index {
    
    if (index == 0) {
        
        OrderViewController *controller = [self.childViewControllers firstObject];
        
        return controller;
        
    } else if (index == 1) {
        
        OrderViewController *controller = self.childViewControllers[1];
        
        return controller;
        
    } else if (index == 2) {
        
        OrderViewController *controller = [self.childViewControllers lastObject];
        
        return controller;
    }
    
    return nil;
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
