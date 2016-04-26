//
//  CompanyCommodityViewController.m
//  30000day
//
//  Created by wei on 16/3/31.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CompanyCommodityViewController.h"
#import "ShopListTableViewCell.h"
#import "ShopModel.h"
#import "ShopDetailViewController.h"

@interface CompanyCommodityViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *shopModelArray;

@end

@implementation CompanyCommodityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowBackItem = YES;
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    
    [self.dataHandler sendFindProductsByIdsWithCompanyId:@"2" productTypeId:@"1" Success:^(NSMutableArray *success) {
       
        self.shopModelArray = [NSArray arrayWithArray:success];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.shopModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.5f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopListTableViewCell *shopListTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopListTableViewCell"];
    
    if (shopListTableViewCell == nil) {
        
        shopListTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopListTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    ShopModel *shopModel = self.shopModelArray[indexPath.row];
    
    shopListTableViewCell.shopModel = shopModel;
    
    return shopListTableViewCell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopDetailViewController *shopDetailViewController = [[ShopDetailViewController alloc] init];
    [self.navigationController pushViewController:shopDetailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
