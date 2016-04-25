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
    
    [self searchCommentsWithPid:-1];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    [self.tableView setDataSource:self];
    
    [self.tableView setDelegate:self];
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    self.isShowHeadRefresh = YES;
    
    self.isShowFootRefresh = NO;
    
    self.isShowBackItem = YES;
    
    self.isShowInputView = YES;
    
    self.isShowMedio = NO;
    
    self.placeholder = @"输入回复";
}

- (void)searchCommentsWithPid:(NSInteger)pid {

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendSearchCommentsWithBusiId:self.infoId busiType:1 pid:pid userId:STUserAccountHandler.userProfile.userId.integerValue commentType:0 success:^(NSMutableArray *success) {
        
        self.commentModelArray = [NSMutableArray arrayWithArray:success];
        
        [self.tableView reloadData];
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
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
        
        [self cellDataProcessing:replyButton index:indexPath];
        
    }];
    
    [informationCommentTableViewCell setZanButtonBlock:^(UIButton *zanButton) {
        
        BOOL isClickLike;
        if (zanButton.selected) {
            
            isClickLike = NO;
            
        } else {
            
            isClickLike = YES;
            
        }
        
        InformationCommentModel *model = self.commentModelArray[indexPath.row];
        
        [self.dataHandler sendPointOrCancelPraiseWithUserId:STUserAccountHandler.userProfile.userId busiId:model.commentId isClickLike:isClickLike busiType:1 success:^(BOOL success) {
            
            if (success) {
                
                if (isClickLike) {
                    
                    [zanButton setImage:[UIImage imageNamed:@"icon_zan_blue"] forState:UIControlStateNormal];
                    zanButton.selected = YES;
                    
                } else {
                
                    [zanButton setImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
                    zanButton.selected = NO;
                    
                }
                
            }
            
        } failure:^(NSError *error) {
            
            [self showToast:@"服务器游神了"];
            
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
                     index:(NSIndexPath *)indexPath{
    
    InformationCommentModel *model = self.commentModelArray[indexPath.row];
    
    if (!model.selected) {
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [self.dataHandler sendSearchCommentsWithBusiId:self.infoId busiType:1 pid:model.commentId.integerValue userId:STUserAccountHandler.userProfile.userId.integerValue commentType:0 success:^(NSMutableArray *success) {
            
            if (success.count > 0) {

                for (int i = 0; i < success.count; i++) {
                    
                    InformationCommentModel *comment = success[i];
                    [self.commentModelArray insertObject:comment atIndex:indexPath.row + 1];
                    
                }
                
                model.selected = YES;
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
        
        [self removeDataWithPId:[model.commentId integerValue]];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.willRemoveArray.count; i++) {
            
            NSInteger index =  [self.willRemoveArray[i] integerValue];
            
            [array addObject:self.commentModelArray[index]];
            
        }
        
        [self.commentModelArray removeObjectsInArray:array];

        model.selected = NO;
        
        [changeStatusButton setTitle:@"查看回复" forState:UIControlStateNormal];
        
        [self.tableView reloadData];
    }
}

//点击评论
- (void)commentWithIndexPathRow:(NSIndexPath *)indexPath {
    
    [self refreshControllerInputViewHide];

    [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInteger:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
        
        if (message != nil) {
            
            InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];
            
            [self.dataHandler sendSaveCommentWithBusiId:commentModel.busiId.integerValue busiType:1 userId:STUserAccountHandler.userProfile.userId.integerValue remark:message pid:commentModel.commentId.integerValue isHideName:NO numberStar:0 success:^(BOOL success) {
                
                if (success) {
                    
                    //self.save = YES;
                    
                    [self showToast:@"回复成功"];
                    
                    [self searchCommentsWithPid:-1];
                    
                }
                
            } failure:^(NSError *error) {
                
                
                [self showToast:@"回复失败"];
                
            }];
            
            
        } else {
        
        
            [self refreshControllerInputViewHide];
        
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
