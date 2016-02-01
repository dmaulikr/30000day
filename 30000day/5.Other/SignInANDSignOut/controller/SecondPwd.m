//
//  SecondPwd.m
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "SecondPwd.h"
#import "UpdateLogPwd.h"
#import "security.h"

@interface SecondPwd ()
@property (nonatomic, strong) UISwipeGestureRecognizer *RightSwipeGestureRecognizer;
@property (nonatomic, strong) security* s;
@end

@implementation SecondPwd

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.s = [security shareControl];
    
    [self loadbtntitle];
    
}

- (void)loadbtntitle {

    for (int i=1; i<=3; i++) {
        
        NSString* str=[NSString stringWithFormat:@"Q%d",i];
        
        NSString* str1=[NSString stringWithFormat:@"-w%d",i];
        
        if ([self.s.securityDic[str] isEqualToString:str1]) {
            
            continue;
            
        } else {
            
            NSString* str=[NSString stringWithFormat:@"Q%d",i];
            
            if (i==1) {
                
                [self.PBbtn1 setTitle:self.s.securityDic[str] forState:UIControlStateNormal];
                
            } if(i==2) {
                
                [self.PBbtn2 setTitle:self.s.securityDic[str] forState:UIControlStateNormal];
                
            } if(i==3) {
                
                [self.PBbtn3 setTitle:self.s.securityDic[str] forState:UIControlStateNormal];
            }
        }
    }
    if (self.PBbtn1.titleLabel.text==nil) {
        
        self.PBbtn1.hidden = YES;
        
        self.ASText1.hidden = YES;
        
    }
    if (self.PBbtn2.titleLabel.text == nil) {
        
        self.PBbtn2.hidden = YES;
        
        self.ASText2.hidden = YES;
    }
    if (self.PBbtn3.titleLabel.text == nil) {
        
        self.PBbtn3.hidden = YES;
        
        self.ASText3.hidden = YES;
    }
}

- (IBAction)submitbtn:(UIButton *)sender {
 
    NSString *URLString=@"http://116.254.206.7:12580/M/API/ValidateQuestion?";
    
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
    NSString *p1 = [[NSString alloc] init];
    
    NSString *p2 = [[NSString alloc] init];
    NSString *p3 = [[NSString alloc]init];
    
    NSString* s1=[[NSString alloc]init];
    NSString* s2=[[NSString alloc]init];
    NSString* s3=[[NSString alloc]init];
    
    if (_PBbtn1.titleLabel.text==nil) {
        p1=@"-w1";
    }else{
        p1=_PBbtn1.titleLabel.text;
    }
    if (_PBbtn2.titleLabel.text==nil) {
        p2=@"-w2";
    }else{
        p2=_PBbtn2.titleLabel.text;
    }
    if (_PBbtn3.titleLabel.text==nil) {
        p3=@"-w3";
    }else{
        p3=_PBbtn3.titleLabel.text;
    }

    if (_ASText1.text==nil ||[_ASText1.text isEqualToString:@""]) {
        s1=@"-m1";
    }else{
        s1=_ASText1.text;
    }
    if (_ASText2.text==nil ||[_ASText2.text isEqualToString:@""]) {
        s2=@"-m2";
    }else{
        s2=_ASText2.text;
    }
    if (_ASText3.text==nil ||[_ASText3.text isEqualToString:@""]) {
        s3=@"-m3";
    }else{
        s3=_ASText3.text;
    }
    
    
    NSString *param=[NSString stringWithFormat:@"LoginName=%@&q1=%@&a1=%@&q2=%@&a2=%@&q3=%@&a3=%@",self.s.loginName,
                     p1,s1,
                     p2,s2,
                     p3,s3];
    NSLog(@"%@",param);
    
    NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"post"];
    [request setURL:URL];
    [request setHTTPBody:postData];
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"验证失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else{
        NSString* str=[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
        if ([str isEqualToString:@"-1"]) {
            UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"错误提示" message:@"验证错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingAllowFragments error:nil];
            if ([dic[@"loginName"] isEqualToString:self.s.loginName]) {
                UpdateLogPwd* uplog=[UpdateLogPwd sharedLogPwd];
                [uplog setLog:dic[@"loginName"]];
                [uplog setPwd:dic[@"loginPassword"]];
                [uplog setUserID:dic[@"UserID"]];
                updatePwdViewCtr* uppwd=[[updatePwdViewCtr alloc]init];
                uppwd.navigationItem.title=@"新密码";

                [self.navigationController pushViewController:uppwd animated:YES];
                
                NSLog(@"%@",dic);
            }
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.ASText1 resignFirstResponder];
    [self.ASText2 resignFirstResponder];
    [self.ASText3 resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
