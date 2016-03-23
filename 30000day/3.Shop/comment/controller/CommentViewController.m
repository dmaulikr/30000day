//
//  CommentViewController.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentViewController.h"
#import "ShopDetailCommentTableViewCell.h"
#import "CommentOptionsTableViewCell.h"
#import "AppointmentConfirmViewController.h"
#import "Height.h"
#import "CommentDetailsViewController.h"
#import "CommentModel.h"
#import "UIImageView+WebCache.h"


@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) CommentModel *commentModel;
@property (nonatomic,strong) NSArray *commentModelArray;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评论";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowHeadRefresh = YES;
    
    self.isShowFootRefresh = YES;
    
    self.isShowBackItem = YES;
    
    [self.dataHandler sendfindCommentListWithProductId:8 type:3 pId:0 userId:1000000037 Success:^(NSMutableArray *success) {
        
        self.commentModelArray = [NSArray arrayWithArray:success];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
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
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else {
        
        return self.commentModelArray.count;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 44;
        
    } else {
        
        self.commentModel = self.commentModelArray[indexPath.row];
        return 228 + [Height heightWithText:self.commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.section == 0) {
        
        CommentOptionsTableViewCell *commentOptionsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommentOptionsTableViewCell"];
        
        if (commentOptionsTableViewCell == nil) {
            
            commentOptionsTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentOptionsTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        [commentOptionsTableViewCell setChangeStateBlock:^(UIButton *changeStatusButton) {
           
            if (changeStatusButton.tag == 1) {
                
                [self showToast:@"1"];
                
            } else if (changeStatusButton.tag == 2){
                
                [self showToast:@"2"];
            
            } else if (changeStatusButton.tag ==3){
                
                [self showToast:@"3"];
            
            } else {
                
                [self showToast:@"4"];
            
            }
            
        }];
        
        return commentOptionsTableViewCell;

        
    } else {
        
        ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
        
        if (shopDetailCommentTableViewCell == nil) {
            
            shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        self.commentModel = self.commentModelArray[indexPath.row];
        
        [shopDetailCommentTableViewCell setChangeStateBlock:^{
           
            
            
        }];
        
        shopDetailCommentTableViewCell.commentContentLable.text = self.commentModel.remark;
        
        shopDetailCommentTableViewCell.commentNameLable.text = self.commentModel.userName;
        
        shopDetailCommentTableViewCell.commentTimeLable.text = [NSString stringWithFormat:@"%@",self.commentModel.createTime];
        
        [shopDetailCommentTableViewCell.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headImg]];
        
        return shopDetailCommentTableViewCell;
        
    }
    
    return nil;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return;
        
    } else {
    
        self.commentModel = self.commentModelArray[indexPath.row];
        CommentDetailsViewController *controller = [[CommentDetailsViewController alloc] init];
        controller.commentModel = self.commentModel;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
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
