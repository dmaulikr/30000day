//
//  MainPageViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MainPageViewController.h"
#import "SignInViewController.h"

@interface MainPageViewController ()

@property (nonatomic,strong) UserInfo* userinfo;

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    _userinfo=[TKAddressBook shareControl].userInfo;
    
    if (_userinfo.isfirstlog==0) {
        
        NSString *logname = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        
        if (logname == nil || password == nil) {
            
            SignInViewController *logview = [[SignInViewController alloc] init];
            
            [self.navigationController pushViewController:logview animated:YES];
            
            return;
            
        } else {
            
            [self loginPree];
            
        }
        
    } else if (_userinfo.isfirstlog==1){
        
//      [self scrollViewWithConteroll];
        
        _userinfo.isfirstlog=-1;
    }
    
    self.tabBarController.tabBar.hidden=NO;
}

#pragma  mark -根据用户最近登录的账号自动登录
- (void)loginPree {
    
    NSString* logname=[[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    
    NSString* password=[[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
    
    NSString * url = @"http://116.254.206.7:12580/M/API/Login?";
    
    url = [url stringByAppendingString:@"LoginName="];
    
    url = [url stringByAppendingString:logname];
    
    url = [url stringByAppendingString:@"&LoginPassword="];
    
    url = [url stringByAppendingString:password];
    
    NSMutableString *mUrl=[[NSMutableString alloc] initWithString:url];
    
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSDictionary * dict = [jsonParser objectWithString:jsonStr error:nil];
    
    NSLog(@"%@",dict);
    
    UserInfo *user = [[UserInfo alloc] init];
    
    [user setValuesForKeysWithDictionary:dict];
    
    user.Birthday = [user.Birthday stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    user.Gender = [NSString stringWithFormat:@"%@",user.Gender];
    
    if ([user.Gender  isEqual: @"1"]) {
        
        user.Gender = @"男";
        
    } else {
        
        user.Gender = @"女";
    }
    
    if (dict != nil) {
        
        user.isfirstlog=-1;
        
        [TKAddressBook shareControl].userInfo = user;
        
        _userinfo=user;
        
//       [self getMyFriends];
        
//       [self scrollViewWithConteroll];
        
    } else {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"身份信息过期，请重新登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert setTag:-1];
        
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
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
