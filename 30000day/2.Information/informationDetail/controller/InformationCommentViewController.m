//
//  InformationCommentViewController.m
//  30000day
//
//  Created by wei on 16/4/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationCommentViewController.h"
#import "InformationCommentTableViewCell.h"
#import "InformationCommentModel.h"
#import "UIImageView+WebCache.h"
#import "MTProgressHUD.h"

@interface InformationCommentViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *commentModelArray;

@property (nonatomic,strong) NSMutableArray *willRemoveArray;

@property (nonatomic,assign) BOOL save;  //是否点击了Pid为0的 查看回复 按钮

@property (nonatomic,strong) NSMutableArray *photos;

@end

@implementation InformationCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"资讯评论";
    
    //self.save = NO;
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowHeadRefresh = YES;
    
    self.isShowFootRefresh = NO;
    
    self.isShowBackItem = YES;
    
    //STUserAccountHandler.userProfile.userId.integerValue   //self.productId
    [self.dataHandler sendSearchInfoCommentsWithInfoId:1 busiType:1 pid:0 success:^(NSMutableArray *success) {
        
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.commentModelArray.count == 0) {
        
        return 0;
        
    }
    
    return self.commentModelArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];
        
    return 107 + [Common heightWithText:commentModel.remark width:[UIScreen mainScreen].bounds.size.width fontSize:15.0];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];
        
    InformationCommentTableViewCell *informationCommentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"InformationCommentTableViewCell"];
    
    if (informationCommentTableViewCell == nil) {
        
        informationCommentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCommentTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
//    if (self.save) {
//        
//        [informationCommentTableViewCell.checkReply setTitle:@"查看回复" forState:UIControlStateNormal];
//    }
    
    [informationCommentTableViewCell setCommentBlock:^(UIButton *commentButton) {
        
        [self commentWithIndexPathRow:indexPath];
        
    }];
    
    
    [informationCommentTableViewCell setReplyBlock:^(UIButton *replyButton) {
        
        [self cellDataProcessing:replyButton commentModel:commentModel index:indexPath];
        
    }];
    
    [informationCommentTableViewCell setZanButtonBlock:^(UIButton *zanButton) {
        
        BOOL clickLike;
        if ([zanButton.titleLabel.text isEqualToString:@"赞"]) {
            
            clickLike = YES;
            
        } else {
            
            clickLike = NO;
            
        }
        
        [self.dataHandler sendPointPraiseOrCancelWithCommentId:commentModel.commentId isClickLike:clickLike Success:^(BOOL success) {
            
            if (success) {
                
                if ([zanButton.titleLabel.text isEqualToString:@"赞"]) {
                    
                    [zanButton setTitle:@"已赞" forState:UIControlStateNormal];
                    
                } else {
                    
                    [zanButton setTitle:@"赞" forState:UIControlStateNormal];
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            
            [self showToast:@"未知错误"];
            
        }];
        
    }];
    
    informationCommentTableViewCell.informationCommentModel = commentModel;
    
    return informationCommentTableViewCell;
}

#pragma mark - Table view data delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)removeDataWithPId:(NSInteger)willRemoveId {
    
    for (int i = 0; i < self.commentModelArray.count; i++) {
        
        InformationCommentModel *model = self.commentModelArray[i];
        
        if ([model.pId integerValue] == willRemoveId) {
            
            [self removeDataWithPId:[model.commentId integerValue]];
            
            [self.willRemoveArray addObject:[NSNumber numberWithInt:i]];
        }
    }
}

//查看回复
- (void)cellDataProcessing:(UIButton *)changeStatusButton
              commentModel:(InformationCommentModel *)commentModel
                     index:(NSIndexPath *)indexPath{
    
    InformationCommentModel *model = self.commentModelArray[indexPath.row];
    
    if (model.pId.integerValue == 0) {
        
        self.save = NO;
        
    }
    
    if (!changeStatusButton.selected) {
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [self.dataHandler sendSearchInfoCommentsWithInfoId:1 busiType:1 pid:model.commentId.integerValue success:^(NSMutableArray *success) {
            
            if (success.count > 0) {

                for (int i = 0; i < success.count; i++) {
                    
                    InformationCommentModel *comment = success[i];
                    [self.commentModelArray insertObject:comment atIndex:indexPath.row + 1];
                    
                }
                
                changeStatusButton.selected = YES;
                [changeStatusButton setTitle:@"收起回复" forState:UIControlStateNormal];
                
                [self.tableView reloadData];
            }
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        } failure:^(NSError *error) {
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            [self showToast:@"服务器繁忙"];
            
        }];
        
    } else {

        self.willRemoveArray = [NSMutableArray array];
        
        [self removeDataWithPId:[commentModel.commentId integerValue]];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.willRemoveArray.count; i++) {
            
            NSInteger index =  [self.willRemoveArray[i] integerValue];
            
            [array addObject:self.commentModelArray[index]];
            
        }
        
        [self.commentModelArray removeObjectsInArray:array];
        
        [self.tableView reloadData];
        
        changeStatusButton.selected = NO;
        
        [changeStatusButton setTitle:@"查看回复" forState:UIControlStateNormal];
    }
}

//点击评论
- (void)commentWithIndexPathRow:(NSIndexPath *)indexPath {
    
    [self refreshControllerInputViewHide];
    
    self.isShowInputView = YES;
    
    [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInteger:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
        
        if (message != nil) {
            
            InformationCommentModel *commentModel = self.commentModelArray[flag.integerValue];
            
            [self.dataHandler sendsaveCommentWithProductId:commentModel.productId
                                                      type:commentModel.type.integerValue
                                                    userId:[NSString stringWithFormat:@"%ld",(long)STUserAccountHandler.userProfile.userId.integerValue]
                                                    remark:message numberStar:-1
                                                    picUrl:nil
                                                       pId:commentModel.commentId
                                                   Success:^(BOOL success) {
                                                       
                                                       if (success) {
                                                           
                                                           //self.save = YES;
                                                           
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

@end
