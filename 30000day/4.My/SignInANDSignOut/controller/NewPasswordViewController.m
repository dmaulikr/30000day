//
//  updatePwdViewCtr.m
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "NewPasswordViewController.h"
#import "UpdateLogPwd.h"
#import "SignInViewController.h"

@interface NewPasswordViewController ()

@property (nonatomic,strong) NSString *logname;

@property (nonatomic,strong) NSString *logpwd;

@property (nonatomic,strong) NSString *Userid;

@property (weak, nonatomic) IBOutlet UITextField *oneNewPass;

@property (weak, nonatomic) IBOutlet UITextField *twoNewPass;

@property (weak, nonatomic) IBOutlet UIButton *subimitBtn;

@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新密码";
    
    self.subimitBtn.layer.cornerRadius = 6;
    
    self.subimitBtn.layer.masksToBounds = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
}

- (IBAction)updateBtn:(UIButton *)sender {
    
    if (![_oneNewPass.text isEqualToString:_twoNewPass.text]) {
        
        [self showToast:@"两次输入的密码不一致"];
        
    } else {
    
     //开始修改密码
        if (self.type) {
            [self.dataHandler sendSecurityQuestionUptUserPwdBySecu:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] token:self.mobileToken password:self.oneNewPass.text success:^(BOOL success) {
                
                if (success) {
                    [self showToast:@"密码修改成功"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
            } failure:^(LONetError *error) {
                
                [self showToast:@"密码修改失败"];
                
            }];
            
        }else{
            
            [self.dataHandler sendUpdateUserPasswordWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] mobile:self.mobile mobileToken:self.mobileToken password:self.oneNewPass.text success:^(BOOL success) {
                
                [self showToast:@"密码修改成功"];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            } failure:^(NSError *error) {
                
                [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
                
            }];
        
        }
    }
}

- (void)cancelAction {
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}


@end
