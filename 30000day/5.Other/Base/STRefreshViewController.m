//
//  STRefreshViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRefreshViewController.h"

@interface STRefreshViewController ()

@end

@implementation STRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    
    [self setupRefreshIsShowHeadRefresh:YES isShowFootRefresh:YES];
}

- (void)setTableViewStyle:(STRefreshTableViewStyle)tableViewStyle {
    
    _tableViewStyle = tableViewStyle;
    
    if (_tableViewStyle == STRefreshTableViewPlain) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
        
        [self.view addSubview:self.tableView];
    
        
    } else {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStyleGrouped];
        
        [self.view addSubview:self.tableView];
    }
    
    [self setupRefreshIsShowHeadRefresh:YES isShowFootRefresh:YES];
}

#pragma mark - 集成刷新控件
/**
 *  集成刷新控件
 */
- (void)setupRefreshIsShowHeadRefresh:(BOOL)isShowHeadRefresh isShowFootRefresh:(BOOL)isShowFootRefresh {
    
    _isShowFootRefresh = isShowFootRefresh;
    
    _isShowHeadRefresh = isShowHeadRefresh;
    
    if (_isShowHeadRefresh) {
        
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    } else {
        
        [self.tableView.mj_header removeFromSuperview];
        
    }
    
    if (_isShowFootRefresh) {
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];

        
        [self.tableView.mj_footer setAutomaticallyHidden:YES];
        
    } else {
        
        [self.tableView.mj_footer removeFromSuperview];
    }
    
}

- (void)headerRefreshing {

    
}

- (void)footerRereshing {
    
    
}

- (void)setIsShowFootRefresh:(BOOL)isShowFootRefresh {
    
    _isShowFootRefresh = isShowFootRefresh;
    
    [self setupRefreshIsShowHeadRefresh:_isShowHeadRefresh isShowFootRefresh:_isShowFootRefresh];
    
}

- (void)setIsShowHeadRefresh:(BOOL)isShowHeadRefresh {
    
    _isShowHeadRefresh = isShowHeadRefresh;
    
    [self setupRefreshIsShowHeadRefresh:_isShowHeadRefresh isShowFootRefresh:_isShowFootRefresh];
    
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
