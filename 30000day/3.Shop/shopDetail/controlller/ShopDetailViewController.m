//
//  ShopDetailViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopDetailHeadTableViewCell.h"
#import "ShopDetailOneLineDataTableViewCell.h"
#import "ShopDetailRecommendTableViewCell.h"
#import "ShopDetailCommentHeadTableViewCell.h"
#import "ShopDetailCommentTableViewCell.h"
#import "ShopDetailOneLineDataNoImageViewTableViewCell.h"


#define SECTIONSCOUNT 5


@interface ShopDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTIONSCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 2;
        
    } else if (section == 2) {
        
        return 4;
        
    } else if (section == 3) {
        
        return 4;
        
    } else if (section == 4) {
        
        return 4;
        
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 355;
        
    } else if (indexPath.section == 1) {
        
        return 44;
        
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 1 || indexPath.row == 2){
            
            return 110;
            
        }
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            return 100;
            
        } else if (indexPath.row == 1 || indexPath.row == 2) {
            
            return 250;
            
        }
        
    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 1 || indexPath.row == 2) {
            return 110;
        }
        
    }
    
    return 44;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 4) {
        
        return 0.5f;
        
    }
    return 10.f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.5f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ShopDetailHeadTableViewCell *shopDetailHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailHeadTableViewCell"];
        
        if (shopDetailHeadTableViewCell == nil) {
            
            shopDetailHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailHeadTableViewCell" owner:nil options:nil] lastObject];
        }
        
        return shopDetailHeadTableViewCell;
        
        
    } else if (indexPath.section == 1) {
        
        ShopDetailOneLineDataTableViewCell *shopDetailOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
        
        if (shopDetailOneLineDataTableViewCell == nil) {
            
            shopDetailOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopDetailOneLineDataTableViewCell.leftTitleLable.text = @"浦东小道888号科技大楼12楼";
            [shopDetailOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"sd-2"]];
            
        } else if (indexPath.row == 1){
            
            shopDetailOneLineDataTableViewCell.leftTitleLable.text = @"1280-333444";
            [shopDetailOneLineDataTableViewCell.leftImageView setImage:[UIImage imageNamed:@"sd-3"]];
        }
        
        return shopDetailOneLineDataTableViewCell;
        
        
    } else if (indexPath.section == 2) {
        
        ShopDetailOneLineDataTableViewCell *shopDetailOneLineDataTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataTableViewCell"];
        
        if (shopDetailOneLineDataTableViewCell == nil) {
            
            shopDetailOneLineDataTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopDetailOneLineDataTableViewCell.textLabel.text = @"店长推存（321）";
            
        } else if (indexPath.row == 1 || indexPath.row == 2){
            
            ShopDetailRecommendTableViewCell *shopDetailRecommendTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailRecommendTableViewCell"];
            
            if (shopDetailRecommendTableViewCell == nil) {
                
                shopDetailRecommendTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailRecommendTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return shopDetailRecommendTableViewCell;
            
        } else {
            
            shopDetailOneLineDataTableViewCell.textLabel.text = @"查看全部推存";
            
        }
        
        return shopDetailOneLineDataTableViewCell;
        
        
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            ShopDetailCommentHeadTableViewCell *shopDetailCommentHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentHeadTableViewCell"];
            
            if (shopDetailCommentHeadTableViewCell == nil) {
                
                shopDetailCommentHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentHeadTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            return shopDetailCommentHeadTableViewCell;
            
        } else if (indexPath.row == 1 || indexPath.row == 2){
            
            ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
            
            if (shopDetailCommentTableViewCell == nil) {
                
                shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            return shopDetailCommentTableViewCell;
            
        } else {
            
            ShopDetailOneLineDataNoImageViewTableViewCell *shopDetailOneLineDataNoImageViewTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataNoImageViewTableViewCell"];
            
            if (shopDetailOneLineDataNoImageViewTableViewCell == nil) {
                
                shopDetailOneLineDataNoImageViewTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataNoImageViewTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"查看全部评论";
            
            return shopDetailOneLineDataNoImageViewTableViewCell;
            
        }
        
        
    } else if (indexPath.section == 4) {
        
        ShopDetailOneLineDataNoImageViewTableViewCell *shopDetailOneLineDataNoImageViewTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailOneLineDataNoImageViewTableViewCell"];
        
        if (shopDetailOneLineDataNoImageViewTableViewCell == nil) {
            
            shopDetailOneLineDataNoImageViewTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailOneLineDataNoImageViewTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (indexPath.row == 0) {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"推存列表（321）";
            
        } else if (indexPath.row == 1 || indexPath.row == 2){
            
            ShopDetailRecommendTableViewCell *shopDetailRecommendTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailRecommendTableViewCell"];
            
            if (shopDetailRecommendTableViewCell == nil) {
                
                shopDetailRecommendTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailRecommendTableViewCell" owner:nil options:nil] lastObject];
            }
            
            return shopDetailRecommendTableViewCell;
            
        } else {
            
            shopDetailOneLineDataNoImageViewTableViewCell.textLabel.text = @"查看全部推存";
            
        }
        
        return shopDetailOneLineDataNoImageViewTableViewCell;
        
    }
    
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
