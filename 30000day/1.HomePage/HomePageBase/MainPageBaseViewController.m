//
//  MainPageViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MainPageBaseViewController.h"
#import "SignInViewController.h"
#import "MainPageViewController.h"
#import "PersonViewController.h"
#import "MessageViewController.h"
#import "CalendarViewController.h"

@interface MainPageBaseViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UserInfo *userinfo;

@property (nonatomic,strong) UIButton *mainPageButton;//主页

@property (nonatomic,strong) UIButton *personButton;//自己人

@property (nonatomic,strong) UIButton *newsButton;//消息

@property (nonatomic,strong) UIButton *moreAgeButton;//天龄日历

@property (nonatomic,strong) UIView *buttonParentView;//顶部按钮的父视图

@property (nonatomic,strong) UIView *bottomScrollView;//滚动的小视图

@end

@implementation MainPageBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _userinfo = TKAddressBookManager.userInfo;
    
    if (_userinfo.isfirstlog == 0) {
        
        NSString *logname = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        
        if (logname == nil || password == nil) {
            
            SignInViewController *logview = [[SignInViewController alloc] init];
            
            [self.navigationController pushViewController:logview animated:YES];
            
            return;
            
        } else {
            
            [self loginPree];
            
        }
        
    } else if (_userinfo.isfirstlog == 1) {
        
        //初始化UI界面
         [self configUI];
        
        _userinfo.isfirstlog = -1;
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    _userinfo = TKAddressBookManager.userInfo;
    
    if (_userinfo.isfirstlog == 0) {
        
        NSString *logname = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        
        if (logname == nil || password == nil) {
            
            SignInViewController *logview = [[SignInViewController alloc] init];
            
            [self.navigationController pushViewController:logview animated:YES];
            
            return;
            
        } else {
            
            [self loginPree];
            
        }
        
    } else if (_userinfo.isfirstlog == 1) {
        
        //初始化UI界面
        [self configUI];
        
        _userinfo.isfirstlog = -1;
        
    }
    
    self.tabBarController.tabBar.hidden=NO;
}

#pragma  mark -根据用户最近登录的账号自动登录
- (void)loginPree {
    
    NSString *logname = [[NSUserDefaults standardUserDefaults]stringForKey:@"username"];
    
    NSString *password = [[NSUserDefaults standardUserDefaults]stringForKey:@"password"];
    
    NSString *url = @"http://116.254.206.7:12580/M/API/Login?";
    
    url = [url stringByAppendingString:@"LoginName="];
    
    url = [url stringByAppendingString:logname];
    
    url = [url stringByAppendingString:@"&LoginPassword="];
    
    url = [url stringByAppendingString:password];
    
    NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    
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
        
        user.isfirstlog = -1;
        
        TKAddressBookManager.userInfo = user;
        
        _userinfo = user;
        
        //为自己的人界面获取到所有好友列表数据
        [self getMyFriends];
        
        //初始化UI界面
       [self configUI];
        
    } else {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"身份信息过期，请重新登录。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert setTag:-1];
        
        [alert show];
    }
}

- (void)getMyFriends {
    
    NSString * url = @"http://116.254.206.7:12580/M/API/GetMyFriends?";
    
    url = [url stringByAppendingString:@"LoginName="];
    
    url = [url stringByAppendingString:_userinfo.LoginName];
    
    url = [url stringByAppendingString:@"&LoginPassword="];
    
    url = [url stringByAppendingString:_userinfo.LoginPassword];
    
    NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url];
    
    NSError *error;
    
    NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSDictionary * dict = [jsonParser objectWithString:jsonStr error:nil];
    
    NSLog(@"%@",dict);
    
    if ( dict!= nil) {
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSDictionary *dic in dict) {
            
            FriendListInfo *ff = [[FriendListInfo alloc] init];
            
            [ff setValuesForKeysWithDictionary:dic];
            
            [array addObject:ff];
        }
        
        UserInfo *user = [TKAddressBook shareControl].userInfo;
        
        user.friendsArray = array;
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

