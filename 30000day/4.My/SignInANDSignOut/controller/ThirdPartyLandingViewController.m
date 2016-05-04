//
//  ThirdPartyLandingViewController.m
//  30000day
//
//  Created by wei on 16/5/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ThirdPartyLandingViewController.h"
#import "MTProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "STTabBarViewController.h"

#define IdentityCount 60

@interface ThirdPartyLandingViewController () <UITextFieldDelegate> {
    int count;
}


@property (nonatomic) NSTimer *timer;

@property (nonatomic,assign)CGRect selectedTextFieldRect;

@property (nonatomic,copy) NSString *mobileToken;//校验后获取的验证码

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *sms;

@property (weak, nonatomic) IBOutlet UITextField *passWord;

@property (weak, nonatomic) IBOutlet UIButton *smsBtn;

- (IBAction)nextBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *textSubView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


@property (weak, nonatomic) IBOutlet UILabel *loginTypeLable;

@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;

@property (weak, nonatomic) IBOutlet UILabel *loginName;

@property (weak, nonatomic) IBOutlet UIView *loginSupView;

@end

@implementation ThirdPartyLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机绑定";
    
    [self.phoneNumber setDelegate:self];
    
    [self.sms setDelegate:self];
    
    [self.passWord setDelegate:self];
    
    self.textSubView.layer.borderWidth = 1.0;
    
    self.textSubView.layer.borderColor = [UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.nextBtn.layer.cornerRadius = 6;
    
    self.nextBtn.layer.masksToBounds = YES;
    
    self.loginTypeLable.text = self.type;
    
    [self.loginImageView sd_setImageWithURL:[NSURL URLWithString:self.url]];

    self.loginName.text = self.name;
}

#pragma mark - 绑定
- (IBAction)nextBtn:(UIButton *)sender {
    
    if ([self.phoneNumber.text isEqualToString:@""]) {
        
        [self showToast:@"手机号码不能为空"];
        
        return;
    }
    
    if ([self.sms.text isEqualToString:@""]) {
        
        [self showToast:@"验证码不能为空"];
        
        return;
    }
    
    if ([self.passWord.text isEqualToString:@""]) {
        
        [self showToast:@"密码不能为空"];
        
        return;
    }
    
    //该手机号已经绑定，继续将绑定当前账号
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    //[self.dataHandler postVerifySMSCodeWithPhoneNumber:self.phoneNumber.text smsCode:self.sms.text success:^(NSString *mobileToken) {
        
        [self.dataHandler sendBindRegisterWithMobile:self.phoneNumber.text nickName:self.name accountNo:self.uid password:self.passWord.text headImg:self.url type:self.type success:^(NSString *success) {
            
            if (success.integerValue) {
                
                [self.dataHandler postSignInWithPassword:self.passWord.text
                                               loginName:self.phoneNumber.text
                                      isPostNotification:YES
                                        isFromThirdParty:NO
                                                 success:^(BOOL success) {
                                                     
                                                     NSUserDefaults *userDefaulst = [NSUserDefaults standardUserDefaults];
                                                     
                                                     [userDefaulst setBool:NO forKey:@"isFromThirdParty"];
                                                     
                                                     [userDefaulst synchronize];
                                                     
                                                     [STAppDelegate openChat:STUserAccountHandler.userProfile.userId
                                                                  completion:^(BOOL success) {
                                                                      
                                                                      [self textFiledResignFirst];
                                                                      
                                                                      [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                                      
                                                                      UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                      
                                                                      STTabBarViewController *controller = [board instantiateInitialViewController];
                                                                      
                                                                      [controller setSelectedIndex:0];
                                                                      
                                                                      UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                                                      
                                                                      window.rootViewController = controller;
                                                                      
                                                                      
                                                                  } failure:^(NSError *error) {
                                                                      
                                                                  }];
                                                     
                                                     
                                                 } failure:^(NSError *error) {
                                                     
                                                     [self textFiledResignFirst];
                                                     
                                                     [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                     
                                                     [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                                                     
                                                 }];
                
            } else {
                
                [self textFiledResignFirst];
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                [self showToast:@"绑定/注册失败"];
                
            }
            
        } failure:^(NSError *error) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            [self showToast:@"服务器繁忙"];
            
        }];
        
//    } failure:^(NSError *error) {
//        
//        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
//        
//        [self showToast:@"验证失败"];
//        
//    }];

}

#pragma mark - 暂不绑定
- (IBAction)notBind:(UIButton *)sender {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendCheckRegisterForThirdParyWithAccountNo:self.uid success:^(NSString *success) {
        
        if (success.integerValue) {
            
            [self regist:self.uid];

        } else {
            
            [self.dataHandler sendRegisterForThirdParyWithAccountNo:self.uid nickName:self.name headImg:self.url success:^(NSString *success) {
                
                if (success.integerValue) {
                    
                    [self regist:self.uid];
                    
                }
                
            } failure:^(NSError *error) {
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                [self ShowAlert:@"aa"];
                
            }];
        
        }
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    }];
    
}

- (void)regist:(NSString *)loginName {

    [self.dataHandler postSignInWithPassword:nil
                                   loginName:loginName
                          isPostNotification:YES
                            isFromThirdParty:YES
                                     success:^(BOOL success) {
                                         
                                         NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

                                         [userDefaults setBool:YES forKey:@"isFromThirdParty"];
  
                                         [userDefaults synchronize];
                                         
                                         
                                         [STAppDelegate openChat:STUserAccountHandler.userProfile.userId
                                                      completion:^(BOOL success) {
                                                          
                                                          [self textFiledResignFirst];
                                                          
                                                          [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                          
                                                          UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                          
                                                          STTabBarViewController *controller = [board instantiateInitialViewController];
                                                          
                                                          [controller setSelectedIndex:0];
                                                          
                                                          UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                                          
                                                          window.rootViewController = controller;
                                                          
                                                          
                                                      } failure:^(NSError *error) {
                                                          
                                                      }];
                                         
                                         
                                     } failure:^(NSError *error) {
                                         
                                         [self textFiledResignFirst];
                                         
                                         [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                         
                                         [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                                         
                                     }];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        
        [self.phoneNumber resignFirstResponder];
        [self.passWord resignFirstResponder];
        [self.sms becomeFirstResponder];
        
    } else if(textField.tag == 2) {
        
        [self.phoneNumber resignFirstResponder];
        [self.passWord becomeFirstResponder];
        [self.sms resignFirstResponder];
        
    } else {
        
        [self.phoneNumber resignFirstResponder];
        [self.passWord resignFirstResponder];
        [self.sms resignFirstResponder];
        
        [self nextBtn:nil];
    
    }
    
    return YES;
}

#pragma mark - 短信验证 smsBtn倒计时
- (IBAction)smsVerificationBtn:(id)sender {
    
    if (self.phoneNumber.text == nil || [self.phoneNumber.text isEqualToString:@""]) {
        
        [self showToast:@"请输入手机号"];
        
        return;
    }
    
    //调用短信验证接口
    [self.dataHandler getVerifyWithPhoneNumber:self.phoneNumber.text
                                          type:@(3)
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self textFiledResignFirst];

}

- (void)textFiledResignFirst {

    [self.phoneNumber resignFirstResponder];
    
    [self.sms resignFirstResponder];
    
    [self.passWord resignFirstResponder];

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
