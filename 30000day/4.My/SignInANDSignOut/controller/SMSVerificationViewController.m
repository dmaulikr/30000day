//
//  SMSVerificationViewController.m
//  30000天
//
//  Created by wei on 16/1/12.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "SMSVerificationViewController.h"
#import "SignOutViewController.h"
#import "AFNetworking.h"
#import "NewPasswordViewController.h"
#import "UIImageView+WebCache.h"
#import "STTabBarViewController.h"
#import "MTProgressHUD.h"

#define IdentityCount 60

@interface SMSVerificationViewController () <UITextFieldDelegate> {
    int count;
}

@property (nonatomic) NSTimer *timer;
@property (nonatomic,assign)CGRect selectedTextFieldRect;
@property (nonatomic,copy) NSString *mobileToken;//校验后获取的验证码
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *sms;
@property (weak, nonatomic) IBOutlet UIButton *smsBtn;
- (IBAction)nextBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *textSubView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation SMSVerificationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"手机验证";
    [self.phoneNumber setDelegate:self];
    [self.sms setDelegate:self];
    
    self.textSubView.layer.borderWidth = 1.0;
    self.textSubView.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.nextBtn.layer.cornerRadius = 6;
    self.nextBtn.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        
        [self.phoneNumber resignFirstResponder];
        [self.sms becomeFirstResponder];
        
    }else{
        
        [self.sms resignFirstResponder];
        [self nextBtn:nil];
    }
    
    return YES;
}

#pragma mark - 下一步
- (IBAction)nextBtn:(UIButton *)sender {
    
    if ([self.phoneNumber.text isEqualToString:@""]) {
        [self showToast:@"手机号码不能为空"];
        return;
    }
    
    if ([self.sms.text isEqualToString:@""]) {
        [self showToast:@"验证码不能为空"];
        return;
    }
    
    //调用验证接口
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler postVerifySMSCodeWithPhoneNumber:self.phoneNumber.text smsCode:self.sms.text success:^(NSString *mobileToken) {
       
        if (self.isSignOut == 1) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            SignOutViewController *controller = [[SignOutViewController alloc] init];
            controller.PhoneNumber = self.phoneNumber.text;
            controller.mobileToken = mobileToken;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            
        } else if(self.isSignOut == 2){
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            NewPasswordViewController *controller = [[NewPasswordViewController alloc] init];
            controller.mobileToken = mobileToken;
            controller.mobile = self.phoneNumber.text;
            controller.type = NO;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    } failure:^(NSError *error) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            [self showToast:@"验证失败"];
    }];
}

//获取验证码
- (void)getVeriftCode {
    [STDataHandler getVerifyWithPhoneNumber:self.phoneNumber.text
                                          type:@(self.isSignOut)
                                       success:^(NSString *responseObject) {
                                           
                                           [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                           count = IdentityCount;
                                           _smsBtn.enabled = NO;
                                           [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
                                           _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
                                           
                                       } failure:^(NSString *error) {
                                           [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                           [self showToast:error];
                                       }];
}

#pragma mark - 短信验证 smsBtn倒计时
- (IBAction)smsVerificationBtn:(id)sender {
    
    if (self.phoneNumber.text == nil || [self.phoneNumber.text isEqualToString:@""]) {
        
        [self showToast:@"请输入手机号"];
        return;
    }

    if (self.isSignOut == 1) {
        
        //调用短信验证接口
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [STDataHandler sendcheckRegisterForMobileWithmobile:self.phoneNumber.text success:^(NSString *success) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (success.boolValue) {//已经注册
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"该手机号已注册过账号，继续注册将不再属于原账号" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [controller addAction:action];
                    [controller addAction:cancelAction];
                    [self presentViewController:controller animated:YES completion:nil];
                }
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                [self getVeriftCode];
            });
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                [self getVeriftCode];
            });
        }];
        
    } else if (self.isSignOut == 2) {
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [STDataHandler sendcheckRegisterForMobileWithmobile:self.phoneNumber.text success:^(NSString *success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                if (success.boolValue) {
                
                        //调用短信验证接口
                        [STDataHandler getVerifyWithPhoneNumber:self.phoneNumber.text
                                                              type:@(self.isSignOut)
                                                           success:^(NSString *responseObject) {
                                                               
                                                               [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                               count = IdentityCount;
                                                               _smsBtn.enabled = NO;
                                                               [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
                                                               _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeatAction) userInfo:nil repeats:YES];
                                                               
                                                           } failure:^(NSString *error) {
                                                               [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                               [self showToast:error];
                                                           }];
                    
                } else {
                
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    [self showToast:@"您还没有注册，请先注册"];
                }
            });
            
        } failure:^(NSError *error) {
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        }];
    }
}

- (void)repeatAction {
    
    [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
    
    if (count == -1) {
        _smsBtn.enabled = YES;
        [_smsBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        count = IdentityCount;
        [_timer invalidate];
    }
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