#pragma mark ----初始化UI界面
- (void)configUI {
    
    self.tabBarController.tabBar.hidden=NO;
    //设置子控制器
    MainPageViewController *mainPageController = [[MainPageViewController alloc] init];
    
    PersonViewController   *personViewController = [[PersonViewController alloc] init];
    
    MessageViewController  *messageViewController = [[MessageViewController alloc] init];
    
    CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
    
    [self addChildViewController:mainPageController];
    
    [self addChildViewController:personViewController];
    
    [self addChildViewController:messageViewController];
    
    [self addChildViewController:calendarViewController];
    
    [_scrollView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
   
    UIView *mainView = mainPageController.view;
    
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *personView = personViewController.view;
    
    personView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *messageView = messageViewController.view;
    
     messageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *calendarView  = calendarViewController.view;
    
    calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_scrollView addSubview:mainView];
    
    [_scrollView addSubview:personView];
    
    [_scrollView addSubview:messageView];
    
    [_scrollView addSubview:calendarView];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view(w)]" options:0 metrics:@{@"w":@(SCREEN_WIDTH)} views:@{@"view":mainView}]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(h)]" options:0 metrics:@{@"h":@(SCREEN_HEIGHT)} views:@{@"view":mainView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-x-[view(w)]" options:0 metrics:@{@"x":@(1*SCREEN_WIDTH),@"w":@(SCREEN_WIDTH)} views:@{@"view":personView}]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(h)]" options:0 metrics:@{@"h":@(SCREEN_HEIGHT)} views:@{@"view":personView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:personView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
   
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-x-[view(w)]" options:0 metrics:@{@"x":@(2*SCREEN_WIDTH),@"w":@(SCREEN_WIDTH)} views:@{@"view":messageView}]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(h)]" options:0 metrics:@{@"h":@(SCREEN_HEIGHT)} views:@{@"view":messageView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:messageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-x-[view(w)]-0-|" options:0 metrics:@{@"x":@(3*SCREEN_WIDTH),@"w":@(SCREEN_WIDTH)} views:@{@"view":calendarView}]];
    
    [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(h)]" options:0 metrics:@{@"h":@(SCREEN_HEIGHT)} views:@{@"view":calendarView}]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:calendarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    //创建底部按钮
    [self createButton];
}

- (void)createButton {
    
    self.buttonParentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , 44)];
    
    self.navigationItem.titleView = self.buttonParentView;
    
    _mainPageButton = [self buttonWithTitle:@"主页" numberAndTag:0];
    
    [self.buttonParentView addSubview:_mainPageButton];
    
    _mainPageButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    [_mainPageButton addConstraint:[NSLayoutConstraint constraintWithItem:_mainPageButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_mainPageButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.buttonParentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_mainPageButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonParentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    
    _personButton = [self buttonWithTitle:@"自己人" numberAndTag:1];
    
    [self.buttonParentView addSubview:_personButton];
    
    _personButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_personButton addConstraint:[NSLayoutConstraint constraintWithItem:_personButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_personButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_mainPageButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_personButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonParentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    
     _newsButton = [self buttonWithTitle:@"消息" numberAndTag:2];
    
    [self.buttonParentView addSubview:_newsButton];
    
    _newsButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    [_newsButton addConstraint:[NSLayoutConstraint constraintWithItem:_newsButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_newsButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_personButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_newsButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonParentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    
    _moreAgeButton = [self buttonWithTitle:@"天龄日历" numberAndTag:3];
    
    [self.buttonParentView addSubview:_moreAgeButton];
    
    _moreAgeButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    [_moreAgeButton addConstraint:[NSLayoutConstraint constraintWithItem:_moreAgeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:60]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_moreAgeButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_newsButton attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:_moreAgeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonParentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    
    _bottomScrollView = [[UIView alloc]initWithFrame:CGRectMake(0, 42, 60, 2)];
    
    [_bottomScrollView setBackgroundColor:BLUECOLOR];
    
    [self.buttonParentView addSubview:_bottomScrollView];
}

- (UIButton*)buttonWithTitle:(NSString*)title numberAndTag:(int)tag {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    button.titleLabel.font=[UIFont systemFontOfSize:15.0];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = tag;
    
    return button;
}

#pragma mark 按钮监听方法
- (void)tapButton:(UIButton *)button {
    
    CGFloat imgW = [UIScreen mainScreen].bounds.size.width;
    
    [_scrollView setContentOffset:CGPointMake(button.tag*imgW,0) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_bottomScrollView setFrame:CGRectMake(button.frame.origin.x, 42, 60 , 2)];
        
    }];
    
    switch (button.tag) {
            
        case 0:
            
            [_mainPageButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 1:
            
            [_personButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 2:
            
            [_newsButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 3:
            
            [_moreAgeButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        default:
            
            break;
    }
}

#pragma mark ---- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    
    int curPageNo = offset.x / _scrollView.bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_bottomScrollView setFrame:CGRectMake(curPageNo*60, 42, 60, 2)];
    }];
    
    switch (curPageNo) {
            
        case 0:
            
            [_mainPageButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 1:
            
            [_personButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 2:
            
            [_newsButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        case 3:
            
            [_moreAgeButton setTitleColor:BLUECOLOR forState:UIControlStateNormal];
            
            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
            
        default:
            
            break;
    }
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
