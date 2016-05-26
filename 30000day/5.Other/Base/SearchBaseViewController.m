//
//  AddressBookBaseViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchBaseViewController.h"


@interface SearchBaseViewController () <UISearchBarDelegate>

@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation SearchBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isChangeSearchBarHeight = YES;
    
    [self configUIWithIsChangeSearchBarHeight:_isChangeSearchBarHeight];
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {

        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        
        _searchBar.barTintColor = [UIColor whiteColor];
        
        _searchBar.placeholder = @"搜索位置";
        
        _searchBar.delegate = self;
        
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        
       _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        
        [_backgroundView addGestureRecognizer:tap];
        
        _backgroundView.hidden = YES;
        
        _backgroundView.backgroundColor = RGBACOLOR(200, 200, 200, 0.4);
        
        _backgroundView.userInteractionEnabled = YES;
        
        [self.view addSubview:_backgroundView];
        
    }
    return _backgroundView;
}

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        _cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
        
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        
        [_cancelButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
        
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:UITableViewStylePlain];
        
        [_tableView setTableFooterView:[[UIView alloc] init]];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//配置UI界面
- (void)configUIWithIsChangeSearchBarHeight:(BOOL)isChangeSearchBarHeight {
    
    self.view.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    
    //1.配置searchBar
    if (isChangeSearchBarHeight) {
        
        self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
        
        self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
        
        self.tableView.frame = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
        
        self.backgroundView.frame = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        
    } else {
        
        self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
        
        self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
        
        self.tableView.frame = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
        
        self.backgroundView.frame = CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    }

    //隐藏2条黑线
    for (UIView *view in [self.searchBar subviews]) {
        
        for (UIView *subView in [view subviews]) {
            
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
                
                [subView removeFromSuperview];
            }
        }
        
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
            
            [view removeFromSuperview];
        }
    }
    
    //4.监听键盘通知
    [STNotificationCenter addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}

//是否改变搜索bar的高度，默认是改变的
- (void)setIsChangeSearchBarHeight:(BOOL)isChangeSearchBarHeight {
    
    _isChangeSearchBarHeight = isChangeSearchBarHeight;
    
    [self configUIWithIsChangeSearchBarHeight:_isChangeSearchBarHeight];
}

- (void)cancelButtonAction {
    
    [self searchBarDidBeginRestore:YES];
}

- (void)keyBoardHide:(NSNotification *)notification {
    
    if ([self.searchBar.text isEqualToString:@""]) {
        
        [self searchBarDidBeginRestore:YES];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self searchBarDidBeginRestore:YES];
}

//取消
- (void)searchBarDidBeginRestore:(BOOL)isAnimation {
    
    self.backgroundView.hidden = YES;
    
    self.searchBar.text = @"";
    
    [self.tableView reloadData];
    
    [self.searchBar endEditing:YES];
    
    if (isAnimation) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
            if (_isChangeSearchBarHeight) {//要改变
                
                self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
                
                self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
                
            } else {//不要改变
                
                self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
                
                self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
            }
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    } else {
        
        if (_isChangeSearchBarHeight) {//要改变
    
            self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
            
            self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
            
        } else {//不要改变
            
            self.cancelButton.frame = CGRectMake(SCREEN_WIDTH + 5, 64, 44, 44);
            
            self.searchBar.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
            
        }
    }
}

#pragma ---
#pragma mark -- UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if ([searchBar.text isEqualToString:@""]) {//表示第一次
        
        self.backgroundView.hidden = NO;
        
        if (_isChangeSearchBarHeight) {//改变高度
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.cancelButton.frame = CGRectMake(SCREEN_WIDTH - 49, 64, 44, 44);
                
                self.searchBar.frame = CGRectMake(0,64, SCREEN_WIDTH -53, 44);
                
            } completion:^(BOOL finished) {
                
            }];

        } else {//不改变高度
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.cancelButton.frame = CGRectMake(SCREEN_WIDTH - 49, 64, 44, 44);
                
                self.searchBar.frame = CGRectMake(0,64, SCREEN_WIDTH -53, 44);
                
            } completion:^(BOOL finished) {
                
                
            }];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
     self.backgroundView.hidden = [searchText isEqualToString:@""] ? NO:YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
}


@end
