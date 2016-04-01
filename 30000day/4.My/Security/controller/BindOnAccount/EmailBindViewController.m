//
//  EmailBindViewController.m
//  30000day
//
//  Created by wei on 16/3/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "EmailBindViewController.h"
#import "EmailBindViewSuccessAndFailController.h"
#import "MTProgressHUD.h"

@interface EmailBindViewController ()<UITextFieldDelegate>

@end

@implementation EmailBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submit:(UIButton *)sender {
    
        if ( ! [Common isObjectNull:self.emailTextFiled.text] ) {
            
            if ([[STUserAccountHandler userProfile].email isEqualToString:@"未绑定邮箱"] || [STUserAccountHandler userProfile].email == nil ) {
            
                [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
                [self.dataHandler sendUploadUserSendEmailWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] emailString:self.emailTextFiled.text success:^(BOOL success) {
                    
                    if (success) {
                        
                        //获取用户绑定邮箱
                        [self.dataHandler sendVerificationUserEmailWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] success:^(NSDictionary *verificationDictionary) {
                            
                            EmailBindViewSuccessAndFailController *controller = [[EmailBindViewSuccessAndFailController alloc] init];
                            controller.hidesBottomBarWhenPushed = YES;
                            
                            if ([Common isObjectNull:verificationDictionary]){
                                
                                [STUserAccountHandler userProfile].email = @"未绑定邮箱";
                                
                                controller.success=success;
                                
                            } else {
                                
                                [STUserAccountHandler userProfile].email = verificationDictionary[@"email"];
                                
                                controller.errorString = @"您已经绑定了邮箱，无需再次绑定";
                            }
                            
                            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                            [self.navigationController pushViewController:controller animated:YES];

                            
                        } failure:^(NSError *error) {
                            NSLog(@"获取绑定邮箱失败");
                        }];
                        
                    }
                    
                } failure:^(NSError *error) {
                    
                    EmailBindViewSuccessAndFailController *controller = [[EmailBindViewSuccessAndFailController alloc] init];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.success=NO;
                    controller.errorString = error.userInfo[@"NSLocalizedDescription"];
            
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
                    [self.navigationController pushViewController:controller animated:YES];
                    
                }];
                
            } else {
            
                [self showToast:@"您已经绑定了邮箱，无需再次绑定"];
                
            }

        
        } else {
            
            [self showToast:@"邮箱不能为空"];
            
        }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self submit:nil];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTextFiled resignFirstResponder];
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
