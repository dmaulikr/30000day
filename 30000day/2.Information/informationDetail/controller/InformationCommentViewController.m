//
//  InformationCommentViewController.m
//  30000day
//
//  Created by wei on 16/4/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationCommentViewController.h"
#import "ShopDetailCommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MWPhoto.h"
#import "MWPhotoBrowser.h"
#import "MTProgressHUD.h"

@interface InformationCommentViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *commentModelArray;

@property (nonatomic,strong) NSMutableArray *willRemoveArray;

@property (nonatomic,assign) BOOL save;

@property (nonatomic,strong) NSMutableArray *photos;

@end

@implementation InformationCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评论";
    
    self.save = NO;
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowHeadRefresh = YES;
    
    self.isShowFootRefresh = NO;
    
    self.isShowBackItem = YES;
    
    //STUserAccountHandler.userProfile.userId.integerValue
    [self.dataHandler sendfindCommentListWithProductId:self.productId type:3 pId:0 userId:-1 Success:^(NSMutableArray *success) {
        
        self.commentModelArray = [NSMutableArray arrayWithArray:success];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self showToast:@"数据加载失败"];
        
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
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.commentModelArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *commentModel = self.commentModelArray[indexPath.row];
    
    if (commentModel.level == 1) {
        
        return 238 + [Common heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
        
    } else {
        
        if (commentModel.commentPhotos != nil && ![commentModel.commentPhotos isEqualToString:@"test.img"] && ![commentModel.commentPhotos isEqualToString:@"/img.img"]) {
            
            return 90 + (([UIScreen mainScreen].bounds.size.width - 106) / 3) + [Common heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
            
        } else {
            
            return 90 + [Common heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
            
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
    
    CommentModel *commentModel = self.commentModelArray[indexPath.row];
    
    if (commentModel.level == 1) {
        
        ShopDetailCommentTableViewCell *shopDetailCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"ShopDetailCommentTableViewCell"];
        
        if (shopDetailCommentTableViewCell == nil) {
            
            shopDetailCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"ShopDetailCommentTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        if (self.save) {
            
            [shopDetailCommentTableViewCell.checkReply setTitle:@"查看回复" forState:UIControlStateNormal];
        }
        
        [shopDetailCommentTableViewCell setCommentBlock:^(UIButton *commentButton) {
            
            [self commentWithIndexPathRow:indexPath];
            
        }];
        
        
        [shopDetailCommentTableViewCell setChangeStateBlock:^(UIButton *changeStatusButton) {
            
            [self cellDataProcessing:changeStatusButton commentModel:commentModel index:indexPath];
            
        }];
        
        [shopDetailCommentTableViewCell setCommentZambiaButtonBlock:^(UIButton *ZambiaButton) {
            
            BOOL clickLike;
            if ([ZambiaButton.titleLabel.text isEqualToString:@"赞"]) {
                
                clickLike = YES;
                
            } else {
                
                clickLike = NO;
                
            }
            
            [self.dataHandler sendPointPraiseOrCancelWithCommentId:commentModel.commentId isClickLike:clickLike Success:^(BOOL success) {
                
                if (success) {
                    
                    if ([ZambiaButton.titleLabel.text isEqualToString:@"赞"]) {
                        
                        [ZambiaButton setTitle:@"已赞" forState:UIControlStateNormal];
                        
                    } else {
                        
                        [ZambiaButton setTitle:@"赞" forState:UIControlStateNormal];
                        
                    }
                    
                }
                
            } failure:^(NSError *error) {
                
                [self showToast:@"未知错误"];
                
            }];
            
        }];
        
        shopDetailCommentTableViewCell.commentModel = commentModel;
        
        [shopDetailCommentTableViewCell setLookPhoto:^(UIImageView *imageView){
            
            [self browserImage:indexPath atIndex:imageView.tag];
            
        }];
        
        return shopDetailCommentTableViewCell;
        
    } else {
        
        CommentDetailsTableViewCell *commentDetailsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailsTableViewCell"];
        
        if (commentDetailsTableViewCell == nil) {
            
            commentDetailsTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"CommentDetailsTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        [commentDetailsTableViewCell setCommentBlock:^(UIButton *commentButton) {
            
            [self commentWithIndexPathRow:indexPath];
            
        }];
        
        [commentDetailsTableViewCell setChangeStateBlock:^(UIButton *changeStatusButton) {
            
            [self cellDataProcessing:changeStatusButton commentModel:commentModel index:indexPath];
            
        }];
        
        commentDetailsTableViewCell.commentModel = commentModel;
        
        return commentDetailsTableViewCell;
        
    }
    
    return nil;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)removeDataWithPId:(NSInteger)willRemoveId {
    
    for (int i = 0; i < self.commentModelArray.count; i++) {
        
        CommentModel *model = self.commentModelArray[i];
        
        if ([model.pId integerValue] == willRemoveId) {
            
            [self removeDataWithPId:[model.commentId integerValue]];
            
            [self.willRemoveArray addObject:[NSNumber numberWithInt:i]];
        }
    }
}

//查看回复
- (void)cellDataProcessing:(UIButton *)changeStatusButton
              commentModel:(CommentModel *)commentModel
                     index:(NSIndexPath *)indexPath{
    
    self.save = NO;
    
    if (changeStatusButton.tag == 1) {
        
        [self.dataHandler sendfindCommentListWithProductId:8 type:-1 pId:[commentModel.commentId integerValue] userId:-1 Success:^(NSMutableArray *success) {
            
            if (success.count > 0) {
                
                changeStatusButton.tag = 2;
                [changeStatusButton setTitle:@"收起回复" forState:UIControlStateNormal];
                
                for (int i = 0; i < success.count; i++) {
                    
                    CommentModel *comment = success[i];
                    comment.level = 0;
                    comment.pName = commentModel.userName;
                    [self.commentModelArray insertObject:comment atIndex:indexPath.row + 1];
                    
                }
                
                [self.tableView reloadData];
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    } else {
        
        changeStatusButton.tag = 1;
        
        [changeStatusButton setTitle:@"查看回复" forState:UIControlStateNormal];
        
        self.willRemoveArray = [NSMutableArray array];
        
        [self removeDataWithPId:[commentModel.commentId integerValue]];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.willRemoveArray.count; i++) {
            
            NSInteger index =  [self.willRemoveArray[i] integerValue];
            
            [array addObject:self.commentModelArray[index]];
            
        }
        
        [self.commentModelArray removeObjectsInArray:array];
        
        [self.tableView reloadData];
    }
}

- (void)commentType:(UIButton *)changeStatusButton {
    
    self.save = NO;
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendfindCommentListWithProductId:8 type:changeStatusButton.tag pId:0 userId:-1 Success:^(NSMutableArray *success) {
        
        if (success.count > 0) {
            
            [self.commentModelArray removeAllObjects];
            
            for (int i = 0; i < success.count; i++) {
                
                CommentModel *comment = success[i];
                comment.level = 1;
                [self.commentModelArray addObject:comment];
                
            }
            
            [self.tableView reloadData];
            
        }
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        [self showToast:@"数据加载失败"];
        
    }];
}



//点击评论
- (void)commentWithIndexPathRow:(NSIndexPath *)indexPath {
    
    [self refreshControllerInputViewHide];
    
    self.isShowInputView = YES;
    
    [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInteger:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
        
        if (message != nil) {
            
            CommentModel *commentModel = self.commentModelArray[flag.integerValue];
            
            [self.dataHandler sendsaveCommentWithProductId:commentModel.productId
                                                      type:commentModel.type.integerValue
                                                    userId:[NSString stringWithFormat:@"%ld",(long)STUserAccountHandler.userProfile.userId.integerValue]
                                                    remark:message numberStar:-1
                                                    picUrl:nil
                                                       pId:commentModel.commentId
                                                   Success:^(BOOL success) {
                                                       
                                                       if (success) {
                                                           
                                                           self.save = YES;
                                                           
                                                           [self showToast:@"回复成功"];
                                                           
                                                           [self.dataHandler sendfindCommentListWithProductId:8 type:3 pId:0 userId:-1 Success:^(NSMutableArray *success) {
                                                               
                                                               self.commentModelArray = [NSMutableArray arrayWithArray:success];
                                                               
                                                               [self.tableView reloadData];
                                                               
                                                           } failure:^(NSError *error) {
                                                               
                                                               [self showToast:@"刷新失败"];
                                                               
                                                           }];
                                                           
                                                       } else {
                                                           
                                                           [self showToast:@"回复失败"];
                                                           
                                                       }
                                                       
                                                   } failure:^(NSError *error) {
                                                       
                                                       [self showToast:@"回复失败"];
                                                       
                                                   }];
            
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)browserImage:(NSIndexPath *)indexPath atIndex:(NSInteger)index{
    
    CommentModel *commentModel = self.commentModelArray[indexPath.row];
    
    self.photos = [NSMutableArray array];
    
    NSArray *photoUrl = [commentModel.commentPhotos componentsSeparatedByString:@","];
    
    for (int i = 0; i < photoUrl.count; i++) {
        
        MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:photoUrl[i]]];
        [self.photos addObject:photo];
        
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:NO];
    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id )photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


@end
