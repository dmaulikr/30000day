//
//  ChoicePwd.m
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "ChooseVerifyWayViewController.h"
#import "PasswordVerifiedViewController.h"
#import "SMSVerificationViewController.h"

@interface ChooseVerifyWayViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseVerifyWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"验证方式";

}

#pragma ---
#pragma mark --- UITableViewDelegate/UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     
    return 44;
     
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell=[[UITableViewCell alloc]init];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"手机验证";
        
    }if (indexPath.row == 1) {
        
        cell.textLabel.text = @"密保验证";
        
    }
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:20.0]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        SMSVerificationViewController *controller = [[SMSVerificationViewController alloc]init];

        controller.isSignOut = NO;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } if (indexPath.row == 1) {
        
        [self.dataHandler sendGetSecurityQuestion:[Common readAppDataForKey:KEY_SIGNIN_USER_UID]
                                          success:^(NSDictionary *success) {
            
            PasswordVerifiedViewController *sp = [[PasswordVerifiedViewController alloc]init];
            
            sp.PasswordVerifiedDic=success;
            
            [self.navigationController pushViewController:sp animated:YES];
            
        } failure:^(LONetError *error) {
            
        }];
        
        

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
