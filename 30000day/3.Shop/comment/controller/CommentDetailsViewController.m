//
//  CommentDetailsViewController.m
//  30000day
//
//  Created by wei on 16/3/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentDetailsViewController.h"
#import "ShopDetailCommentTableViewCell.h"
#import "Height.h"
#import "UIImageView+WebCache.h"

@interface CommentDetailsViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation CommentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource  = self;
    
}

#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    
    [self.tableView.mj_header endRefreshing];
}

- (void)footerRereshing {
    
    [self.tableView.mj_footer endRefreshing];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 228 + [Height heightWithText:self.commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
        
    } else {
        
        return 0;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
        
        if (shopDetailCommentTableViewCell == nil) {
            
            shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        shopDetailCommentTableViewCell.commentContentLable.text = self.commentModel.remark;
        
        shopDetailCommentTableViewCell.commentNameLable.text = self.commentModel.userName;
        
        shopDetailCommentTableViewCell.commentTimeLable.text = [NSString stringWithFormat:@"%@",self.commentModel.createTime];
        
        [shopDetailCommentTableViewCell.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headImg]];
        
        return shopDetailCommentTableViewCell;
        
    } else {
    
        return nil;
    
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
