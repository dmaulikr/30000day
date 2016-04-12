//
//  PaySuccessViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "CommodityCommentViewController.h"
#import "AppointmentViewController.h"
#import "MyOrderViewController.h"

@interface PaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fourthButton;//退款按钮

@property (weak, nonatomic) IBOutlet UIButton *firstButton;//评价按钮
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

@property (weak, nonatomic) IBOutlet UIView *backgoudView;//背景view

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付成功";
    
    self.backgoudView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.backgoudView.layer.borderWidth = 0.5f;
    
    self.firstButton.layer.cornerRadius = 5;
    self.firstButton.layer.masksToBounds = YES;
    self.firstButton.layer.borderWidth = 0.5f;
    self.firstButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.secondButton.layer.cornerRadius = 5;
    self.secondButton.layer.masksToBounds = YES;
    self.secondButton.layer.borderWidth = 0.5f;
    self.secondButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.thirdButton.layer.cornerRadius = 5;
    self.thirdButton.layer.masksToBounds = YES;
    self.thirdButton.layer.borderWidth = 0.5f;
    self.thirdButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.fourthButton.layer.cornerRadius = 5;
    self.fourthButton.layer.masksToBounds = YES;
    self.fourthButton.layer.borderWidth = 0.5f;
    self.fourthButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    [self.firstButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [self.secondButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [self.thirdButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [self.fourthButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    self.fourthButton.enabled = NO;
}

#pragma ---
#pragma mark -- 按钮点击效果
- (IBAction)buttonAction:(id)sender {//跳转到评价接口
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {//评价
        
        CommodityCommentViewController *controller = [[CommodityCommentViewController alloc] init];
        
        controller.orderNumber = controller.orderNumber;
        
        controller.productName = self.productName;
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (button.tag == 2) {//继续预定
        
        BOOL isExist = NO;
        
        for (UIViewController *controller in self.navigationController.childViewControllers) {
            
            if ([controller isKindOfClass:[AppointmentViewController class]]) {
                
                isExist = YES;
                
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
        
        if (!isExist) {
            
            AppointmentViewController *controller = [[AppointmentViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            controller.productName = self.productName;
            
            controller.productId = self.productId;
            
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    } else if (button.tag == 3) {//查看订单
        
        MyOrderViewController *controller = [[MyOrderViewController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        
    } else if (button.tag == 4) {//退款操作
        
        
        
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
