//
//  MainPageViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MainPageBaseViewController.h"
#import "PersonViewController.h"
#import "CDConvsVC.h"
#import "CalendarViewController.h"
#import "AddFriendsViewController.h"
#import "UserAccountHandler.h"
#import "MainViewController.h"
#import "SignInViewController.h"
#import "JSBadgeView.h"

#define BUTTON_WIDTH 65
#define BUTTON_HEIGHT 39

@interface MainPageBaseViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIButton *mainPageButton;//主页

@property (nonatomic,strong) UIButton *personButton;//自己人

@property (nonatomic,strong) UIButton *newsButton;//消息

@property (nonatomic,strong) UIButton *moreAgeButton;//天龄日历

@property (nonatomic,strong) UIButton *addFriendsButton;//添加好友

@property (nonatomic,strong) UIView *buttonParentView;//顶部按钮的父视图

@property (nonatomic,strong) UIView *bottomScrollView;//滚动的小视图

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic,strong) JSBadgeView *badgeView;

@end

@implementation MainPageBaseViewController


//金锁详情页面 男  女 上下距离
- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self configUI];
    
    //*******************进行用户登录判断************************************************//
    if (![Common isUserLogin]) {//过去没有登录
        
        [self jumpToSignInViewController];
        
    } else {//过去有登录
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        BOOL isThirdParty = [userDefaultes integerForKey:@"isFromThirdParty"];
        NSString *type = [userDefaultes stringForKey:@"type"];
        
        [self.dataHandler postSignInWithPassword:[Common readAppDataForKey:KEY_SIGNIN_USER_PASSWORD]
                                       loginName:[Common readAppDataForKey:KEY_SIGNIN_USER_NAME]
                              isPostNotification:YES
                                isFromThirdParty:isThirdParty
                                            type:type
                                         success:^(BOOL success) {
                                             
                                             
                                         }
                                         failure:^(NSError *error) {
                                             
                                             NSString *errorString = [error userInfo][NSLocalizedDescriptionKey];
                                             
                                             if ([errorString isEqualToString:@"账户无效，请重新登录"]) {
                                                 
                                                 [self showToast:@"账户无效"];
                                                 
                                                 [self jumpToSignInViewController];
                                                 
                                             } else {
                                                 
                                                 [self showToast:@"网络繁忙，请下拉刷新"];
                                             }
                                             
                                         }];
    }
}

//跳到登录控制器
- (void)jumpToSignInViewController {
    
    SignInViewController *logview = [[SignInViewController alloc] init];
    
    STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:logview];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark ----初始化UI界面
- (void)configUI {
    
    //创建顶部按钮
    [self createButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];
    
    //设置子控制器
    MainViewController *mainPageController = [[MainViewController alloc] init];
//    PersonViewController *personViewController = [[PersonViewController alloc] init];
//    CDConvsVC *messageViewController = [[CDConvsVC alloc] init];
    
    //未读消息发生改变了的回调
//    [messageViewController setUnreadMessageChange:^(NSInteger totalUnreadCount) {
//        
//        if (totalUnreadCount) {
//            
//            if (totalUnreadCount >= 100) {
//                
//                self.badgeView.badgeText = @"99+";
//                
//            } else {
//
//                self.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(totalUnreadCount)];
//                
//            }
//
//            self.badgeView.hidden = NO;
//            
//        } else {
//            
//            self.badgeView.hidden = YES;
//        }
//    }];
    
    CalendarViewController *calendarViewController = [[CalendarViewController alloc] init];
    [self addChildViewController:mainPageController];
//    [self addChildViewController:messageViewController];
//    [self addChildViewController:personViewController];
    [self addChildViewController:calendarViewController];
   
    [mainPageController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scrollView addSubview:mainPageController.view];
    
//    [messageViewController.view setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [_scrollView addSubview:messageViewController.view];
//    
//    [personViewController.view setFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [_scrollView addSubview:personViewController.view];
    
    [calendarViewController.view setFrame:CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scrollView addSubview:calendarViewController.view];
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, 0)];
}

- (JSBadgeView *)badgeView {
    
    if (_badgeView == nil) {
        
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.newsButton alignment:JSBadgeViewAlignmentTopRight];
        
        _badgeView.badgePositionAdjustment = CGPointMake(-10.0f, 10.0f);
    }
    
    return _badgeView;
}

- (void)createButton {
    
    self.buttonParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH * 3 , 44)];
    self.navigationItem.titleView = self.buttonParentView;
    
    _mainPageButton = [self buttonWithTitle:@"主页" numberAndTag:0];
    [_mainPageButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
    [_mainPageButton setFrame:CGRectMake(0, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:_mainPageButton];
    
    
//    _newsButton = [self buttonWithTitle:@"消息" numberAndTag:1];
//    [_newsButton setFrame:CGRectMake(BUTTON_WIDTH, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
//    [self.buttonParentView addSubview:_newsButton];
//
//    
//     _personButton = [self buttonWithTitle:@"自己人" numberAndTag:2];
//    [_personButton setFrame:CGRectMake(BUTTON_WIDTH * 2, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
//    [self.buttonParentView addSubview:_personButton];
    
    _moreAgeButton = [self buttonWithTitle:@"天龄日历" numberAndTag:1];
    [_moreAgeButton setFrame:CGRectMake(BUTTON_WIDTH * 2, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:_moreAgeButton];
    
    
    _bottomScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 65, 2)];
    [_bottomScrollView setBackgroundColor:LOWBLUECOLOR];
    [self.buttonParentView addSubview:_bottomScrollView];
    
    
    self.addFriendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addFriendsButton setImage:[UIImage imageNamed:@"addFriends.png"] forState:UIControlStateNormal];
    [self.addFriendsButton addTarget:self action:@selector(addFriendsClick) forControlEvents:UIControlEventTouchDown];
    [self.buttonParentView addSubview:self.addFriendsButton];
    self.addFriendsButton.hidden = YES;
    self.addFriendsButton.translatesAutoresizingMaskIntoConstraints=NO;
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:self.addFriendsButton
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.buttonParentView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0
                                                                       constant:0]];
    
    [self.buttonParentView addConstraint:[NSLayoutConstraint constraintWithItem:self.addFriendsButton
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.buttonParentView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:0]];

}

- (UIButton *)buttonWithTitle:(NSString*)title numberAndTag:(int)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = tag;
    
    return button;
    
}

#pragma mark 按钮监听方法
- (void)tapButton:(UIButton *)button {
    
    [_scrollView setContentOffset:CGPointMake(button.tag*SCREEN_WIDTH,0) animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_bottomScrollView setFrame:CGRectMake(button.frame.origin.x, 42, 65 , 2)];
        
    }];
    
    [self buttonTitleChange:button.tag];
}

#pragma mark ---- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    
    NSInteger curPageNo = offset.x / _scrollView.bounds.size.width;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_bottomScrollView setFrame:CGRectMake(curPageNo * (BUTTON_WIDTH * 2), 42, 65, 2)];
    }];
    
    [self buttonTitleChange:curPageNo];
}

- (void)buttonTitleChange:(NSInteger)page {
    
    switch (page) {
            
        case 0:
            [_mainPageButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
        case 1:
//            [_newsButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
//            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [_moreAgeButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            break;
//        case 2:
//            [_personButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
//            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_moreAgeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            
//            break;
//        case 3:
//            [_moreAgeButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
//            [_mainPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [_newsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            
//            break;
        default:
            
            break;
    }
}

- (void)addFriendsClick {
    
    AddFriendsViewController *addfvc = [[AddFriendsViewController alloc] init];
    
    addfvc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addfvc animated:YES];
}


@end
