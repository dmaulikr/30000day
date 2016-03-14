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
#import "PayTableViewCell.h"

@interface PaymentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *orderContentArray;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单支付";
    
    self.orderContentArray = [NSArray arrayWithObjects:@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元",@"15:00-16:00 2号场 35.00元", nil];
    
//    [self.tableView setTableFooterView:[self tableViewFooterView]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4 + self.orderContentArray.count;
    }
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return 44;
        } else if (indexPath.row == self.orderContentArray.count + 3){
            return 44;
        } else {
            return 30;
        }
        
    } else {
        return 44;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5f;
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
    
        PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.section == 1) {
            
            cell.titleLabel.text = @"微信支付";
            
            cell.backgroundColor = RGBACOLOR(71, 182, 0, 1);
            
        } else if (indexPath.section == 2) {
        
          cell.titleLabel.text = @"支付宝支付";
            
          cell.backgroundColor = RGBACOLOR(0, 169, 244, 1);
            
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
