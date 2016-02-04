//
//  loginNameVerificationViewController.m
//  30000天
//
//  Created by wei on 16/1/16.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "loginNameVerificationViewController.h"
#import "ChoicePwd.h"
#import "SecondPwd.h"
#import "security.h"

@interface loginNameVerificationViewController ()

@end

@implementation loginNameVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"输入账号";
    
    [self.submitBtn addTarget:self action:@selector(nextCP) forControlEvents:UIControlEventTouchUpInside];
    
    self.submitBtn.layer.cornerRadius=6;
    
    self.submitBtn.layer.masksToBounds=YES;
    
}

- (void)nextCP {
    
    if (self.loginNameText.text==nil) {
        
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"请填写需要找回密码的账号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        return;
    }
    
    NSString *URLString=@"http://116.254.206.7:12580/M/API/GetValidateQuestion?";
    
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
    NSString *param=[NSString stringWithFormat:@"LoginName=%@",self.loginNameText.text];
    
    NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"post"];
    
    [request setURL:URL];
    
    [request setHTTPBody:postData];
    
    NSURLResponse * response;
    
    NSError * error;
    
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"验证失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        if ([[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding] isEqualToString:@"-1"]) {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"请正确填写账号" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        NSMutableDictionary* dic=[NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingAllowFragments error:nil];
        if ( [dic[@"Q1"] isEqualToString:@"-w1"] &&
            [dic[@"Q2"] isEqualToString:@"-w2"] &&
            [dic[@"Q3"] isEqualToString:@"-w3"]) {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"您未保存过任何密保信息，建议您手机验证找回密码。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }else{            
            security* s=[security shareControl];
            s.securityDic=dic;
            s.loginName=self.loginNameText.text;
            
            ChoicePwd* cp=[[ChoicePwd alloc]init];
            cp.navigationItem.title=@"验证方式";
            [self.navigationController pushViewController:cp animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.loginNameText resignFirstResponder];
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
