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
        
        NSString* logname=[[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
        
        NSString* password=[[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
        
        if (logname==nil || password==nil) {
            
            SignInViewController *logview = [[SignInViewController alloc] init];
            
            [self.navigationController pushViewController:logview animated:YES];
            
            return;
            
        } else {
            
//            [self loginPree];
            
        }
        
    } else if (_userinfo.isfirstlog==1){
        
//      [self scrollViewWithConteroll];
        
        _userinfo.isfirstlog=-1;
    }
    
    self.tabBarController.tabBar.hidden=NO;
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
