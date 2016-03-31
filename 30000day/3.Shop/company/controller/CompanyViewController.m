//
//  CompanyViewController.m
//  30000day
//
//  Created by wei on 16/3/31.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CompanyViewController.h"
#import "ShopHeadTableViewCell.h"
#import "ShopOneLineDataTableViewCell.h"
#import "ShopTitleTableViewCell.h"

@interface CompanyViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    
    [self.dataHandler sendfindCompanyInfoByIdWithCompanyId:@"2" Success:^(NSMutableArray *success) {
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 2;
        
    } else if (section == 2) {
        
        return 2;
        
    } else if (section == 3) {
        
        return 1;
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 355;
        
    }
    
    return 44;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 3) {
        
        return 0.5f;
        
    }
    return 10.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.5f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ShopHeadTableViewCell *shopHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopHeadTableViewCell"];
        
        if (shopHeadTableViewCell == nil) {
            
            shopHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopHeadTableViewCell" owner:nil options:nil] lastObject];
        }
        
        return shopHeadTableViewCell;
        
        
    } else if (indexPath.section == 1) {
        
        ShopOneLineDataTableViewCell *shopOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopOneLineDataTableViewCell"];
        
        if (shopOneLineDataTableViewCell == nil) {
            
            shopOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopOneLineDataTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopOneLineDataTableViewCell.leftTitleLable.text = @"地址。。。。。。。。";
            [shopOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"icon_location"]];
            
        } else if (indexPath.row == 1){
            
            shopOneLineDataTableViewCell.leftTitleLable.text = @"123-123-123";
            [shopOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"icon_phone"]];
        }
        
        return shopOneLineDataTableViewCell;
        
        
    } else if (indexPath.section == 2) {
        
        ShopTitleTableViewCell *shopTitleTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopTitleTableViewCell"];
        
        if (shopTitleTableViewCell == nil) {
            
            shopTitleTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTitleTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopTitleTableViewCell.textLabel.text = @"商品类别";
            
            [shopTitleTableViewCell setAccessoryType:UITableViewCellAccessoryNone];
            
            return shopTitleTableViewCell;
            
        } else {

            shopTitleTableViewCell.textLabel.text = @"好东西";
            
            return shopTitleTableViewCell;
            
        }
        
        
    } else if (indexPath.section == 3) {
        
        ShopTitleTableViewCell *shopTitleTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopTitleTableViewCell"];
        
        if (shopTitleTableViewCell == nil) {
            
            shopTitleTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopTitleTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        shopTitleTableViewCell.textLabel.text = @"商店信息";
        
        return shopTitleTableViewCell;
        
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end