//
//  PaymentViewController.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PaymentViewController.h"
#import "CommodityNameTableViewCell.h"
#import "PayTableViewCell.h"
#import "PersonInformationTableViewCell.h"
#import "ShopDetailViewController.h"

@interface PaymentViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单支付";
}

//父类的方法
- (void)backClick {
    
    for (UIViewController *controller in self.navigationController.childViewControllers) {
        
        if ([controller isKindOfClass:[ShopDetailViewController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
        
        return 4 + self.timeModelArray.count;
    }
    
    return 1.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.5f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        PersonInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInformationTableViewCell"];
        
        if (indexPath.row == 0) {
            
            CommodityNameTableViewCell *commodityNameTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommodityNameTableViewCell"];
            
            if (commodityNameTableViewCell == nil) {
                
                commodityNameTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommodityNameTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            commodityNameTableViewCell.commodityNameLable.text = self.productName;
            
            return commodityNameTableViewCell;
            
        } else if  (indexPath.row == 1) {
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][2];
            }
            cell.firstTitleLabel.text = @"日期";
            
            cell.firstTitleLabel.hidden = NO;
            
            cell.contentLabel.text = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:self.selectorDate];
            
        } else if (indexPath.row == 2) {
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][2];
            }
            
            AppointmentTimeModel *timeModel = self.timeModelArray[0];
            
            cell.firstTitleLabel.text = @"场次";
            
            cell.firstTitleLabel.hidden = NO;
            
            [cell configOrderWithAppointmentTimeModel:timeModel];
            
        } else if  (indexPath.row == 2 + self.timeModelArray.count) {//总计
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][3];
            }
            
            cell.titleLabel.text = @"总计";
            
            //配置总价格
            [cell configTotalPriceWith:self.timeModelArray];
            
        } else if  (indexPath.row == 3 + self.timeModelArray.count) {//总额
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][3];
            }
            
            cell.titleLabel.text = @"支付总额";
            
            //配置总价格
            [cell configTotalPriceWith:self.timeModelArray];
            
        } else {
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][2];
            }
            
            AppointmentTimeModel *timeModel = self.timeModelArray[indexPath.row - 2];
            
            cell.firstTitleLabel.hidden = YES;
            
            [cell configOrderWithAppointmentTimeModel:timeModel];
        }
        
        return cell;
        
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
