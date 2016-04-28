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
#import "DuplicationTableViewCell.h"

@interface AppointmentConfirmViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) PersonInformationTableViewCell *informationCell;

@property (nonatomic,strong) PersonInformationTableViewCell *remarkCell;

@property (nonatomic,strong) UIButton *conformButton;

@end

@implementation AppointmentConfirmViewController {
    
    PriceModel *_model;//保存的价格
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
    self.conformButton =  [Common addAppointmentBackgroundView:self.view title:@"提交订单并支付" selector:@selector(rightButtonAction) controller:self];
    
    [self.conformButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [STNotificationCenter addObserver:self selector:@selector(judgeConformButton) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self judgeConformButton];
    
    //计算价格
    [self calculatePrice];
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
        
        _remarkCell.remarkTextView.delegate = self;
        
    }
    return _remarkCell;
}

- (void)rightButtonAction {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    //提交订单
    [self.dataHandler sendCommitOrderWithUserId:STUserAccountHandler .userProfile.userId
                                      productId:self.productId
                                    contactName:self.informationCell.contactTextField.text
                             contactPhoneNumber:self.informationCell.phoneNumberTextField.text
                                           date:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:self.selectorDate]
                                         remark:self.remarkCell.remarkTextView.text
                                 uniqueKeyArray:self.timeModelArray
                                  payableAmount:_model.currentPrice
                                        Success:^(NSString *orderNumber) {
                                            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                            PaymentViewController *controller = [[PaymentViewController alloc] init];
                                            
//                                            controller.timeModelArray = self.timeModelArray;
//                                            
//                                            controller.selectorDate = self.selectorDate;
//                                            
//                                            controller.productName = self.productName;
                                            
                                            controller.orderNumber = orderNumber;
                                            
                                            controller.hidesBottomBarWhenPushed = YES;
                                            
                                            [self.navigationController pushViewController:controller animated:YES];
                                            
                                            
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        [self showToast:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }];
}

//计算价格
- (void)calculatePrice {
    
    [self.dataHandler sendCalculateWithProductId:self.productId uniqueKeyArray:self.timeModelArray Success:^(PriceModel *model) {
       
        _model = model;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
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
        
    } else if (section == 3) {
        
        return _model.activityList.count + 2;
        
    } else {
        
       return 1;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        self.informationCell.contactTextField.text = STUserAccountHandler.userProfile.nickName;
        
        self.informationCell.phoneNumberTextField.text = STUserAccountHandler.userProfile.userName;
        
        [self judgeConformButton];
        
        return self.informationCell;
        
    } else if (indexPath.section == 1) {
        
        return self.remarkCell;
        
    } else if (indexPath.section == 2) {

        DuplicationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DuplicationTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DuplicationTableViewCell" owner:nil options:nil] firstObject];
        }
        
        if (indexPath.row == 0) {
            
            cell.titleLabel_first.text = @"日期";
            
            cell.titleLabel_first.hidden = NO;
            
            cell.contentLabel_first.text = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:self.selectorDate];
            
        } else if (indexPath.row == 1) {
            
            cell.titleLabel_first.text = @"场次";
            
            cell.titleLabel_first.hidden = NO;
            
            [cell configCellWithAppointmentTimeModel:self.timeModelArray[indexPath.row - 1]];
            
        } else {
            
            cell.titleLabel_first.hidden = YES;
            
            [cell configCellWithAppointmentTimeModel:self.timeModelArray[indexPath.row - 1]];
        }
        
        return cell;
 
    } else if (indexPath.section == 3) {
        
        DuplicationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DuplicationTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DuplicationTableViewCell" owner:nil options:nil] firstObject];
        }
        
        if (indexPath.row == 0) {
            
            cell.titleLabel_first.text = @"原价";
            
            cell.contentLabel_first.textColor = [UIColor redColor];
            
            cell.contentLabel_first.text =[NSString stringWithFormat:@"￥: %.2f",[_model.originalPrice floatValue]];//原价
            
        } else if (indexPath.row == _model.activityList.count + 1) {
            
            cell.titleLabel_first.text = @"应付金额";
            
            cell.contentLabel_first.textColor = [UIColor redColor];
            
            cell.contentLabel_first.text = [NSString stringWithFormat:@"￥: %.2f",[_model.currentPrice floatValue]];//现价
            
        } else {
            
            [cell configCellWithActivityModel:_model.activityList[indexPath.row - 1]];
        }
        
        return cell;
    }
    
    return nil;
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

#pragma ---
#pragma mark --- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
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
