//
//  securityTableViewController.m
//  30000天
//
//  Created by wei on 16/1/21.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "SecurityViewController.h"
#import "securityTableViewCell.h"
#import "ChangePasswordViewController.h"
#import "ChangePasswordProtectViewController.h"
#import "SelectionMethodViewController.h"
#import "MTProgressHUD.h"

@interface SecurityViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *titleCellArray;

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"安全中心";
    
    UIView *footerview = [[UIView alloc] init];
    
    [self.tableView setTableFooterView:footerview];
    
    self.titleCellArray = [NSArray arrayWithObjects:@"设置密保",@"修改密码",@"修改手机号码",@"账号绑定", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"securityCell";
    
    securityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSArray *objs = [bundle loadNibNamed:@"securityTableViewCell" owner:nil options:nil];
        
        cell = [objs lastObject];
    }
    
    cell.textLabel.text = self.titleCellArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        
        [self.dataHandler sendGetUserIdByUserName:[Common readAppDataForKey:KEY_SIGNIN_USER_NAME] success:^(NSNumber *userId) {
            [self.dataHandler sendGetSecurityQuestion:userId
                                              success:^(NSDictionary *success) {
                                                  
                                                  [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                  
                                                  ChangePasswordProtectViewController *controller = [[ChangePasswordProtectViewController alloc] init];
                                                  
                                                  controller.hidesBottomBarWhenPushed = YES;

                                                  if ([Common isObjectNull:success]) {
                                                      
                                                      controller.isSet = NO;
                                                      
                                                  } else {
                                                      
                                                      controller.isSet = YES;
                                                  }
                                                  
                                                  [self.navigationController pushViewController:controller animated:YES];
                                                  
                                              } failure:^(STNetError *error) {
                                                  
                                                  [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                              }];
            
            
        } failure:^(NSError *error) {
            
            [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
            
        }];
        
    } else if (indexPath.row == 1) {
        
        ChangePasswordViewController *controller = [[ChangePasswordViewController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (indexPath.row == 3){
        
        SelectionMethodViewController *controller = [[SelectionMethodViewController alloc]init];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
