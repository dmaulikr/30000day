//
//  PaySuccessViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "CommodityCommentViewController.h"

@interface PaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *returnMoneyButton;//退款按钮

@property (weak, nonatomic) IBOutlet UIButton *judgeButton;//评价按钮

@property (weak, nonatomic) IBOutlet UIView *backgoudView;//背景view

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付成功";
    
    self.backgoudView.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    self.backgoudView.layer.borderWidth = 0.5f;
    
    self.judgeButton.layer.cornerRadius = 5;
    self.judgeButton.layer.masksToBounds = YES;
    
    self.judgeButton.layer.borderWidth = 0.5f;
    self.judgeButton.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.returnMoneyButton.layer.cornerRadius = 5;
    self.returnMoneyButton.layer.masksToBounds = YES;
    
    [self.returnMoneyButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [self.judgeButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
}

#pragma ---
#pragma mark -- 按钮点击效果
- (IBAction)judgeAction:(id)sender {//跳转到评价接口
    
    CommodityCommentViewController *controller = [[CommodityCommentViewController alloc] init];
    
    controller.orderNumber = controller.orderNumber;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)returnMoneyAction:(id)sender {//退款操作
    
    
    
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
