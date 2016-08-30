
//
//  STMediumCommentController.m
//  30000day
//
//  Created by GuoJia on 16/8/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumCommentController.h"
#import "InformationCommentTableViewCell.h"
#import "InformationCommentModel.h"
#import "UIImageView+WebCache.h"
#import "MTProgressHUD.h"

@interface STMediumCommentController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *commentModelArray;
@property (nonatomic,strong) NSMutableArray *willRemoveArray;

@property (nonatomic,assign) BOOL save;  //是否点击了Pid为0的 查看回复 按钮
@property (nonatomic,strong) NSMutableArray *photos;

@end

@implementation STMediumCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    //下载数据
    [self headerRefreshing];
}

- (void)configUI {
    
    self.title = @"自媒体评论";
    self.tableViewStyle = STRefreshTableViewGroup;
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    self.isShowBackItem = YES;
    self.isShowInputView = YES;
    self.isShowMedio = NO;
    self.placeholder = @"输入回复";
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"评论" style:UIBarButtonItemStylePlain target:self action:@selector(commentAction)];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)commentAction {
    
    [self refreshControllerInputViewHide];
    [self refreshControllerInputViewShowWithFlag:@10000 sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
        
        if (message != nil) {
            
            [self showHUDWithContent:@"正在上传评论" animated:YES];
            [STDataHandler sendSaveCommentWithBusiId:self.weMediaId busiType:1 userId:STUserAccountHandler.userProfile.userId.integerValue remark:message pid:-1 isHideName:NO numberStar:0 commentPhotos:nil success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self showToast:@"评论成功"];
                        [self searchCommentsWithPid:-1 busiType:1];
                    }
                    [self hideHUD:YES];
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showToast:[Common errorStringWithError:error optionalString:@"评论失败"]];
                    [self hideHUD:YES];
                });
            }];
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshControllerInputViewHide];
            });
        }
    }];
}

- (void)searchCommentsWithPid:(NSInteger)pid busiType:(NSInteger)busiType {
    
    [STDataHandler sendSearchCommentsWithBusiId:self.weMediaId busiType:busiType pid:pid userId:STUserAccountHandler.userProfile.userId.integerValue commentType:0 success:^(NSMutableArray *success) {
        
        self.commentModelArray = [NSMutableArray arrayWithArray:success];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToast:[Common errorStringWithError:error optionalString:@"数据加载失败"]];
            [self.tableView.mj_header endRefreshing];
        });
    }];
}

#pragma mark --- 上啦刷新和下拉刷新

- (void)headerRefreshing {
    [self searchCommentsWithPid:-1 busiType:1];
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
    return [InformationCommentTableViewCell heightCellWithInfoModel:commentModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];
    InformationCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCommentTableViewCell"];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InformationCommentTableViewCell" owner:nil options:nil] lastObject];
    }
    __weak typeof(cell) weakCell  = cell;
    //点击评论
    [cell setCommentBlock:^(UIButton *commentButton) {
        [self commentWithIndexPathRow:indexPath changeStatusButton:weakCell.checkReply];
    }];
    //查看/收起回复
    [cell setReplyBlock:^(UIButton *replyButton) {
        [self cellDataProcessing:replyButton index:indexPath];
    }];
    //点赞操作
    [cell setPraiseActionBlock:^(InformationCommentModel *infoModel) {
        [self.commentModelArray replaceObjectAtIndex:indexPath.row  withObject:infoModel];
        [self.tableView reloadData];
    }];
    
    cell.informationCommentModel = commentModel;
    return cell;
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
                     index:(NSIndexPath *)indexPath {
    
    InformationCommentModel *model = self.commentModelArray[indexPath.row];
    
    if (!model.selected) {
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [STDataHandler sendSearchCommentsWithBusiId:self.weMediaId busiType:2 pid:model.commentId.integerValue userId:STUserAccountHandler.userProfile.userId.integerValue commentType:0 success:^(NSMutableArray *success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (success.count > 0) {
                    
                    for (int i = 0; i < success.count; i++) {
                        InformationCommentModel *comment = success[i];
                        comment.commentPid = model.commentId;
                        [self.commentModelArray insertObject:comment atIndex:indexPath.row + 1];
                    }
                    
                    model.selected = YES;
                    [changeStatusButton setTitle:@"收起回复" forState:UIControlStateNormal];
                    [self.tableView reloadData];
                }
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                [self showToast:@"服务器繁忙"];
            });
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            model.selected = NO;
            [changeStatusButton setTitle:@"查看回复" forState:UIControlStateNormal];
            [self.tableView reloadData];
        });
    }
}

//点击评论
- (void)commentWithIndexPathRow:(NSIndexPath *)indexPath changeStatusButton:(UIButton *)checkReplyButton {
    
    [self refreshControllerInputViewHide];
    
    [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInteger:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag) {
        
        if (message != nil) {
            
            InformationCommentModel *commentModel = self.commentModelArray[indexPath.row];
            
            [STDataHandler sendSaveCommentWithBusiId:commentModel.busiId.integerValue busiType:2 userId:STUserAccountHandler.userProfile.userId.integerValue remark:message pid:commentModel.commentId.integerValue isHideName:NO numberStar:0 commentPhotos:nil success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self showToast:@"回复成功"];
                        commentModel.countCommentNum = [NSString stringWithFormat:@"%d",[commentModel.countCommentNum intValue] + 1];
                        [self cellDataProcessing:checkReplyButton index:indexPath];
                    }
                });
                
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showToast:@"回复失败"];
                });
            }];
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshControllerInputViewHide];
            });
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
