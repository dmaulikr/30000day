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
#import "CommentDetailsTableViewCell.h"
#import "CommentDetailsLastTableViewCell.h"

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
    
    return 3;
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else {
        return 2;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 10;
    } else if (section == 1) {
        return 10;
    }
    
    return 0.001;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 228 + [Height heightWithText:self.commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
        
    } else {
        
        if (indexPath.row == 0) {
            
            return 230;
            
        } else {
        
            return 180;
            
        }
        
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
    
        if (indexPath.row == 0) {
            
            CommentDetailsTableViewCell *commentDetailsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailsTableViewCell"];
            
            if (commentDetailsTableViewCell == nil) {
                
                commentDetailsTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailsTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            //        shopDetailCommentTableViewCell.commentContentLable.text = self.commentModel.remark;
            //
            //        shopDetailCommentTableViewCell.commentNameLable.text = self.commentModel.userName;
            //
            //        shopDetailCommentTableViewCell.commentTimeLable.text = [NSString stringWithFormat:@"%@",self.commentModel.createTime];
            //
            //        [shopDetailCommentTableViewCell.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headImg]];
            
            return commentDetailsTableViewCell;
            
        } else {
        
            CommentDetailsLastTableViewCell *commentDetailsLastTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailsLastTableViewCell"];
            
            if (commentDetailsLastTableViewCell == nil) {
                
                commentDetailsLastTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailsLastTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            //        shopDetailCommentTableViewCell.commentContentLable.text = self.commentModel.remark;
            //
            //        shopDetailCommentTableViewCell.commentNameLable.text = self.commentModel.userName;
            //
            //        shopDetailCommentTableViewCell.commentTimeLable.text = [NSString stringWithFormat:@"%@",self.commentModel.createTime];
            //
            //        [shopDetailCommentTableViewCell.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headImg]];
            
            return commentDetailsLastTableViewCell;

        
        }
        
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
