//
//  STMediumController.m
//  30000day
//
//  Created by GuoJia on 16/7/25.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumController.h"
#import "STMediumTypeController.h"
#import "STSendMediumController.h"
#import "STChooseSettingController.h"
#import "STSendMediumController.h"
#import "STChooseSettingController.h"

#define BUTTON_WIDTH    45.000000
#define BUTTON_HEIGHT   39.000000
#define Add_buttonW     27.0f
#define Add_buttonH     26.0f

#define button_margin_max      (SCREEN_WIDTH - 30.000000 - BUTTON_WIDTH * 5.000000) / 6.000000

@interface STMediumController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIButton *privateButton;//自己的
@property (nonatomic,strong) UIButton *friendsCircleButton;//朋友圈（仅你的朋友）
@property (nonatomic,strong) UIButton *publicButton;//公开的
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *buttonParentView;//顶部按钮的父视图
@property (nonatomic,strong) UIView *bottomScrollView;//滚动的小视图
@property (nonatomic,strong) UIButton *addFriendsButton;//添加好友
@property (nonatomic,strong) UIButton *settingButton;//设置按钮

@end

@implementation STMediumController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
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
    //好友
    STMediumTypeController *friendsController = [[STMediumTypeController alloc] init];
    friendsController.visibleType = @1;
    [friendsController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:friendsController.view];
    [self addChildViewController:friendsController];
    //公开的
    STMediumTypeController *publicController = [[STMediumTypeController alloc] init];
    publicController.visibleType = @2;
    [publicController.view setFrame:CGRectMake(SCREEN_WIDTH * 1, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:publicController.view];
    [self addChildViewController:publicController];
    //私有的
    STMediumTypeController *privateController = [[STMediumTypeController alloc] init];
    privateController.visibleType = @0;
    [privateController.view setFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:privateController.view];
    [self addChildViewController:privateController];
    //发送界面
    STSendMediumController *sendSuperController = [[STSendMediumController alloc] init];
    [sendSuperController.view setFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:sendSuperController.view];
    [self addChildViewController:sendSuperController];
    //设置界面
    STChooseSettingController *settingController = [[STChooseSettingController alloc] init];
    [settingController.view setFrame:CGRectMake(SCREEN_WIDTH * 4, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.scrollView addSubview:settingController.view];
    [self addChildViewController:settingController];
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 5, 0)];
    [STNotificationCenter addObserver:self selector:@selector(setMediumTypeController:) name:STWeMediaSuccessSendNotification object:nil];
}

- (void)setMediumTypeController:(NSNotification *)notification {
    NSNumber *visibleType = notification.object;
    
    if ([visibleType isEqualToNumber:@0]) {//
        [self tapButton:self.privateButton];
    } else if ([visibleType isEqualToNumber:@1]) {
        [self tapButton:self.friendsCircleButton];
    } else if ([visibleType isEqualToNumber:@2]) {
        [self tapButton:self.publicButton];
    }
}

- (void)createButton {
    
    self.buttonParentView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30, 44)];
    self.navigationItem.titleView = self.buttonParentView;
    
    //父滚动视图
    self.bottomScrollView = [[UIView alloc] initWithFrame:CGRectMake(button_margin_max, 42, BUTTON_WIDTH, 2)];
    [self.bottomScrollView setBackgroundColor:LOWBLUECOLOR];
    [self.buttonParentView addSubview:self.bottomScrollView];
    //好友
    self.friendsCircleButton = [self buttonWithTitle:@"好友" numberAndTag:0];
    [self.friendsCircleButton setFrame:CGRectMake(button_margin_max, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.friendsCircleButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
    [self.buttonParentView addSubview:self.friendsCircleButton];
    //公开的
    self.publicButton = [self buttonWithTitle:@"公开" numberAndTag:1];
    [self.publicButton setFrame:CGRectMake(BUTTON_WIDTH + button_margin_max * 2, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:self.publicButton];
    //自己
    self.privateButton = [self buttonWithTitle:@"自己" numberAndTag:2];
    [self.privateButton setFrame:CGRectMake(BUTTON_WIDTH * 2 + button_margin_max * 3, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:self.privateButton];
    //添加按钮
    self.addFriendsButton = [self buttonWithTitle:@"发布" numberAndTag:3];
    self.addFriendsButton.frame = CGRectMake(BUTTON_WIDTH * 3 + button_margin_max * 4, 5, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self.buttonParentView addSubview:self.addFriendsButton];
    //设置
    self.settingButton = [self buttonWithTitle:@"筛选" numberAndTag:4];
    self.settingButton.frame = CGRectMake(BUTTON_WIDTH * 4 + button_margin_max * 5, 5, BUTTON_WIDTH, BUTTON_HEIGHT);
    [self.buttonParentView addSubview:self.settingButton];
}

- (UIButton *)buttonWithTitle:(NSString *)title numberAndTag:(int)tag {
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
    
    [self.scrollView setContentOffset:CGPointMake(button.tag * SCREEN_WIDTH,0) animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomScrollView.centerX = button.centerX;
    }];
    [self buttonTitleChange:button.tag];
}

#pragma mark ---- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    NSInteger curPageNo = offset.x / self.scrollView.bounds.size.width;
    
    UIButton *button;
    if (curPageNo == 0 ) {
        button = self.friendsCircleButton;
    } else if (curPageNo == 1) {
        button = self.publicButton;
    } else if (curPageNo == 2) {
        button = self.privateButton;
    } else if (curPageNo == 3) {
        button = self.addFriendsButton;
    } else if (curPageNo == 4) {
        button = self.settingButton;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomScrollView.centerX = button.centerX;
    }];
    [self buttonTitleChange:curPageNo];
}

- (void)buttonTitleChange:(NSInteger)page {
    
    switch (page) {
            
        case 0:
            [self.friendsCircleButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [self.privateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.publicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addFriendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 1:
            [self.publicButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [self.friendsCircleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.privateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addFriendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.privateButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [self.publicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.friendsCircleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addFriendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 3:
            [self.publicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.privateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.friendsCircleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addFriendsButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [self.settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
            
        case 4:
            [self.publicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.privateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.friendsCircleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.addFriendsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.settingButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    [STNotificationCenter postNotificationName:STSendMediumControllerViewDidMove object:nil];
}

@end
