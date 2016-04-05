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
#import "MTProgressHUD.h"

@interface AppointmentConfirmViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) PersonInformationTableViewCell *informationCell;

@property (nonatomic,strong) PersonInformationTableViewCell *remarkCell;

@property (nonatomic,strong) UIButton *conformButton;

@end

@implementation AppointmentConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    self.conformButton =  [Common addAppointmentBackgroundView:self.view title:@"提交订单并支付" selector:@selector(rightButtonAction) controller:self];
    
    [self.conformButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [STNotificationCenter addObserver:self selector:@selector(judgeConformButton) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self judgeConformButton];
}

//判断确认订单是否可用
- (void)judgeConformButton {
    
    if ([Common isObjectNull:self.informationCell.contactTextField.text] || [Common isObjectNull:self.informationCell.phoneNumberTextField.text]) {
        
        self.conformButton.enabled = NO;
        
    } else {
        
        self.conformButton.enabled = YES;
        
    }
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
}

- (PersonInformationTableViewCell *)informationCell {
    
    if (!_informationCell) {
        
        _informationCell = [[[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil] firstObject];
    }
    
    return _informationCell;
}

- (PersonInformationTableViewCell *)remarkCell {
    
    if (!_remarkCell) {
        
        _remarkCell = [[NSBundle mainBundle] loadNibNamed:@"PersonInformationTableViewCell" owner:nil options:nil][1];
    }
    
    return _remarkCell;
}

- (void)rightButtonAction {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [self.dataHandler sendCommitOrderWithUserId:STUserAccountHandler .userProfile.userId
                                      productId:self.productId
                                    contactName:self.informationCell.contactTextField.text
                             contactPhoneNumber:self.informationCell.phoneNumberTextField.text
                                           date:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:self.selectorDate]
                                         remark:self.remarkCell.remarkTextView.text
                                 uniqueKeyArray:self.timeModelArray
                                        Success:^(BOOL success) {
                                            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                            PaymentViewController *controller = [[PaymentViewController alloc] init];
                                            
                                            controller.timeModelArray = self.timeModelArray;
                                            
                                            controller.selectorDate = self.selectorDate;
                                            
                                            controller.hidesBottomBarWhenPushed = YES;
                                            
                                            [self.navigationController pushViewController:controller animated:YES];
                                            
                                            
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        [self showToast:@"提交订单失败"];
    }];
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
        
        self.informationCell.contactTextField.text = STUserAccountHandler.userProfile.nickName;
        
        self.informationCell.phoneNumberTextField.text = STUserAccountHandler.userProfile.userName;
        
        [self judgeConformButton];
        
        return self.informationCell;
        
    } else if (indexPath.section == 1) {
        
        return self.remarkCell;
        
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
