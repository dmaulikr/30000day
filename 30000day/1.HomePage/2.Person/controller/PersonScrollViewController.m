//
//  PersonScrollViewController.m
//  30000day
//
//  Created by WeiGe on 16/7/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonScrollViewController.h"
#import "PersonViewController.h"
#import "AddFriendsViewController.h"

#define BUTTON_WIDTH 65
#define BUTTON_HEIGHT 39

@interface PersonScrollViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIView *buttonParentView;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *friendButton;

@property (nonatomic,strong) UIButton *addFriendButton;

@property (nonatomic,strong) UIView *bottomScrollView;

@end

@implementation PersonScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    scrollView.delegate = self;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    scrollView.pagingEnabled = YES;

    scrollView.bounces = NO;
    
    
    PersonViewController *person = [[PersonViewController alloc] init];
    
    [person.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self addChildViewController:person];
    
    [scrollView addSubview:person.view];
    
    
    AddFriendsViewController *addFrieds = [[AddFriendsViewController alloc] init];
    
    [addFrieds.view setFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [self addChildViewController:addFrieds];
    
    [scrollView addSubview:addFrieds.view];
    
    
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT)];
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
}

- (void)createButton {
    
    _buttonParentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BUTTON_WIDTH * 3 , 44)];
    self.navigationItem.titleView = _buttonParentView;
    
    _bottomScrollView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, 65, 2)];
    [_bottomScrollView setBackgroundColor:LOWBLUECOLOR];
    [self.buttonParentView addSubview:_bottomScrollView];
    
    _friendButton = [self buttonWithTitle:@"自己人" numberAndTag:0];
    [_friendButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
    [_friendButton setFrame:CGRectMake(0, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:_friendButton];
    
    _addFriendButton = [self buttonWithTitle:@"加好友" numberAndTag:1];
    [_addFriendButton setFrame:CGRectMake(BUTTON_WIDTH * 2, 5, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [self.buttonParentView addSubview:_addFriendButton];
    
}

- (UIButton *)buttonWithTitle:(NSString*)title numberAndTag:(int)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = tag;
    
    return button;
    
}

#pragma mark 按钮监听方法
- (void)tapButton:(UIButton *)button {
    
    [_scrollView setContentOffset:CGPointMake(button.tag * SCREEN_WIDTH, 0) animated:YES];
    
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
            [_friendButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [_addFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        case 1:
            [_addFriendButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
            [_friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            break;
        default:
            
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
