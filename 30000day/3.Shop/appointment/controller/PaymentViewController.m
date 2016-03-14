//
//  PaymentViewController.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PaymentViewController.h"
#import "CommodityNameTableViewCell.h"
#import "OrderContentTableViewCell.h"
#import "PaymentAmountTableViewCell.h"
#import "AlipayPaymentTableViewCell.h"
#import "WeChatPaymentTableViewCell.h"


@interface PaymentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *orderContentArray;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单支付";
    
    self.orderContentArray = [NSArray arrayWithObjects:@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元", nil];
    
    [self.tableView setTableFooterView:[self tableViewFooterView]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4 + self.orderContentArray.count;
    }
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 44;
        } else if (indexPath.row == self.orderContentArray.count + 3){
            return 44;
        } else {
            return 24;
        }
        
    } else {
        return 68;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            CommodityNameTableViewCell *commodityNameTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommodityNameTableViewCell"];
            
            if (commodityNameTableViewCell == nil) {
                
                commodityNameTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommodityNameTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            return commodityNameTableViewCell;

            
        } else if(indexPath.row + 1 == self.orderContentArray.count + 4) {
        
            PaymentAmountTableViewCell *paymentAmountTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"PaymentAmountTableViewCell"];
            
            if (paymentAmountTableViewCell == nil) {
                
                paymentAmountTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"PaymentAmountTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            return paymentAmountTableViewCell;
            
        } else {
        
            OrderContentTableViewCell *orderContentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"OrderContentTableViewCell"];
            
            if (orderContentTableViewCell == nil) {
                
                orderContentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"OrderContentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
                if (indexPath.row == 1) {
                    
                    return orderContentTableViewCell;
                    
                } else if(indexPath.row >= 2 && self.orderContentArray. count + 2  - indexPath.row > 0){
                    
                    if(indexPath.row == 2){
                        
                        orderContentTableViewCell.titleLable.text = @"场次";
                        
                    } else {
                        
                        orderContentTableViewCell.titleLable.hidden = YES;
                    }
        
                    orderContentTableViewCell.dataLable.text = self.orderContentArray[indexPath.row - 2];

                    return orderContentTableViewCell;
                    
                } else {
                
                    orderContentTableViewCell.titleLable.hidden = NO;
                    orderContentTableViewCell.titleLable.text = @"总计";
                    orderContentTableViewCell.dataLable.text = @"135.00元";
                    
                    return orderContentTableViewCell;
                }

        
        }
        
    } else {
    
        if (indexPath.row == 0) {
            
            AlipayPaymentTableViewCell *alipayPaymentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AlipayPaymentTableViewCell"];
            
            if (alipayPaymentTableViewCell == nil) {
                
                alipayPaymentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AlipayPaymentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            return alipayPaymentTableViewCell;
            
        } else {
        
            WeChatPaymentTableViewCell *weChatPaymentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"WeChatPaymentTableViewCell"];
            
            if (weChatPaymentTableViewCell == nil) {
                
                weChatPaymentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"WeChatPaymentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            return weChatPaymentTableViewCell;
        
        }
        
    }
    
    
    return nil;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableViewFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    [footerView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
    
    UILabel *footerLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, 10)];
    [footerLable setFont:[UIFont systemFontOfSize:14.0]];
    [footerLable setTextColor:[UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0]];
    [footerLable setText:@"请在10分钟之内完成付款否则场地不予保留！"];
    [footerView addSubview:footerLable];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setBackgroundColor:[UIColor colorWithRed:73.0/255.0 green:117.0/255.0 blue:188.0/255.0 alpha:1.0]];
    [confirmButton setFrame:CGRectMake(15, 50, [UIScreen mainScreen].bounds.size.width - 30, 44)];
    confirmButton.layer.cornerRadius = 6;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchDown];
    
    [footerView addSubview:confirmButton];
    
    return footerView;
}

- (void)confirmButtonClick {

    NSLog(@"1");
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
