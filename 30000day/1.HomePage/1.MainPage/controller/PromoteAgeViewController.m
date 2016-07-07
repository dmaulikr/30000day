//
//  PromoteAgeViewController.m
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PromoteAgeViewController.h"
#import "PromoteAgeTableViewCell.h"
#import "PhysicalExaminationViewController.h"
#import "SettingBirthdayView.h"
#import "LifeDescendFactorsViewController.h"
#import "FactorVerificationView.h"
#import "SportTableViewController.h"

@interface PromoteAgeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PromoteAgeTableViewCell *checkCell;//体检

@end

@implementation PromoteAgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提升天龄";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    
    self.isShowBackItem = YES;
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
}

- (PromoteAgeTableViewCell *)checkCell {
    
    if (!_checkCell) {
        
        _checkCell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][1];
    }
    
    return _checkCell;
}


#pragma ---
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 4;
        
    } else {
    
        return 1;
    
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 0.1f;
        
    }
    
    return 20;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if ([Common isObjectNull:self.sportText]) {
                
                return 0.0f;
                
            } else {
                
                return 18.0 + [Common heightWithText:self.sportText width:SCREEN_WIDTH - 24 fontSize:17.0];
            }
        }
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
    
        if (indexPath.row == 0) {
            
            PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sportsRemindCellFirst"];
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][0];
                
            }
            
            cell.sportTextLableFirst.text = self.sportText;
            
            return cell;
            
        } else if (indexPath.row == 1) {
            
            PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sleepCellSecond"];
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][1];
            }
            
            cell.sleepLableSecond.text = @"健康作息提醒（21:30入睡）";
            
            cell.switchButton.on = [Common readAppBoolDataForkey:WORK_REST_NOTIFICATION];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        } else if (indexPath.row == 2) {
            
            PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ageDeclineCellThird"];
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][2];
            }
            
            cell.physicalExaminationLableThird.text = @"体检提醒";
           
            cell.detailLabel_third.text = [Common readAppBoolDataForkey:CHECK_NOTIFICATION] ? @"已开启" : @"已关闭";
            
            return cell;
            
        } else if (indexPath.row == 3) {
            
            PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ageDeclineCellThird"];
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][2];
            }
            
            cell.physicalExaminationLableThird.text = @"可改善因素";
            
            return cell;
        }
        
    } else {
    
        PromoteAgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ageDeclineCellThird"];
        
        if (cell == nil) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"PromoteAgeTableViewCell" owner:nil options:nil][2];
        }
        
        cell.physicalExaminationLableThird.text = @"开始跑步";
        
        return cell;
    
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
    
        if (indexPath.row == 2) {
            
            PhysicalExaminationViewController *controller =  [[PhysicalExaminationViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [controller setSetSuccessBlock:^{
               
                [self.tableView reloadData];
                
            }];
            
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if(indexPath.row == 3) {
        
            NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
            
            BOOL isOn = [userConfigure[FACTORVERIFICATION] boolValue];
            
            if (isOn) {
                
                FactorVerificationView *view = [[[NSBundle mainBundle] loadNibNamed:@"FactorVerificationView" owner:self options:nil] lastObject];
                
                [view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                
                __weak FactorVerificationView *weakSelf = view;
                
                [view setButtonBlock:^(UIButton *button) {
                    
                    if ([Common isObjectNull:weakSelf.passWordTextFiled.text]) {
                        
                        [self showToast:@"密码不能为空"];
                        
                        return;
                        
                    }
                    
                    [STDataHandler sendCheckPasswordWithUserId:STUserAccountHandler.userProfile.userId password:weakSelf.passWordTextFiled.text success:^(BOOL success) {
                        
                        if (success) {
                            
                            [weakSelf removeFromSuperview];
                            
                            LifeDescendFactorsViewController *controller = [[LifeDescendFactorsViewController alloc] init];
                            [self.navigationController pushViewController:controller animated:YES];
                            
                        } else {
                            
                            [self showToast:@"密码错误"];
                            
                        }
                        
                    } failure:^(NSError *error) {
                        
                        [self showToast:@"服务器繁忙"];
                        
                    }];
                    
                }];
                
                
                [[[UIApplication sharedApplication].delegate window] addSubview:view];
                
            } else {
                
                LifeDescendFactorsViewController *controller = [[LifeDescendFactorsViewController alloc] init];
                
                [self.navigationController pushViewController:controller animated:YES];
                
            }
        }
        
    } else {
    
        SportTableViewController *controller = [[SportTableViewController alloc] init];
        
        [self.navigationController pushViewController:controller animated:YES];
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
