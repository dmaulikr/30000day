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

#define IdentityCount 60

@interface SMSVerificationViewController ()<UITextFieldDelegate> {
    
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
    [self.dataHandler postVerifySMSCodeWithPhoneNumber:self.phoneNumber.text smsCode:self.sms.text success:^(NSString *mobileToken) {
       
        if (self.isSignOut) {
            
            SignOutViewController *controller = [[SignOutViewController alloc] init];
            
            controller.PhoneNumber = self.phoneNumber.text;
            
            controller.mobileToken = mobileToken;
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
            
        } else {
            
            NewPasswordViewController *controller = [[NewPasswordViewController alloc] init];
            
            controller.mobileToken = mobileToken;
            
            controller.mobile = self.phoneNumber.text;
            
            controller.type = NO;
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        
    } failure:^(NSError *error) {

        [self showToast:@"验证失败"];
        
    }];
}

#pragma mark - 短信验证 smsBtn倒计时
- (IBAction)smsVerificationBtn:(id)sender {
    
    if (self.phoneNumber.text == nil || [self.phoneNumber.text isEqualToString:@""]) {
        
        [self showToast:@"请输入手机号"];
        
        return;
    }

    //调用短信验证接口
    [self.dataHandler getVerifyWithPhoneNumber:self.phoneNumber.text
                                          type:self.isSignOut ? @1 : @2
                                       success:^(NSString *responseObject) {
        
        count = IdentityCount;
        
        _smsBtn.enabled = NO;
        
        [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Down) userInfo:nil repeats:YES];
        
    } failure:^(NSString *error) {
        
        [self showToast:error];
        
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
