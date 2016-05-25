//
//  ChangePasswordViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;//旧密码

@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;//新密码

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextFiled;//确认密码

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commitButton.layer.cornerRadius = 5;
    
    self.commitButton.layer.masksToBounds = YES;
    
    [self.oldPasswordTextField becomeFirstResponder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction {
    
    [self.view endEditing:YES];
}

//确实提交
- (IBAction)confirmCommitAction:(id)sender {
    
    [self beginChangePassword];
}

- (void)beginChangePassword {
    
    if ([Common isObjectNull:self.oldPasswordTextField.text]) {
        
        [self showToast:@"旧密码不能为空"];
        
        return;
    }
    
    if ([Common isObjectNull:self.passwordTextFiled.text] || [Common isObjectNull:self.confirmPasswordTextFiled.text]) {
        
        [self showToast:@"新的密码不能为空"];
        
        return;
        
    }
    
    if (![self.passwordTextFiled.text isEqualToString:self.confirmPasswordTextFiled.text]) {
        
        [self showToast:@"新密码输入不一致"];
        
        return;
    }
    
    [self.view endEditing:YES];
    
    //提交修改密码
    [STDataHandler sendChangePasswordWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID]
                                       oldPassword:self.oldPasswordTextField.text
                                       newPassword:self.passwordTextFiled.text
                                           success:^(BOOL success) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                                   [self showToast:@"密码修改成功"];
                                                   
                                                   [self.navigationController popViewControllerAnimated:YES];
                                                   
                                               });
                                               
                                           } failure:^(NSError *error) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                                   [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                                               
                                               });
                                               
                                           }];
}


#pragma ---
#pragma mark ---- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField == self.oldPasswordTextField) {
        
        [self.passwordTextFiled becomeFirstResponder];
    }
    
    if (textField == self.passwordTextFiled) {
        
        [self.confirmPasswordTextFiled becomeFirstResponder];
        
    }
    
    if (textField == self.confirmPasswordTextFiled) {
        
        [self beginChangePassword];
        
    }
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
