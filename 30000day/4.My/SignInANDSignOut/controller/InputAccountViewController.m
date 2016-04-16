//
//  loginNameVerificationViewController.m
//  30000天
//
//  Created by wei on 16/1/16.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "InputAccountViewController.h"
#import "ChooseVerifyWayViewController.h"
#import "PasswordVerifiedViewController.h"

@interface InputAccountViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UITextField *loginNameText;

@end

@implementation InputAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"输入账号";
    
    [self.submitBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitBtn.layer.cornerRadius = 6;
    
    self.submitBtn.layer.masksToBounds = YES;
    
    [self.loginNameText setDelegate:self];
    
}

- (void)nextAction {
    
    if (self.loginNameText.text == nil) {
        
        [self showToast:@"请填写需要找回密码的账号"];
        
        return;
    }
    
    [self.dataHandler sendGetUserIdByUserName:self.loginNameText.text success:^(NSNumber *userId) {
        
        [Common saveAppDataForKey:KEY_SIGNIN_USER_UID withObject:userId];//获取到该账号的userId会存储起来
        
        [self.dataHandler sendGetSecurityQuestion:userId
                                          success:^(NSDictionary *success) {
                                              
                                              PasswordVerifiedViewController *controller = [[PasswordVerifiedViewController alloc]init];
                                              
                                              controller.passwordVerifiedDictionary = success;
                                              
                                              controller.hidesBottomBarWhenPushed = YES;
                                              
                                              [self.navigationController pushViewController:controller animated:YES];
                                              
                                          } failure:^(STNetError *error) {
                                              
                                          }];
        
        
    } failure:^(NSError *error) {
        
        [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
        
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self nextAction];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.loginNameText resignFirstResponder];
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
