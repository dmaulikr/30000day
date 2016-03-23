//
//  SearchViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchViewController.h"
#import "ShopListTableViewCell.h"
#import "ShopDetailViewController.h"

@interface SearchViewController () < UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源数组

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索";
    
    self.isSearch = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.searchBar.placeholder = @"输入商品的名称";
}

#pragma mark --- 调用父类的方法
//键盘搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if ([Common isObjectNull:searchBar.text]) {
        
        self.isSearch = NO;
        
        [self.tableView reloadData];
        
    } else {
        
        self.isSearch = YES;
        
        self.dataArray = [NSMutableArray arrayWithArray:@[@1,@2,@3]];
        
        [self.tableView reloadData];
    }
}

#pragma ---
#pragma makr --- UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
     
        return self.dataArray.count;
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.isSearch) {
        
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {
        
        ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
        }
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 113;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self searchBarDidBeginRestore:NO];
    
    ShopDetailViewController *controller = [[ShopDetailViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
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
