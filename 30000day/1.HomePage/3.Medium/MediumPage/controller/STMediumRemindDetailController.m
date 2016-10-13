//
//  STMediumRemindDetailController.m
//  30000day
//
//  Created by GuoJia on 16/10/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumRemindDetailController.h"
#import "STMediumCommentModel.h"
#import "STMediumCommentTableViewCell.h"
#import "STMediumModel.h"
#import "STShowMediumTableViewCell.h"
#import "STPraiseReplyCoreDataStorage.h"

@interface STMediumRemindDetailController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) STMediumModel *model;

@end

@implementation STMediumRemindDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
    [self headerRefreshing];
    [self loadMediaInfoData];
}

- (void)configureUI {
    self.title = @"详情";
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self  showHeadRefresh:YES showFooterRefresh:YES];
    self.isShowInputView = YES;
    self.isShowMedio = NO;
    self.currentPage = 1;
}

- (void)headerRefreshing {
    [self loadMediaCommentDataHead];
    //刷新所有的数据
    [self loadMediaInfoData];
}

- (void)footerRereshing {
    [STDataHandler sendShowMediaCommentListWithWeMediaId:self.weMediaId currentPage:self.currentPage + 1 success:^(NSMutableArray<STMediumCommentModel *> *dataArray) {
        if (dataArray.count) {
            self.currentPage += 1;
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
        } else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    } failure:^(NSError *error) {
        [self showToast:[Common errorStringWithError:error optionalString:@"服务器连接失败"]];
    }];
}

- (void)loadMediaInfoData {
    [STDataHandler sendShowMediaInfoWithWeMediaId:self.weMediaId success:^(STMediumModel *model) {
        self.model = model;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self showToast:[Common errorStringWithError:error optionalString:@"服务器连接失败"]];
    }];
}

- (void)loadMediaCommentDataHead {
    [STDataHandler sendShowMediaCommentListWithWeMediaId:self.weMediaId currentPage:1 success:^(NSMutableArray<STMediumCommentModel *> *dataArray) {
        self.dataArray = dataArray;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
    } failure:^(NSError *error) {
        [self showToast:[Common errorStringWithError:error optionalString:@"服务器连接失败"]];
    }];
}

#pragma ----
#pragma mark --- UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        STShowMediumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STShowMediumTableViewCell"];
        if (cell == nil) {
            cell = [[STShowMediumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STShowMediumTableViewCell"];
        }
        cell.delegate = self;
        [cell cofigCellWithModel:self.model isRelay:NO];
        return cell;
        
    } else {
        
        static NSString *tableViewIdentifier = @"STMediumCommentTableViewCell";
        STMediumCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
        
        if (cell == nil) {
            cell = [[STMediumCommentTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewIdentifier];
        }
        STMediumCommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell configureWithCommentModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
      return [STShowMediumTableViewCell heightMediumCellWith:self.model isRelay:NO];
    }
    return [STMediumCommentTableViewCell heightWithWithCommentModel:[self.dataArray objectAtIndex:indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
        label.text = @"自媒体";
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor darkGrayColor];
        [view addSubview:label];
        return view;
        
    } else if (section == 1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 30)];
        label.text = @"评论和点赞";
        label.font = [UIFont systemFontOfSize:15.0f];
        label.textColor = [UIColor darkGrayColor];
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self answerWeMediaWith:indexPath];
}

//1.不能回复自己
//2.回复完成后刷新
- (void)answerWeMediaWith:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        self.placeholder = @"评论一番吧";
        [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInteger:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag)     {
            [self showHUDWithContent:@"正在上传评论" animated:YES];
            [STDataHandler sendSaveCommentWithBusiId:self.weMediaId.integerValue busiType:1 userId:STUserAccountHandler.userProfile.userId.integerValue remark:message pid:-1 isHideName:NO numberStar:0 commentPhotos:nil success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        [self showToast:@"评论成功"];
                        [self hideHUD:YES];
                        [self loadMediaCommentDataHead];
                        //发送消息
                        if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
                            [STPraiseReplyCoreDataStorage sendReplyMessage:STUserAccountHandler.userProfile.userId currentOriginHeadImg:STUserAccountHandler.userProfile.headImg currentOriginNickName:STUserAccountHandler.userProfile.nickName userId:[self.model getOriginMediumModel].writerId originHeadImg:[self.model getOriginMediumModel].originalHeadImg originalNickName:[self.model getOriginMediumModel].originalNickName visibleType:self.visibleType];
                        }
                    }
                });
                
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showToast:@"回复失败"];
                    [self hideHUD:YES];
                });
            }];
        }];
        
    } else if (indexPath.section == 1) {
        
        STMediumCommentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if ([Common isObjectNull:model.isClickLike] && ![[model userIdUsedByLeanCloud] isEqualToNumber:STUserAccountHandler.userProfile.userId]) {//不能回复自己
            self.placeholder = [NSString stringWithFormat:@"回复%@",[model nickNameUsedByLeanCloud]];
            [self refreshControllerInputViewShowWithFlag:[NSNumber numberWithInteger:indexPath.row] sendButtonDidClick:^(NSString *message, NSMutableArray *imageArray, NSNumber *flag)     {
                [self showHUDWithContent:@"正在回复" animated:YES];
                [STDataHandler sendSaveCommentWithBusiId:model.busiId.integerValue busiType:2 userId:STUserAccountHandler.userProfile.userId.integerValue remark:message pid:model.currentId.integerValue isHideName:NO numberStar:0 commentPhotos:nil success:^(BOOL success) {
            
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            [self showToast:@"回复成功"];
                            [self hideHUD:YES];
                            [self loadMediaCommentDataHead];
                            //发送消息
                            if (![Common isObjectNull:STUserAccountHandler.userProfile.userId]) {
                                [STPraiseReplyCoreDataStorage sendReplyMessage:STUserAccountHandler.userProfile.userId currentOriginHeadImg:STUserAccountHandler.userProfile.headImg currentOriginNickName:STUserAccountHandler.userProfile.nickName userId:[model userIdUsedByLeanCloud] originHeadImg:[model headImgUsedByLeanCloud] originalNickName:[model nickNameUsedByLeanCloud] visibleType:model.visibleType];
                            }
                        }
                    });
                    
                } failure:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showToast:@"回复失败"];
                        [self hideHUD:YES];
                    });
                }];
            }];
        }
    }
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
