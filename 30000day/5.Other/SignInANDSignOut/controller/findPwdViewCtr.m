//
//  findPwdViewCtr.m
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "findPwdViewCtr.h"
#import "updatePwdViewCtr.h"
#import "UpdateLogPwd.h"
#import "security.h"
#define IdentityCount 10

@interface findPwdViewCtr ()
{
    int count;
}
@property (nonatomic) NSTimer *timer;
@property (nonatomic, strong) UISwipeGestureRecognizer *RightSwipeGestureRecognizer;
@end

@implementation findPwdViewCtr


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"找回密码";
    
    self.nextBtn.layer.cornerRadius=6;
    
    self.nextBtn.layer.masksToBounds=YES;
    
}

- (IBAction)submitBtn:(UIButton *)sender {
    if ([self.phoneText.text isEqualToString:@" "] || self.phoneText.text==nil) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if ([self.ckText.text isEqualToString:@" "] || self.ckText.text==nil) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的验证码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //security* s=[security shareControl];

    NSString * url = @"http://116.254.206.7:12580/M/API/ValidateSmsCode?";
    url=[url stringByAppendingString:@"phoneNumber="];
    url=[url stringByAppendingString:self.phoneText.text];
    url=[url stringByAppendingString:@"&validateCode="];
    url=[url stringByAppendingString:self.ckText.text];
    
    NSMutableString *mUrl=[[NSMutableString alloc] initWithString:url] ;
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@",jsonStr);
    
    if ([jsonStr isEqualToString:@"1"]) {
        updatePwdViewCtr *upd = [[updatePwdViewCtr alloc] init];
        upd.navigationItem.title = @"新密码";
        [self.navigationController pushViewController:upd animated:YES];

    }else{
//        if ([dic[@"LoginName"] isEqualToString:s.loginName]){
//            UpdateLogPwd* uplog=[UpdateLogPwd sharedLogPwd];
//            [uplog setLog:dic[@"LoginName"]];
//            [uplog setPwd:dic[@"LoginPassword"]];
//            [uplog setUserID:dic[@"UserID"]];
        
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"验证失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ckclick:(UIButton *)sender {
    // NSObject多线程
    //[self performSelectorInBackground:@selector(CountDown) withObject:nil];
    count = IdentityCount;
    self.ckbtn.enabled = NO;
    [self.ckbtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Down) userInfo:nil repeats:YES];
    //[_timer fire];
}

-(void)CountDown
{
    count = IdentityCount;
    [self.ckbtn setTitle:[NSString stringWithFormat:@"%i秒后重发",IdentityCount] forState:UIControlStateNormal];
    self.ckbtn.enabled = NO;
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Down) userInfo:nil repeats:YES];
    [_timer fire];
}

-(void)Down
{
    [self.ckbtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
    if (count == -1) {
        self.ckbtn.enabled = YES;
        [self.ckbtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        count = IdentityCount;
        [_timer invalidate];
    }
}


- (IBAction)ckbtnclick:(UIButton *)sender {
    if ([self.phoneText.text isEqualToString:@" "] || self.phoneText.text==nil) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString * url = @"http://116.254.206.7:12580/M/API/SendCode?";
    url = [url stringByAppendingString:@"phoneNumber="];
    url = [url stringByAppendingString:self.phoneText.text];

    NSMutableString *mUrl=[[NSMutableString alloc] initWithString:url];
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"----%@",jsonStr);

    if ([jsonStr isEqualToString:@"1"]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"发送成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:[NSString stringWithFormat:@"验证失败:%@",jsonStr] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        NSLog(@"error:%@",jsonStr);
    }

}


@end
