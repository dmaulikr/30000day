//
//  SignInViewController.m
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "SignInViewController.h"
#import "findPwdViewCtr.h"
#import <CoreLocation/CoreLocation.h>
#import "TextFieldCellTableViewCell.h"
#import "LogPwd.h"
#import "SMSVerificationViewController.h"
#import "loginNameVerificationViewController.h"
#import "TKAddressBook.h"
#import "UserProfile.h"

#define HCUSERINFO @"userinfo"

@import HealthKit;

@interface SignInViewController () {
    
    CGFloat textH;
    
}

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic) HKHealthStore *healthStore1;

@property (nonatomic, copy) NSString *str;

@property (nonatomic,strong)UITableView* tableview;

@property (nonatomic,strong)NSMutableArray *userlognamepwd;

@property (nonatomic,assign)CGRect selectedTextFieldRect;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;

    self.navigationItem.title = @"登录";
    
    self.textSubView.layer.borderWidth=1.0;
    
    self.textSubView.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.sina.layer.borderWidth=1.0;
    
    self.sina.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.sina.layer.cornerRadius = 6;
    
    self.sina.layer.masksToBounds = YES;
    
    self.qq.layer.borderWidth=1.0;
    
    self.qq.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.qq.layer.cornerRadius = 6;
    
    self.qq.layer.masksToBounds = YES;
    
    self.water.layer.borderWidth=1.0;
    
    self.water.layer.borderColor=[UIColor colorWithRed:214.0/255 green:214.0/255.0 blue:214.0/255 alpha:1.0].CGColor;
    
    self.water.layer.cornerRadius = 6;
    
    self.water.layer.masksToBounds = YES;
    
    self.loginBtn.layer.cornerRadius=6;
    
    self.loginBtn.layer.masksToBounds=YES;
    
    [self.lockPassWord addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    [self.lockPassWord addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    _userNameTF.tag = 1;
    
    _userPwdTF.tag = 2;
    
    [self textFielddidload];
}

#pragma mark - 加载历史记录
-(void)textFielddidload {
    
    [self.userNameTF setDelegate:self];
    
    [self.userPwdTF setDelegate:self];
    
    _userlognamepwd = [UserAccountHandler shareUserAccountHandler].lastUserAccountArray;
    
    if (_userlognamepwd.count > 0) {
        
        _tableview = [[UITableView alloc]init];
        
        _tableview.hidden = YES;
        
        [self.view addSubview:_tableview];
        
        _tableview.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeWidth relatedBy:0 toItem:self.userNameTF attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.userNameTF attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.userNameTF attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:132]];
        
        _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [_tableview.layer setCornerRadius:8.0];
        
        [_tableview setDelegate:self];
        
        [_tableview setDataSource:self];
        
        _tableview.layer.borderWidth = 0.5;
        
        _tableview.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        _tableview.bounces = NO;  //不让上下拉动弹簧效果
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    
   self.navigationItem.leftBarButtonItem = backItem;
    
    LogPwd *lp = [LogPwd sharedLogPwd];
    
    if (lp.log != nil) {
        
        _userNameTF.text = lp.log;
        
        _userPwdTF.text = lp.pwd;
        
    }
}

#pragma mark - 找回密码
- (IBAction)findPwd:(UIButton *)sender {
    
    loginNameVerificationViewController *logvf = [[loginNameVerificationViewController alloc] init];

    [self.navigationController pushViewController:logvf animated:YES];
}

#pragma mark - 登录
- (IBAction)signInButtonClick:(UIButton *)sender {
    
    [self.dataHandler postSignInWithPassword:_userPwdTF.text
                                 phoneNumber:_userNameTF.text
                                     success:^(id responseObject) {
        
                                 NSError *localError = nil;
                     
                                 id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                     
                                  NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                  
                                         if (recvDic) {
                                             
                                             UserInfo *userInfo = [[UserInfo alloc] init];
                                             
                                             [userInfo setValuesForKeysWithDictionary:recvDic];
                                             
                                             //保存用户上次登录的账号,同时也会更新用户信息
                                             [[UserAccountHandler shareUserAccountHandler] saveUserAccountWithModel:userInfo];
                                             
                                             [self dismissViewControllerAnimated:YES completion:nil];
                                             
                                         } else {
                                             
                                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败，请确认用户名或密码是否正确" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             
                                             [alert show];
                                             
                                         }
                                 
                                         
    } failure:^(LONetError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败，请确认用户名或密码是否正确" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }];
}

#pragma mark - 账号密码历史记录tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _userlognamepwd.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = _userlognamepwd[indexPath.row];
    
    NSString *log = [dic objectForKey:KEY_SIGNIN_USER_NAME];
    
    TextFieldCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
    
    if (cell == nil) cell=[[NSBundle mainBundle]loadNibNamed:@"TextFieldCellTableViewCell" owner:self options:nil][0];
    
    UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [deletebtn setTitle:@"x" forState:UIControlStateNormal];
    
    [deletebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [deletebtn setTag:indexPath.row];
    
    [deletebtn addTarget:self action:@selector(deletebt:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell addSubview:deletebtn];
    
    deletebtn.translatesAutoresizingMaskIntoConstraints=NO;

    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    cell.textLabel.text = log;
    
    return cell;
}

- (void)deletebt:(UIButton*)sender {
    
    [_userlognamepwd removeObjectAtIndex:sender.tag];
    
    [[NSUserDefaults standardUserDefaults] setObject:_userlognamepwd forKey:@"userlognamepwd"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_tableview reloadData];
    
    if (_userlognamepwd.count == 0) {
        
        [_tableview removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = _userlognamepwd[indexPath.row];
    
    NSString *log=[dic objectForKey:KEY_SIGNIN_USER_NAME];
    
    NSString *pass = [dic objectForKey:KEY_SIGNIN_USER_PASSWORD];
    
    _userNameTF.text = log;
    
    _userPwdTF.text = pass;
    
    _tableview.hidden = YES;
}

#pragma mark - 键盘的代理方法以及键盘消失的方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.lockPassWord.hidden = NO;
    
    if (textField.tag == 1) {
        
        _tableview.hidden=NO;
        
        textH=self.tableview.frame.size.height;
        
    } else {
        
        textH=0;
    }
    
    self.selectedTextFieldRect=textField.frame;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag) {
        
        _tableview.hidden = YES;
        
    }
    
    self.lockPassWord.hidden=YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField.tag) {
        
        _userPwdTF.text=@"";
    }
    //可以设置在特定条件下才允许清除内容
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.userNameTF resignFirstResponder];
    
    [self.userPwdTF resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
}

- (void)touchDown:(UIButton *)sender {
    
    [sender setBackgroundImage:[UIImage imageNamed:@"DisplayPassword.png"] forState:UIControlStateNormal];
    
    [self.userPwdTF setSecureTextEntry:NO];
}

-(void)touchUpInside:(UIButton *)sender{
    
    [sender setBackgroundImage:[UIImage imageNamed:@"hidePassword.png"] forState:UIControlStateNormal];
    
    [self.userPwdTF setSecureTextEntry:YES];
}

#pragma mark - 跳转注册
- (IBAction)regitView:(UIButton *)sender {
    
    SMSVerificationViewController* sms = [[SMSVerificationViewController alloc] init];
    
    sms.navigationItem.title = @"闪电注册";
    
    [self.navigationController pushViewController:sms animated:YES];
    
}

@end
