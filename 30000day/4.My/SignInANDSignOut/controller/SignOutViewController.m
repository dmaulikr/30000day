//
//  regitViewCtr.m
//  30000天
//
//  Created by wei on 15/11/19.
//  Copyright © 2015年 wei. All rights reserved.
//

#import "SignOutViewController.h"
#import "SignInViewController.h"
#import "STTabBarViewController.h"

@interface SignOutViewController () <QGPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userPwdTxt;

@property (weak, nonatomic) IBOutlet UITextField *ConfirmPasswordTxt;

@property (weak, nonatomic) IBOutlet UITextField *userNickNameTxt;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIView *passwordTextSubView;

@property (weak, nonatomic) IBOutlet UIView *niceNameTextSubView;

@end

@implementation SignOutViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"闪电注册";
    
    self.passwordTextSubView.layer.borderWidth = 1.0;
    
    self.passwordTextSubView.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.niceNameTextSubView.layer.borderWidth = 1.0;
    
    self.niceNameTextSubView.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.submitBtn.layer.cornerRadius = 6;
    
    self.submitBtn.layer.masksToBounds = YES;
    
    _userNickNameTxt.delegate = self;
    
    self.submitBtn.layer.borderWidth = 0.5;
    
    self.submitBtn.layer.borderColor = [UIColor colorWithRed:181.0/255 green:181.0/255 blue:181.0/255 alpha:1.0].CGColor;
        
    [self.userPwdTxt setDelegate:self];
    
    [self.ConfirmPasswordTxt setDelegate:self];
    
    [self.userNickNameTxt setDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction {
    
    [self.view endEditing:YES];
}

#pragma mark - 注册验证
- (IBAction)regitF:(UIButton *)sender {
    
    if( [_userPwdTxt.text isEqualToString:@""] ) {
        
        [self showToast:@"密码不能为空"];
        
        return;
    }
    
   if (![_userPwdTxt.text isEqualToString:_ConfirmPasswordTxt.text]){
       
        [self showToast:@"密码不一致，请重新确认"];
        
        return;
    }
    
    BOOL ok= [self isIncludeSpecialCharact:self.userNickNameTxt.text];
    
    if (ok == YES) {
        [self showToast:@"昵称不允许包含特殊字符，请重新输入！"];
    } else {
        [self registerUser];
    }
}

#pragma mark - 注册
- (void)registerUser {
    
    [self.view endEditing:YES];
    
    //调用注册接口
    [self.dataHandler postRegesiterWithPassword:_userPwdTxt.text
                                    phoneNumber:_PhoneNumber
                                       nickName:_userNickNameTxt.text
                                    mobileToken:self.mobileToken//校验后获取的验证码
                                        success:^(BOOL success) {
                                            
                                           [self showToast:@"注册成功"];
                                    
                                           [self.tabBarController setSelectedIndex:0];
                                            
                                           [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                        }
                                        failure:^(NSError *error) {
                                            
                                            [self showToast:@"注册失败"];
                                            
                                        }];
    
}


- (BOOL) isIncludeSpecialCharact: (NSString *)str {
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound){
        return NO;
    }
    return YES;
}

#pragma mark - 键盘return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
