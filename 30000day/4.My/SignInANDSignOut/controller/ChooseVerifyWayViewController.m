//
//  ChoicePwd.m
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "ChooseVerifyWayViewController.h"
#import "FindPasswordViewController.h"
#import "PasswordVerifiedViewController.h"

@interface ChooseVerifyWayViewController ()

@property (strong, nonatomic)UITableView *CPTable;//选择找回密码方式

@property (nonatomic, strong) UISwipeGestureRecognizer *RightSwipeGestureRecognizer;

@end

@implementation ChooseVerifyWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"验证方式";
    
    _CPTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, [UIScreen mainScreen].bounds.size.width, 88) style:UITableViewStylePlain];
    
    _CPTable.tableFooterView = [[UIView alloc] init];
    
    _CPTable.scrollEnabled = NO;
    
    _CPTable.layer.borderWidth = 1.0;
    
    _CPTable.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    [self.CPTable setDelegate:self];
    
    [self.CPTable setDataSource:self];
    
    [self.view addSubview:_CPTable];
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
        
        FindPasswordViewController *tm = [[FindPasswordViewController alloc]init];

        
        [self.navigationController pushViewController:tm animated:YES];
        
    } if (indexPath.row == 1) {
        
        PasswordVerifiedViewController *sp = [[PasswordVerifiedViewController alloc]init];
        
        [self.navigationController pushViewController:sp animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
