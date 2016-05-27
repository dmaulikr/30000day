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

@property (weak, nonatomic) IBOutlet UIButton *temporarilyButton;

@property (weak, nonatomic) IBOutlet UILabel *loginTypeLable;

@property (weak, nonatomic) IBOutlet UIImageView *loginImageView;

@property (weak, nonatomic) IBOutlet UILabel *loginName;

@property (weak, nonatomic) IBOutlet UIView *loginSupView;

@property (weak, nonatomic) IBOutlet UILabel *promptLable;


@end

@implementation ThirdPartyLandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机绑定";
    
    if (self.isConceal) {
        
        self.temporarilyButton.hidden = YES;
        
        self.loginSupView.hidden = YES;
        
    }
    
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
    
    if ([Common isObjectNull:self.phoneNumber.text]) {
        
        [self showToast:@"手机号码不能为空"];
        
        return;
    }
    
    if ([Common isObjectNull:self.sms.text]) {
        
        [self showToast:@"验证码不能为空"];
        
        return;
    }
    
    if ([Common isObjectNull:self.passWord.text]) {
        
        [self showToast:@"密码不能为空"];
        
        return;
    }
    
    if (!self.isConceal) {
        
        if ([Common isObjectNull:self.uid] || [Common isObjectNull:self.name] || [Common isObjectNull:self.url]) {
            
            [self showToast:@"第三方信息获取失败，请重新授权"];
            
            return;
            
        }
    
    }
    

    NSString *uid = self.uid;
    
    NSString *name = self.name;
    
    NSString *url = self.url;
    
    NSString *type = self.type;
    
    if (self.isConceal) {
        
        uid = [NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId];
        
        name = STUserAccountHandler.userProfile.nickName;
        
        url = STUserAccountHandler.userProfile.headImg;
        
        type = nil;
        
    }
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [self.dataHandler postVerifySMSCodeWithPhoneNumber:self.phoneNumber.text smsCode:self.sms.text success:^(NSString *mobileToken) {
        
        [STDataHandler sendBindRegisterWithMobile:self.phoneNumber.text nickName:name accountNo:uid password:self.passWord.text headImg:url type:type success:^(NSString *success) {
            
            if (success.boolValue) {
                
                [self.dataHandler postSignInWithPassword:self.passWord.text
                                               loginName:self.phoneNumber.text
                                      isPostNotification:YES
                                        isFromThirdParty:NO
                                                    type:nil
                                                 success:^(BOOL success) {
                                                     
                                                     [Common saveAppBoolDataForKey:@"isFromThirdParty" withObject:NO];
                                                     
                                                     [Common removeAppDataForKey:@"type"];

                                                     [STAppDelegate openChat:STUserAccountHandler.userProfile.userId
                                                                  completion:^(BOOL success) {
                                                                      
                                                                      [self textFiledResignFirst];
                                                                      
                                                                      [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                                      
                                                                      if (!self.isConceal) {
                                                                          
                                                                          [self.tabBarController setSelectedIndex:0];
                                                                          
                                                                          [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                                                          
                                                                      } else {
                                                                      
                                                                          [self.navigationController popViewControllerAnimated:YES];
                                                                      
                                                                      }
                                                                      
                                                                  } failure:^(NSError *error) {
                                                                      
                                                                  }];
                                                     
                                                     
                                                 } failure:^(NSError *error) {
                                                     
                                                     [self textFiledResignFirst];
                                                     
                                                     [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                     
                                                     [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                                                     
                                                 }];
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self textFiledResignFirst];
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                    [self showToast:@"绑定/注册失败"];
                
                });
                
            }
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{

                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                [self showToast:@"服务器繁忙"];
                
            });
            
        }];
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            [self showToast:@"验证失败"];
        
        });
        
    }];

}

#pragma mark - 暂不绑定
- (IBAction)notBind:(UIButton *)sender {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendCheckRegisterForThirdParyWithAccountNo:self.uid success:^(NSString *success) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (success.boolValue) {
                
                [self regist:self.uid];
                
            } else {
                
                if ([Common isObjectNull:self.uid] || [Common isObjectNull:self.name] || [Common isObjectNull:self.url]) {
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                    [self showToast:@"第三方信息获取失败，请重新授权"];
                    
                    return;
                    
                }
                
                [STDataHandler sendRegisterForThirdParyWithAccountNo:self.uid nickName:self.name headImg:self.url success:^(NSString *success) {
                    
                    if (success.boolValue) {
                        
                        [self regist:self.uid];
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                        
                    });
                    
                }];
                
            }
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    }];
    
}

- (void)regist:(NSString *)loginName {

    [self.dataHandler postSignInWithPassword:nil
                                   loginName:loginName
                          isPostNotification:YES
                            isFromThirdParty:YES
                                        type:self.type
                                     success:^(BOOL success) {
                                         
                                         [Common saveAppBoolDataForKey:@"isFromThirdParty" withObject:YES];
                                         
                                         [Common saveAppDataForKey:@"type" withObject:self.type];
                                         
                                         [STAppDelegate openChat:STUserAccountHandler.userProfile.userId
                                                      completion:^(BOOL success) {
                                                          
                                                          [self textFiledResignFirst];
                                                          
                                                          [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                                          
                                                          [self.tabBarController setSelectedIndex:0];
                                                          
                                                          [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                                                          
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
                                           
                                           //检查手机号是否已经注册
                                           [STDataHandler sendcheckRegisterForMobileWithmobile:self.phoneNumber.text success:^(NSString *success) {
                                               
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                                   if (success.boolValue) {
                                                       
                                                       [self.promptLable setText:@"该手机号已被注册，继续操作将绑定至当前账号"];
                                                       [self.promptLable setTextColor:[UIColor redColor]];
                                                       
                                                   } else {
                                                       
                                                       [self.promptLable setText:@"为了您的账号安全，建议您绑定手机号"];
                                                       [self.promptLable setTextColor:[UIColor blackColor]];
                                                       
                                                   }
                                                   
                                               });
                                            
                                               
                                           } failure:^(NSError *error) {

                                           }];
                                           
                                           
                                       } failure:^(NSString *error) {
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               [self showToast:error];
                                               
                                           });

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
