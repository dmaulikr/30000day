//
//  STMessageBaseController.m
//  30000day
//
//  Created by GuoJia on 16/7/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMessageBaseController.h"
#import "CDChatListVC.h"
#import "AddFriendsViewController.h"
#import "PersonViewController.h"
#import "JSBadgeView.h"

#define BUTTON_WIDTH 65.000000
#define BUTTON_HEIGHT 39.000000

#define button_margin_max   (SCREEN_WIDTH - BUTTON_WIDTH * 3.000000) / 4.000000
#define button_margin_min   button_margin_max - 15.00000

@interface STMessageBaseController () <UIScrollViewDelegate> {
    NSInteger _savedBadgeNumber;
    NSInteger _applyFriendNumber;
}

@property (nonatomic,strong) UIButton *messageButton;//消息
@property (nonatomic,strong) UIButton *personButton;//自己人
@property (nonatomic,strong) UIButton *addButton;//加好友
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *buttonParentView;//顶部按钮的父视图
@property (nonatomic,strong) UIView *bottomScrollView;//滚动的小视图
@property (nonatomic,strong) JSBadgeView *badgeView;//最新消息角标图
@property (nonatomic,strong) JSBadgeView *personBadgeView;//自己人角标图

@end

@implementation STMessageBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (JSBadgeView *)badgeView {
    
    if (_badgeView == nil) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.messageButton alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgePositionAdjustment = CGPointMake(-10.0f, 10.0f);
    }
    
    return _badgeView;
}

- (JSBadgeView *)personBadgeView {
    
    if (_personBadgeView == nil) {
        _personBadgeView = [[JSBadgeView alloc] initWithParentView:self.personButton alignment:JSBadgeViewAlignmentTopRight];
        _personBadgeView.badgePositionAdjustment = CGPointMake(-10.0f, 10.0f);
    }
    
    return _personBadgeView;
}

#pragma mark ----初始化UI界面
- (void)configUI {
    //创建顶部按钮
    [self createButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    //设置子控制器
    CDChatListVC *listController = [[CDChatListVC alloc] init];
    [listController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //设置badge数目
    [listController setBadgeNumberBlock:^(NSInteger badge) {
        
        _savedBadgeNumber = badge;
        if (badge) {

            if (badge >= 100) {
                self.badgeView.badgeText = @"99+";
            } else {
                self.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(badge)];
            }

            self.badgeView.hidden = NO;
            
        } else {
            
            self.badgeView.hidden = YES;
        }
        
        [self setApplicationIconBadgeNumberAndTabBarItem:_savedBadgeNumber friendsApply:_applyFriendNumber];
    }];
    
    [_scrollView addSubview:listController.view];
    [self addChildViewController:listController];
    
    PersonViewController *personController = [[PersonViewController alloc] init];
    [personController.view setFrame:CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //设置角标与下部标
    [personController setCallback:^(NSInteger callback) {
        _applyFriendNumber =  callback;
        if (callback) {
            self.personBadgeView.badgeText = @" ";
        } else {
            self.personBadgeView.badgeText = nil;
        }
        //统一设置UITabBarController的角标
        [self setApplicationIconBadgeNumberAndTabBarItem:_savedBadgeNumber friendsApply:_applyFriendNumber];
    }];
    
    [_scrollView addSubview:personController.view];
    [self addChildViewController:personController];
    
    AddFriendsViewController *addController = [[AddFriendsViewController alloc] init];
    [addController.view setFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_scrollView addSubview:addController.view];
    [self addChildViewController:addController];
    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, 0)];
}

- (void)createButton {
    
    self.buttonParentView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 44)];
    self.navigationItem.titleView = self.buttonParentView;
    
    _messageButton = [self buttonWithTitle:@"消息" numberAndTag:0];
    [_messageButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
    [_messageButton setFrame:CGRectMake(button_margin_min, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:_messageButton];
    
    _personButton = [self buttonWithTitle:@"自己人" numberAndTag:1];
    [_personButton setFrame:CGRectMake(BUTTON_WIDTH + button_margin_min + button_margin_max, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:_personButton];
    
    _addButton = [self buttonWithTitle:@"加好友" numberAndTag:2];
    [_addButton setFrame:CGRectMake(BUTTON_WIDTH * 2 + button_margin_min + button_margin_max * 2, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:_addButton];
    
    _bottomScrollView = [[UIView alloc] initWithFrame:CGRectMake(button_margin_min, 42, 65, 2)];
    [_bottomScrollView setBackgroundColor:LOWBLUECOLOR];
    [self.buttonParentView addSubview:_bottomScrollView];
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

/** 
 *  设置程序标题
 *
 *  badge:最新消息的角标数目
 *  show :YES表示有好友请求 NO表示没有好友请求
 **/
- (void)setApplicationIconBadgeNumberAndTabBarItem:(NSInteger)badge friendsApply:(NSInteger)applyNumber {
    
    if (badge) {
        
        if (badge >= 100) {
            self.badgeView.badgeText = @"99+";
        } else {
            self.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(badge)];
        }
        
        self.badgeView.hidden = NO;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
        //底部tabBar的badge显示
        self.navigationController.tabBarItem.badgeValue = @"";
        
    } else {
        
        self.badgeView.hidden = YES;
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        if (applyNumber) {
            self.navigationController.tabBarItem.badgeValue = @"";
        } else {
            self.navigationController.tabBarItem.badgeValue = nil;
        }
    }
}

#pragma mark 按钮监听方法
- (void)tapButton:(UIButton *)button {
    
    [_scrollView setContentOffset:CGPointMake(button.tag * SCREEN_WIDTH,0) animated:YES];
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
        [_bottomScrollView setFrame:CGRectMake(curPageNo * BUTTON_WIDTH  + button_margin_min + button_margin_max * curPageNo, 42, 65, 2)];
    }];
    [self buttonTitleChange:curPageNo];
}

- (void)buttonTitleChange:(NSInteger)page {
    
    switch (page) {
            
        case 0:
            
            [_messageButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 1:
            
            [_personButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [_messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 2:
            [_addButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [_personButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_messageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        default:
            
            break;
    }
}


@end
