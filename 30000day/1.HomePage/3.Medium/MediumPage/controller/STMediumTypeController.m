//
//  STPrivateController.m
//  30000day
//
//  Created by GuoJia on 16/7/25.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumTypeController.h"
#import "STMediumModel.h"
#import "MTProgressHUD.h"
#import "STMediumDetailController.h"
#import "STMediumSettingTableViewCell.h"
#import "STShowMediumSpecialTableView.h"
#import "STShowMediumTableViewCell.h"
#import "STMediumModel+category.h"
#import "STChooseItemManager.h"
#import "STPraiseReplyCoreDataStorage.h"
#import "STShowReplyPraiseView.h"
#import "STShowReplyPraiseController.h"

@interface STMediumTypeController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *praiseArray;
@property (nonatomic,strong) NSMutableArray *replyArray;

@end

@implementation STMediumTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    //登录成功刷新
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    [STNotificationCenter addObserver:self selector:@selector(reloadData:) name:STWeMediaSuccessSendNotification object:nil];
    [STNotificationCenter addObserver:self selector:@selector(reloadData:) name:STWeMediumOpenControllerFetchTypeChange object:nil];
    [STNotificationCenter addObserver:self selector:@selector(sameReplyPraise:) name:STSameBodyReplyPraiseSendNotification object:nil];
    [self headerRefreshing];
    [self querySameBodyReplyPraise];
}

- (void)reloadData:(NSNotification *)notification {
    NSNumber *visibleType = notification.object;
    if ([visibleType isEqualToNumber:self.visibleType]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

//监视有人给你发来点赞和回复的消息
- (void)sameReplyPraise:(NSNotification *)notification {
    NSNumber *visibleType = notification.object;
    if ([visibleType isEqualToNumber:self.visibleType]) {
        [self querySameBodyReplyPraise];
    }
}

//查询是否有人给你发信息&同是判断底部的tabBarItem是否显示红色
- (void)querySameBodyReplyPraise {
    self.praiseArray = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] getPraiseMesssageArrayWithVisibleType:self.visibleType readState:@1 offset:0 limit:0]];
    self.replyArray = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] geReplyMesssageArrayWithVisibleType:self.visibleType readState:@1 offset:0 limit:0]];
    [self judgeTabBarItemIsShowRed];
    [self.tableView reloadData];
}
//判断底部的tabBarItem是否显示红色
- (void)judgeTabBarItemIsShowRed {
    if (self.praiseArray.count || self.replyArray.count) {
        self.navigationController.tabBarItem.badgeValue = @"";
    } else {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
}

- (void)configUI {
    //1.配置
    self.tableViewStyle = STRefreshTableViewGroup;
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    if ([self.visibleType isEqualToNumber:@2]) {//公开
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [self.tableView.mj_footer setAutomaticallyHidden:NO];
    } else {//好友、自己
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        [self.tableView.mj_footer setAutomaticallyHidden:YES];
    }
    
    self.tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.currentPage = 1;
    self.dataArray = [[NSMutableArray alloc] init];
}

//下拉刷新
- (void)headerRefreshing {
    [self getWeMediaListWithCurrentPage:1];
}

//上拉加载
- (void)footerRereshing {
    [self getWeMediaListWithCurrentPage:self.currentPage + 1];
}

- (void)getWeMediaListWithCurrentPage:(NSInteger)currentPage {
    
    if (currentPage == 1) {//下拉刷新
        
        if ([self.visibleType isEqualToNumber:@2]) {//公开
            
            [STDataHandler sendGetWeMediaListWithUserId:STUserAccountHandler.userProfile.userId currentPage:@1 visibleType:[NSString stringWithFormat:@"%@",self.visibleType] mediaTypes:[self getChooseString] orderType:@([Common readAppIntegerDataForKey:SAVE_CHOOSE_TYPE] + 1) success:^(NSMutableArray *dataArray) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataArray = dataArray;
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer setState:MJRefreshStateIdle];
                    self.currentPage = 1;
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showToast:[Common errorStringWithError:error optionalString:@"下拉刷新失败"]];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer setState:MJRefreshStateIdle];
                });
            }];
        } else {//好友、自己
            
            [STDataHandler sendGetWeMediaListWithUserId:STUserAccountHandler.userProfile.userId currentPage:@1 visibleType:[NSString stringWithFormat:@"%@",self.visibleType] mediaTypes:[self getChooseString] orderType:@1 success:^(NSMutableArray *dataArray) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataArray = dataArray;
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                    self.currentPage = 1;
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showToast:[Common errorStringWithError:error optionalString:@"下拉刷新失败"]];
                    [self.tableView.mj_header endRefreshing];
                });
            }];
        }

    } else {//上拉加载更多
        
        if ([self.visibleType isEqualToNumber:@2]) {//公开
            
            [STDataHandler sendGetWeMediaListWithUserId:STUserAccountHandler.userProfile.userId currentPage:[NSNumber numberWithInteger:(int)currentPage] visibleType:[NSString stringWithFormat:@"%@",self.visibleType] mediaTypes:[self getChooseString] orderType:@([Common readAppIntegerDataForKey:SAVE_CHOOSE_TYPE] + 1) success:^(NSMutableArray *dataArray) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([Common readAppIntegerDataForKey:SAVE_CHOOSE_TYPE] == 1) {//热点
                         [self.tableView.mj_footer setState:MJRefreshStateIdle];
                    } else {//普通
                        if (dataArray.count) {
                            [self.tableView.mj_footer setState:MJRefreshStateIdle];
                        } else {
                            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                        }
                    }
                    self.currentPage += 1;//数据下载成功加1
                    [self.dataArray addObjectsFromArray:dataArray];
                    [self.tableView reloadData];
                });
                
            } failure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showToast:[Common errorStringWithError:error optionalString:@"上拉加载更多失败"]];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_footer setState:MJRefreshStateIdle];
                });
            }];
            
        } else {//好友、自己
            
            [STDataHandler sendGetWeMediaListWithUserId:STUserAccountHandler.userProfile.userId currentPage:[NSNumber numberWithInteger:(int)currentPage] visibleType:[NSString stringWithFormat:@"%@",self.visibleType] mediaTypes:[self getChooseString] orderType:@1 success:^(NSMutableArray *dataArray) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (dataArray.count) {
                        [self.tableView.mj_footer setState:MJRefreshStateIdle];
                    } else {
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                    }
                    self.currentPage += 1;//数据下载成功加1
                    
                    [self.dataArray addObjectsFromArray:dataArray];
                    [self.tableView reloadData];
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showToast:[Common errorStringWithError:error optionalString:@"上拉加载更多失败"]];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_footer setState:MJRefreshStateIdle];
                });
            }];
        }
    }
}

