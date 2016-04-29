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
#import "InputAccountViewController.h"

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

        controller.isSignOut = 2;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    } if (indexPath.row == 1) {
        
        InputAccountViewController *controller = [[InputAccountViewController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
