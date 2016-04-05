//
//  AppointmentConfirmViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentConfirmViewController.h"
#import "PersonInformationTableViewCell.h"
#import "PaymentViewController.h"

@interface AppointmentConfirmViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AppointmentConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
        
    [Common addAppointmentBackgroundView:self.view title:@"提交订单并支付" selector:@selector(rightButtonAction) controller:self];
}

- (void)rightButtonAction {
    
    PaymentViewController *controller = [[PaymentViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark -- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        
        return self.timeModelArray.count + 1;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonInformationTableViewCell"];
    
    if (indexPath.section == 0) {
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil] firstObject];
            
            cell.contactTextField.text = STUserAccountHandler.userProfile.nickName;
            
            cell.phoneNumberTextField.text = STUserAccountHandler.userProfile.userName;
        }
        
    } else if (indexPath.section == 1) {
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][1];
            
        }
        
    } else if (indexPath.section == 2) {
        

        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][2];
        }
        
        if (indexPath.row == 0) {
            
            cell.firstTitleLabel.text = @"日期";
            
            cell.firstTitleLabel.hidden = NO;
            
            cell.contentLabel.text = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:self.selectorDate];
            
        } else {
            
            AppointmentTimeModel *timeModel = self.timeModelArray[indexPath.row - 1];
            
            if (indexPath.row == 1) {
                
                cell.firstTitleLabel.text = @"场次";
                
                cell.firstTitleLabel.hidden = NO;
                
                [cell configOrderWithAppointmentTimeModel:timeModel];
                
            } else {
                
                cell.firstTitleLabel.hidden = YES;
                
                [cell configOrderWithAppointmentTimeModel:timeModel];
            }
            
        }
 
    } else if (indexPath.section == 3) {
 
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][3];
        }
        
        //配置总价格
        [cell configTotalPriceWith:self.timeModelArray];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1) {
        
        return 100;
        
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.5f;
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
