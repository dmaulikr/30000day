//
//  SignInViewController.m
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "SignInViewController.h"
#import "findPwdViewCtr.h"
//#import "mainViewCtr.h"
//#import "mainToolScrollViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TextFieldCellTableViewCell.h"
#import "LogPwd.h"
//#import "MainTabBarController.h"
//#import "mainToolScrollViewController.h"
#import "SMSVerificationViewController.h"
#import "loginNameVerificationViewController.h"
#import "TKAddressBook.h"

#define HCUSERINFO @"userinfo"

@import HealthKit;

@interface SignInViewController () {
    
    CGFloat textH;
    
}

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic) HKHealthStore *healthStore1;

@property (nonatomic, copy) NSString *str;

@property (nonatomic,strong)UITableView* tableview;

@property (nonatomic,strong)NSMutableArray* userlognamepwd;

@property (nonatomic,assign)CGRect selectedTextFieldRect;

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden=YES;
    
    [self.navigationItem setHidesBackButton:YES];
    
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
    
    _userNameTF.tag=1;
    
    _userPwdTF.tag=2;
    
    [self textFielddidload];
}


#pragma mark - 加载历史记录
-(void)textFielddidload{
    
    [self.userNameTF setDelegate:self];
    
    [self.userPwdTF setDelegate:self];
    
    _userlognamepwd=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"userlognamepwd"]];
    
    if (_userlognamepwd.count>0) {
        
        _tableview=[[UITableView alloc]init];
        
        _tableview.hidden=YES;
        
        [self.view addSubview:_tableview];
        
        _tableview.translatesAutoresizingMaskIntoConstraints=NO;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeWidth relatedBy:0 toItem:self.userNameTF attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeLeft relatedBy:0 toItem:self.userNameTF attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeTop relatedBy:0 toItem:self.userNameTF attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        
        _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableview attribute:NSLayoutAttributeHeight relatedBy:0 toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:132]];
        
        _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        //[_tableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        [_tableview.layer setCornerRadius:8.0];
        
        [_tableview setDelegate:self];
        
        [_tableview setDataSource:self];
        
        _tableview.layer.borderWidth=0.5;
        
        _tableview.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        _tableview.bounces=NO;  //不让上下拉动弹簧效果
    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];

    LogPwd* lp=[LogPwd sharedLogPwd];
    
    if (lp.log!=nil) {
        
        _userNameTF.text=lp.log;
        
        _userPwdTF.text=lp.pwd;
        
    }
}

#pragma mark - 找回密码
-(IBAction)findPwd:(UIButton *)sender {
    
    loginNameVerificationViewController* logvf=[[loginNameVerificationViewController alloc]init];
    
    logvf.navigationItem.title=@"输入账号";
    
    [self.navigationController pushViewController:logvf animated:YES];
}