- (NSString *)getChooseString {
    
   NSMutableArray *array = [STChooseItemManager choosedItemArrayWithUserId:STUserAccountHandler.userProfile.userId visibleType:self.visibleType];
    
    NSString *string = @"";
    for (int i = 0; i < array.count; i++) {
        
        STChooseItemModel *model = array[i];
        if (i == 0 ) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",model.itemTag]];
        } else {
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",model.itemTag]];
        }
    }
    return string;
}

#pragma mark --- UITableViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [STMediumModel getNumberOfRow:self.dataArray[section]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([STMediumModel getNumberOfRow:self.dataArray[indexPath.section]] == 3) {
        
        if (indexPath.row == 0) {//正常的自媒体消息
            
            STShowMediumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STShowMediumTableViewCell"];
            if (cell == nil) {
                cell = [[STShowMediumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STShowMediumTableViewCell"];
            }
            cell.delegate = self;
            [cell cofigCellWithModel:self.dataArray[indexPath.section] isRelay:NO];
            return cell;
            
        } else if (indexPath.row == 1) {//用来
            
            STShowMediumSpecialTableView *cell = [tableView dequeueReusableCellWithIdentifier:@"STShowMediumSpecialTableView_special"];
            if (cell == nil) {
                cell = [[STShowMediumSpecialTableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STShowMediumSpecialTableView_special"];
            }
            cell.delegate = self;
            STMediumModel *model  = self.dataArray[indexPath.section];
            [cell configureCellWithOriginMediumModel:[model getOriginMediumModel]];
            cell.backgroundColor = RGBACOLOR(230, 230, 230, 1);
            return cell;
        
        } else {
            
            STMediumSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STMediumSettingTableViewCell"];
            if (cell == nil) {
                cell = [[STMediumSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STMediumSettingTableViewCell"];
            }
            cell.delegate = self;
            cell.visibleType = self.visibleType;
            [cell cofigCellWithModel:self.dataArray[indexPath.section]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    } else {
        
        if (indexPath.row == 0) {//正常的自媒体消息
            
            STShowMediumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STShowMediumTableViewCell"];
            if (cell == nil) {
                cell = [[STShowMediumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STShowMediumTableViewCell"];
            }
            cell.delegate = self;
            [cell cofigCellWithModel:self.dataArray[indexPath.section] isRelay:NO];
            return cell;
            
        } else {
            
            STMediumSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STMediumSettingTableViewCell"];
            if (cell == nil) {
                cell = [[STMediumSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STMediumSettingTableViewCell"];
            }
            cell.delegate = self;
            cell.visibleType = self.visibleType;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell cofigCellWithModel:self.dataArray[indexPath.section]];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([STMediumModel getNumberOfRow:self.dataArray[indexPath.section]] == 3) {
        if (indexPath.row == 0) {
            return [STShowMediumTableViewCell heightMediumCellWith:self.dataArray[indexPath.section] isRelay:NO];
        } else if (indexPath.row == 1) {
            STMediumModel *model = self.dataArray[indexPath.section];
            return [STShowMediumSpecialTableView heightMediumCellWithOriginMediumModel:[model getOriginMediumModel]];
        } else {
            return [STMediumSettingTableViewCell heightMediumCellWith:self.dataArray[indexPath.section]];
        }
    } else {
        
        if (indexPath.row == 0) {
            return [STShowMediumTableViewCell heightMediumCellWith:self.dataArray[indexPath.section] isRelay:NO];
        } else {
            return [STMediumSettingTableViewCell heightMediumCellWith:self.dataArray[indexPath.section]];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        STShowReplyPraiseView *view =  [STShowReplyPraiseView showReplyPraiseView];
        //点击了回复视图
        [view setReplyBlock:^(NSArray<AVIMReplyMessage *> *messageArray) {
            [[STPraiseReplyCoreDataStorage shareStorage] markMessageWith:messageArray visibleType:self.visibleType readState:@2];//标记成过渡消息
            [self querySameBodyReplyPraise];
            STShowReplyPraiseController *controller = [[STShowReplyPraiseController alloc] init];
            controller.visibleType = self.visibleType;
            controller.messageType = @98;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        //点击了点赞视图
        [view setPraiseBlock:^(NSArray<AVIMPraiseMessage *> *messageArray) {
            [[STPraiseReplyCoreDataStorage shareStorage] markMessageWith:messageArray visibleType:self.visibleType readState:@2];//标记成过渡消息
            [self querySameBodyReplyPraise];
            STShowReplyPraiseController *controller = [[STShowReplyPraiseController alloc] init];
            controller.visibleType = self.visibleType;
            controller.messageType = @99;
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }];
        
        [view configureViewWithReplyArray:self.replyArray praiseArray:self.praiseArray];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([STMediumModel getNumberOfRow:self.dataArray[indexPath.section]] == 3) {
        
        if (indexPath.row == 0) {
            
            STMediumModel *model = self.dataArray[indexPath.section];
            STMediumDetailController *controller = [[STMediumDetailController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.mediumMessageId = model.mediumMessageId;
            controller.mixedMediumModel = model;
            controller.isOriginWedia = NO;
            controller.writerId = model.writerId;
            [self.navigationController pushViewController:controller animated:YES];
            [controller setDeleteBock:^{
                [self headerRefreshing];
            }];
            
        } else if (indexPath.row == 1) {
            
            STMediumModel *model = self.dataArray[indexPath.section];
            STMediumDetailController *controller = [[STMediumDetailController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.mediumMessageId = [model getOriginMediumModel].mediumMessageId;
            controller.mixedMediumModel = model;
            controller.isOriginWedia = YES;
            controller.writerId = [model getOriginMediumModel].writerId;
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller setDeleteBock:^{
                [self headerRefreshing];
            }];
        }
        
    } else if ([STMediumModel getNumberOfRow:self.dataArray[indexPath.section]] == 2) {
        
        if (indexPath.row == 0) {
            
            STMediumModel *model = self.dataArray[indexPath.section];
            STMediumDetailController *controller = [[STMediumDetailController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.mediumMessageId = model.mediumMessageId;
            controller.mixedMediumModel = model;
            controller.isOriginWedia = YES;
            controller.writerId = model.writerId;
            [self.navigationController pushViewController:controller animated:YES];
            
            [controller setDeleteBock:^{
                [self headerRefreshing];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3.5f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [STShowReplyPraiseView heightReplyPraiseViewWithReplyArray:self.replyArray praiseArray:self.praiseArray];
    }
    return 3.5f;
}

- (void)dealloc {
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
}

@end
