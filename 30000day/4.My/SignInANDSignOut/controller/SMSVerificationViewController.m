//
//  SMSVerificationViewController.m
//  30000天
//
//  Created by wei on 16/1/12.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "SMSVerificationViewController.h"
#import "regitViewCtr.h"
#import "AFNetworking.h"

#define IdentityCount 60

@interface SMSVerificationViewController ()<UITextFieldDelegate> {
    
    int count;
}

@property (nonatomic) NSTimer *timer;

@property (nonatomic,assign)CGRect selectedTextFieldRect;

@end

@implementation SMSVerificationViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.phoneNumber setDelegate:self];
    
    [self.sms setDelegate:self];
    
    self.textSubView.layer.borderWidth=1.0;
    
    self.textSubView.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.nextBtn.layer.cornerRadius=6;
    
    self.nextBtn.layer.masksToBounds=YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 下一步
- (IBAction)nextBtn:(UIButton *)sender {
    NSString *URLString=@"http://116.254.206.7:12580/M/API/ValidateSmsCode";
    //NSDictionary * dict = @{@"phoneNumber":self.phoneNumber.text,@"validateCode":self.sms.text};
    
    NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
    NSString *param=[NSString stringWithFormat:@"phoneNumber=%@&validateCode=%@",self.phoneNumber.text,self.sms.text];
    NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:URL];
    [request setHTTPBody:postData];
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if ([[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding] intValue]==1) {
            regitViewCtr* regit=[[regitViewCtr alloc]init];
            regit.PhoneNumber=self.phoneNumber.text;
            regit.navigationItem.title=@"闪电注册";
            [self.navigationController pushViewController:regit animated:YES];
    }else{
        NSLog(@"error : %@",[error localizedDescription]);
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:nil message:@"验证失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        }

}

//-(void) requestPostByAFNetWorking:(NSString*)urlString para:(NSDictionary*)dict {
//
//    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSString* backString=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if ([backString isEqualToString:@"1"]) {
//            regitViewCtr* regit=[[regitViewCtr alloc]init];
//            regit.navigationItem.title=@"闪电注册";
//            [self.navigationController pushViewController:regit animated:YES];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
//}
#pragma mark - 短信验证 smsBtn倒计时
- (IBAction)smsVerificationBtn:(id)sender {
    if (self.phoneNumber.text==nil || [self.phoneNumber.text isEqualToString:@""]) {
        return;
    }
    NSString * url = @"http://116.254.206.7:12580/M/API/SendCode?";
    url = [url stringByAppendingString:@"&phoneNumber="];
    url = [url stringByAppendingString:self.phoneNumber.text];
    
    NSMutableString *mUrl=[[NSMutableString alloc] initWithString:url];
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    if ([jsonStr isEqualToString:@"1"]){
        count=IdentityCount;
        _smsBtn.enabled = NO;
        [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
        _timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Down) userInfo:nil repeats:YES];
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"验证失败:%@",jsonStr] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }

}
-(void)CountDown{
    count = IdentityCount;
    [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",IdentityCount] forState:UIControlStateNormal];
    _smsBtn.enabled = NO;
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Down) userInfo:nil repeats:YES];
    [_timer fire];
}
-(void)Down{
    [_smsBtn setTitle:[NSString stringWithFormat:@"%i秒后重发",count--] forState:UIControlStateNormal];
    if (count == -1) {
        _smsBtn.enabled = YES;
        [_smsBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        count = IdentityCount;
        [_timer invalidate];
    }
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