#pragma mark - 登录
-(IBAction)loginPree:(UIButton *)sender {
    
    NSString * url = @"http://116.254.206.7:12580/M/API/Login?";
    
    url = [url stringByAppendingString:@"LoginName="];
    
    url = [url stringByAppendingString:_userNameTF.text];
    
    url = [url stringByAppendingString:@"&LoginPassword="];
    
    url = [url stringByAppendingString:_userPwdTF.text];
    
    NSMutableString *mUrl=[[NSMutableString alloc] initWithString:url] ;
    
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    
    NSLog(@"%@",jsonStr);
    
    //第三方类库的json解析
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSDictionary * dict = [jsonParser objectWithString:jsonStr error:nil];
    
    NSLog(@"%@",dict);
    
    UserInfo *user = [[UserInfo alloc] init];
    
    [user setValuesForKeysWithDictionary:dict];
    
    user.Birthday = [user.Birthday stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    user.Gender = [NSString stringWithFormat:@"%@",user.Gender];
    
    if([user.Gender  isEqual: @"1"]){
        
        user.Gender = @"男";
        
    }else{
        
        user.Gender = @"女";
    }

    if (dict != nil){
        
        user.isfirstlog=1;
        
        [TKAddressBook shareControl].userInfo = user;
        
        [[NSUserDefaults standardUserDefaults] setObject:_userNameTF.text forKey:@"username"];
        
        [[NSUserDefaults standardUserDefaults] setObject:_userPwdTF.text forKey:@"password"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSMutableArray* userlognamepwd=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"userlognamepwd"]];
        
        NSMutableDictionary* dic=[NSMutableDictionary dictionary];
        
        if (userlognamepwd.count==0) {
            
            [dic setObject:_userNameTF.text forKey:@"logname"];
            
            [dic setObject:_userPwdTF.text forKey:@"logpwd"];
            
            [userlognamepwd addObject:dic];
            
            [[NSUserDefaults standardUserDefaults] setObject:userlognamepwd forKey:@"userlognamepwd"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            NSInteger isexist=1;
            
            for (NSInteger i=0; i<userlognamepwd.count; i++) {
                
                dic=userlognamepwd[i];
                
                if ([[dic objectForKey:@"logname"] isEqualToString:_userNameTF.text]){
                    
                    isexist=0;
                }
                
                if ([[dic objectForKey:@"logname"] isEqualToString:_userNameTF.text] && ![[dic objectForKey:@"logpwd"] isEqualToString:_userPwdTF.text]){
                    
                    NSDictionary* dc=[NSDictionary dictionaryWithObjectsAndKeys:_userNameTF.text,@"logname",_userPwdTF.text,@"logpwd", nil];
                    
                    userlognamepwd[i]=dc;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:userlognamepwd forKey:@"userlognamepwd"];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            
            if (isexist) {
                
                NSDictionary* dc=[NSDictionary dictionaryWithObjectsAndKeys:_userNameTF.text,@"logname",_userPwdTF.text,@"logpwd", nil];
                
                [userlognamepwd addObject:dc];
                
                [[NSUserDefaults standardUserDefaults] setObject:userlognamepwd forKey:@"userlognamepwd"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"登录失败，请确认用户名或密码是否正确" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        NSLog(@"error:%@",jsonStr);
        
    }
}

#pragma mark - 账号密码历史记录tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _userlognamepwd.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary* dic=_userlognamepwd[indexPath.row];
    
    NSString* log=[dic objectForKey:@"logname"];
    TextFieldCellTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"TextCell"];
    if (cell==nil) cell=[[NSBundle mainBundle]loadNibNamed:@"TextFieldCellTableViewCell" owner:self options:nil][0];
    
    UIButton* deletebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [deletebtn setTitle:@"x" forState:UIControlStateNormal];
    [deletebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deletebtn setTag:indexPath.row];
    //[deletebtn setFrame:CGRectMake(170, 0, 30, 44)];
    [deletebtn addTarget:self action:@selector(deletebt:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:deletebtn];
    deletebtn.translatesAutoresizingMaskIntoConstraints=NO;
    //[cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn]-20-|" options:NSLayoutFormatAlignAllRight metrics:nil views:@{@"btn":deletebtn}]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:deletebtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    cell.textLabel.text=log;
    return cell;
}
-(void)deletebt:(UIButton*)sender{
    
    [_userlognamepwd removeObjectAtIndex:sender.tag];
    [[NSUserDefaults standardUserDefaults] setObject:_userlognamepwd forKey:@"userlognamepwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_tableview reloadData];
    if (_userlognamepwd.count==0) {
        [_tableview removeFromSuperview];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[_userNameTF resignFirstResponder];
    NSDictionary* dic=_userlognamepwd[indexPath.row];
    NSString* log=[dic objectForKey:@"logname"];
    NSString* pass=[dic objectForKey:@"logpwd"];
    _userNameTF.text=log;
    _userPwdTF.text=pass;
    _tableview.hidden=YES;
}

#pragma mark - 键盘的代理方法以及键盘消失的方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.lockPassWord.hidden=NO;
    if (textField.tag==1) {
        _tableview.hidden=NO;
        textH=self.tableview.frame.size.height;
    }else{
        textH=0;
    }
    self.selectedTextFieldRect=textField.frame;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //[_tableview setFrame:CGRectMake(50, -330, 200, 200)];
    if (textField.tag) {
        _tableview.hidden=YES;
    }
    self.lockPassWord.hidden=YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    if (textField.tag) {
        _userPwdTF.text=@"";
    }
    //可以设置在特定条件下才允许清除内容
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.userNameTF resignFirstResponder];
    
    [self.userPwdTF resignFirstResponder];
    
}

//#pragma mark - 当键盘出现或改变时调用
//- (void)keyboardWillShow:(NSNotification *)notification{
//    //获取键盘高度，在不同设备上，以及中英文下是不同的
//    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
//    CGFloat offset = (self.selectedTextFieldRect.origin.y+self.selectedTextFieldRect.size.height+textH) - (self.view.frame.size.height - kbHeight);
//    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
//    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    //将视图上移计算好的偏移
//    if(offset > 0) {
//        [UIView animateWithDuration:duration animations:^{
//            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//        }];
//    }
//}
//#pragma mark - 当键退出时调用
//- (void)keyboardWillHide:(NSNotification *)aNotification{
//    // 键盘动画时间
//    double duration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    //视图下沉恢复原状
//    [UIView animateWithDuration:duration animations:^{
//        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    }];
//}
//#pragma mark - 视图消失时释放通知
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:YES];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}

-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)touchDown:(UIButton *)sender{
    
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
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    //[backItem setImage:[UIImage imageNamed:@"返回.png"]];
//    
//    [backItem setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    UIImage* image = [UIImage imageNamed:@"返回.png"];
//    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    //[backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
//    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:sms animated:YES];
    
}

@end
