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

#define IdentityCount 60

@interface SMSVerificationViewController ()<UITextFieldDelegate> {
    
    int count;
}

@property (nonatomic) NSTimer *timer;

@property (nonatomic,assign)CGRect selectedTextFieldRect;

@end

@implementation SMSVerificationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"闪电注册";
    
    [self.phoneNumber setDelegate:self];
    
    [self.sms setDelegate:self];
    
    self.textSubView.layer.borderWidth=1.0;
    
    self.textSubView.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.nextBtn.layer.cornerRadius=6;
    
    self.nextBtn.layer.masksToBounds=YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
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
    [self.dataHandler postVerifySMSCodeWithPhoneNumber:self.phoneNumber.text smsCode:self.sms.text success:^(BOOL sucess) {
       
        SignOutViewController *signOut = [[SignOutViewController alloc] init];
        
        signOut.PhoneNumber = self.phoneNumber.text;
        
        signOut.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:signOut animated:YES];
        
    } failure:^(NSError *error) {
        
        NSLog(@"error : %@",[error localizedDescription]);
        
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"验证失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }];

}

#pragma mark - 短信验证 smsBtn倒计时
- (IBAction)smsVerificationBtn:(id)sender {
    
    if (self.phoneNumber.text == nil || [self.phoneNumber.text isEqualToString:@""]) {
        
        [self showToast:@"请输入手机号"];
        
        return;
    }
    
    //调用短信验证接口
    [self.dataHandler getVerifyWithPhoneNumber:self.phoneNumber.text success:^(id responseObject) {
        
        count = IdentityCount;
        
        _smsBtn.enabled = NO;
        
        [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Down) userInfo:nil repeats:YES];
        
    } failure:^(id error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"验证失败:%@",error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }];
}

- (void)CountDown {
    
    count = IdentityCount;
    [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",IdentityCount] forState:UIControlStateNormal];
    _smsBtn.enabled = NO;
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Down) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)Down {
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
