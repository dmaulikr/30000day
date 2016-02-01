//
//  updatePwdViewCtr.m
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "updatePwdViewCtr.h"
#import "UpdateLogPwd.h"
#import "SignInViewController.h"

@interface updatePwdViewCtr ()

@property (nonatomic,strong)NSString* logname;

@property (nonatomic,strong)NSString* logpwd;

@property (nonatomic,strong)NSString* Userid;

@end

@implementation updatePwdViewCtr


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.subimitBtn.layer.cornerRadius=6;
    self.subimitBtn.layer.masksToBounds=YES;
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backbt)];
}


- (IBAction)updateBtn:(UIButton *)sender {
    
    if (![_oneNewPass.text isEqualToString:_twoNewPass.text]) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"错误提示" message:@"输入有误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
    
        UpdateLogPwd* uplog=[UpdateLogPwd sharedLogPwd];
        NSString * url = @"http://116.254.206.7:12580/M/API/UpdateProfile?";
        //字符串的拼接
        url = [url stringByAppendingString:@"UserID="];
        url = [url stringByAppendingString:uplog.UserID];
        url = [url stringByAppendingString:@"&LoginName="];
        url = [url stringByAppendingString:uplog.log];
        url = [url stringByAppendingString:@"&LoginPassword="];
        url = [url stringByAppendingString:uplog.pwd];
        url = [url stringByAppendingString:@"&newPassword="];
        url = [url stringByAppendingString:_twoNewPass.text];
        //*mUrl 就是拼接好的请求地址
        NSMutableString *mUrl=[[NSMutableString alloc] initWithString:url];
        NSError *error;
        
        NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"----%@",jsonStr);
        //成功就是1
        if ([jsonStr isEqualToString:@"1"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert setTag:1];
            [alert show];
            
        }else
        {
            //修改失败弹出失败信息
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:[NSString stringWithFormat:@"修改失败:%@",jsonStr] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            NSLog(@"error:%@",jsonStr);
        }
    }
    
}
-(void)backbt
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (buttonIndex==0) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
