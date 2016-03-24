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
#import "CommentDetailsTableViewCell.h"


@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) CommentModel *commentModel;
@property (nonatomic,strong) NSMutableArray *commentModelArray;

@property (nonatomic,strong) NSMutableArray *willRemoveArray;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评论";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowHeadRefresh = NO;
    
    self.isShowFootRefresh = NO;
    
    self.isShowBackItem = YES;
    
    [self.dataHandler sendfindCommentListWithProductId:8 type:3 pId:0 userId:-1 Success:^(NSMutableArray *success) {
        
        self.commentModelArray = [NSMutableArray arrayWithArray:success];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    self.willRemoveArray = [NSMutableArray array];
    
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
    
    CommentModel *commentModel = self.commentModelArray[indexPath.row];
    
    
    if (indexPath.section == 0) {
        
        return 44;
        
    } else {
        
        if (commentModel.level == 1) {
            
            self.commentModel = self.commentModelArray[indexPath.row];
            return 228 + [Height heightWithText:self.commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
            
        } else {
        
            return 230;
            
        }
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
        
        self.commentModel = self.commentModelArray[indexPath.row];
        
        if (self.commentModel.level == 1) {
            
            ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
            
            if (shopDetailCommentTableViewCell == nil) {
                
                shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            __weak __typeof(shopDetailCommentTableViewCell) weakSelf = shopDetailCommentTableViewCell;
            
            [shopDetailCommentTableViewCell setChangeStateBlock:^{
               
                self.commentModel = self.commentModelArray[indexPath.row];
                
                if (shopDetailCommentTableViewCell.click == 0) {
                    
                    [self.dataHandler sendfindCommentListWithProductId:8 type:-1 pId:[self.commentModel.commentId integerValue] userId:-1 Success:^(NSMutableArray *success) {
                        
                        __strong __typeof(weakSelf) strongSelf = weakSelf;
                        if (strongSelf) {
                            strongSelf.click = 1;
                        }
                        
                        for (int i = 0; i < success.count; i++) {
                            CommentModel *commentModel = success[i];
                            commentModel.level = 0;
                            [self.commentModelArray insertObject:commentModel atIndex:indexPath.row + 1];
                            
                        }
                        
                        NSLog(@"%ld",indexPath.row);
                        [self.tableView reloadData];
                        
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                } else {
                
                   __strong __typeof(weakSelf) strongSelf = weakSelf;
                    
                    if (strongSelf) {
                        strongSelf.click = 0;
                    }
                    
                    CommentModel *newModel = [self.commentModelArray objectAtIndex:indexPath.row];
                    
                    [self removeDataWithPId:[newModel.commentId integerValue]];
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < self.willRemoveArray.count; i++) {
                        
                        NSInteger index =  [self.willRemoveArray[i] integerValue];
                        
                        [array addObject:self.commentModelArray[index]];
                        
                    }
                    
                    [self.commentModelArray removeObjectsInArray:array];
                    
                    [self.tableView reloadData];
                    
                }
            }];
            
            shopDetailCommentTableViewCell.commentContentLable.text = self.commentModel.remark;
            
            shopDetailCommentTableViewCell.commentNameLable.text = self.commentModel.userName;
            
            shopDetailCommentTableViewCell.commentTimeLable.text = [NSString stringWithFormat:@"%@",self.commentModel.createTime];
            
            [shopDetailCommentTableViewCell.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headImg]];
            
            return shopDetailCommentTableViewCell;
            
        } else {
            
            self.commentModel = self.commentModelArray[indexPath.row];
            
            CommentDetailsTableViewCell *commentDetailsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailsTableViewCell"];
            
            if (commentDetailsTableViewCell == nil) {
                
                commentDetailsTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailsTableViewCell" owner:nil options:nil] lastObject];
                
            }
            
            __weak __typeof(commentDetailsTableViewCell) weakSelf = commentDetailsTableViewCell;
            
            [commentDetailsTableViewCell setChangeStateBlock:^{
                
                self.commentModel = self.commentModelArray[indexPath.row];
                
                if (commentDetailsTableViewCell.click == 0) {
                    
                    [self.dataHandler sendfindCommentListWithProductId:8 type:-1 pId:[self.commentModel.commentId integerValue] userId:-1 Success:^(NSMutableArray *success) {
                        
                        __strong __typeof(weakSelf) strongSelf = weakSelf;
                        if (strongSelf) {
                            strongSelf.click = 1;
                        }
                        
                        for (int i = 0; i < success.count; i++) {
                            CommentModel *commentModel = success[i];
                            commentModel.level = 0;
                            [self.commentModelArray insertObject:commentModel atIndex:indexPath.row + 1];
                            
                        }
                        
                        NSLog(@"%ld",indexPath.row);
                        [self.tableView reloadData];
                        
                    } failure:^(NSError *error) {
                        
                    }];
                    
                } else {
                    
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    
                    if (strongSelf) {
                        strongSelf.click = 0;
                    }
                    
                    [self removeDataWithPId:[self.commentModel.commentId integerValue]];
                    [self.tableView reloadData];
                    
                }

            }];
            
            commentDetailsTableViewCell.commentContentLable.text = self.commentModel.remark;
            
            commentDetailsTableViewCell.commentNameLable.text = self.commentModel.userName;

            [commentDetailsTableViewCell.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:self.commentModel.headImg]];

            return commentDetailsTableViewCell;
            
        }
        
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

- (void)removeDataWithPId:(NSInteger)willRemoveId {
    
    for (int i = 0; i < self.commentModelArray.count; i++) {
        
        CommentModel *model = self.commentModelArray[i];
        
        if ([model.pId integerValue] == willRemoveId) {
            
            [self removeDataWithPId:[model.commentId integerValue]];
            
            [self.willRemoveArray addObject:[NSNumber numberWithInt:i]];
//            [self.commentModelArray removeObject:model];
        }
    }
    
}

//- (void)removeDataWithPId:(NSInteger)willRemoveId {
//    
//    for (CommentModel *model in self.commentModelArray) {
//    
//        if ([model.pId integerValue] == willRemoveId) {
//            
//            [self removeDataWithPId:[model.commentId integerValue]];
//            
//            [self.commentModelArray removeObject:model];
//        }
//    }
//    
//}


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
