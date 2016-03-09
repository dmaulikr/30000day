//
//  EmailBindViewController.m
//  30000day
//
//  Created by wei on 16/3/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "EmailBindViewController.h"
#import "EmailBindViewSuccessAndFailController.h"

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
    
    if (self.emailTextFiled.text != nil) {
        
        [self.dataHandler sendUploadUserSendEmailWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] emailString:self.emailTextFiled.text success:^(BOOL success) {
            
            EmailBindViewSuccessAndFailController *controller = [[EmailBindViewSuccessAndFailController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.success=success;
            [self.navigationController pushViewController:controller animated:YES];
            
        } failure:^(NSError *error) {
            
            EmailBindViewSuccessAndFailController *controller = [[EmailBindViewSuccessAndFailController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.success=NO;
            [self.navigationController pushViewController:controller animated:YES];
            
        }];
        
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
