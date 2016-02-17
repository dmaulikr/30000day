//
//  AddressBookBaseViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddressBookBaseViewController.h"
#import "MailListTableViewCell.h"
#import "ChineseString.h"
#import "ShareAnimatonView.h"
#import <MessageUI/MessageUI.h>

@interface AddressBookBaseViewController () <UISearchBarDelegate>

@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation AddressBookBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI {
    
    self.view.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    
    //1.配置searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
    searchBar.barTintColor = [UIColor whiteColor];
    
    searchBar.placeholder = @"搜索位置";
    
    searchBar.delegate = self;
    
    self.searchBar = searchBar;
    //隐藏2条黑线
    for (UIView *view in [searchBar subviews]) {
        
        for (UIView *subView in [view subviews]) {
            
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
                
                [subView removeFromSuperview];
            }
        }
        
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            
            [view removeFromSuperview];
        }
    }
    
    [self.view addSubview:searchBar];
    
    //2.配置按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.cancelButton = cancelButton;
    
    cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton addTarget:self action:@selector(searchBarDidBeginRestore) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    
    //3.配置tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain];
    
    [tableView setTableFooterView:[[UIView alloc] init]];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.backgroundView addGestureRecognizer:tap];
    
    self.backgroundView.hidden = YES;
    
    self.backgroundView.backgroundColor = RGBACOLOR(200, 200, 200, 0.4);
    
    [self.view addSubview:self.backgroundView];
    
    //监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyBoardHide:(NSNotification *)notification {
    
    if ([self.searchBar.text isEqualToString:@""]) {
        
        [self searchBarDidBeginRestore];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self searchBarDidBeginRestore];
}

//取消
- (void)searchBarDidBeginRestore {
    
    self.backgroundView.hidden = YES;
    
    self.searchBar.text = @"";
    
    [self.tableView reloadData];
    
    [self.searchBar endEditing:YES];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
        
        self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
        
        self.tableView.frame = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma ---
#pragma mark -- UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if ([searchBar.text isEqualToString:@""]) {//表示第一次
        
        self.backgroundView.hidden = NO;
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            self.cancelButton.frame = CGRectMake(SCREEN_WIDTH - 49, 22, 44, 44);
            
            self.searchBar.frame = CGRectMake(0,22, SCREEN_WIDTH -53, 44);
            
            self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
     self.backgroundView.hidden = [searchText isEqualToString:@""] ? NO:YES;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
