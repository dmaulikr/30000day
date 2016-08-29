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

@interface STMediumTypeController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation STMediumTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    //登录成功刷新
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    [STNotificationCenter addObserver:self selector:@selector(reloadData:) name:STWeMediaSuccessSendNotification object:nil];
    [self headerRefreshing];
}

- (void)reloadData:(NSNotification *)notification {
    NSNumber *visibleType = notification.object;
    if ([visibleType isEqualToNumber:self.visibleType]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)configUI {
    //1.配置
    self.tableViewStyle = STRefreshTableViewGroup;
    [self showHeadRefresh:YES showFooterRefresh:YES];
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
    
        [STDataHandler sendGetWeMediaListWithUserId:STUserAccountHandler.userProfile.userId currentPage:@1 visibleType:[NSString stringWithFormat:@"%@",self.visibleType] mediaTypes:[self getChooseString] success:^(NSMutableArray *dataArray) {
            
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
        
    } else {//上拉加载更多
        
        [STDataHandler sendGetWeMediaListWithUserId:STUserAccountHandler.userProfile.userId currentPage:[NSNumber numberWithInteger:(int)currentPage] visibleType:[NSString stringWithFormat:@"%@",self.visibleType] mediaTypes:[self getChooseString] success:^(NSMutableArray *dataArray) {
            
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
            [cell cofigCellWithModel:self.dataArray[indexPath.section] isSpecail:NO];
            return cell;
            
        } else if (indexPath.row == 1) {//用来
            
            STShowMediumSpecialTableView *cell = [tableView dequeueReusableCellWithIdentifier:@"STShowMediumSpecialTableView_special"];
            if (cell == nil) {
                cell = [[STShowMediumSpecialTableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STShowMediumSpecialTableView_special"];
            }
            cell.delegate = self;
            STMediumModel *model  = self.dataArray[indexPath.section];
            [cell cofigCellWithRetweeted_status:model.retweeted_status];
            cell.backgroundColor = RGBACOLOR(230, 230, 230, 1);
            return cell;
        
        } else {
            
            STMediumSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STMediumSettingTableViewCell"];
            if (cell == nil) {
                cell = [[STMediumSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STMediumSettingTableViewCell"];
            }
            cell.delegate = self;
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
            [cell cofigCellWithModel:self.dataArray[indexPath.section] isSpecail:NO];
            return cell;
            
        } else {
            
            STMediumSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STMediumSettingTableViewCell"];
            if (cell == nil) {
                cell = [[STMediumSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STMediumSettingTableViewCell"];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell cofigCellWithModel:self.dataArray[indexPath.section]];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([STMediumModel getNumberOfRow:self.dataArray[indexPath.section]] == 3) {
        
        if (indexPath.row == 0) {
            
            return [STShowMediumTableViewCell heightMediumCellWith:self.dataArray[indexPath.section] isSpecial:NO];
            
        } else if (indexPath.row == 1) {
            
            STMediumModel *model = self.dataArray[indexPath.section];
            return [STShowMediumSpecialTableView heightMediumCellWithRetweeted_status:model.retweeted_status];
            
        } else {
            
            return [STMediumSettingTableViewCell heightMediumCellWith:self.dataArray[indexPath.section]];
        }
        
    } else {
        
        if (indexPath.row == 0) {
            
            return [STShowMediumTableViewCell heightMediumCellWith:self.dataArray[indexPath.section] isSpecial:NO];
            
        } else {
            
            return [STMediumSettingTableViewCell heightMediumCellWith:self.dataArray[indexPath.section]];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([STMediumModel getNumberOfRow:self.dataArray[indexPath.section]] == 3) {
        
        if (indexPath.row == 0) {
            
            STMediumModel *model = self.dataArray[indexPath.section];
            STMediumDetailController *controller = [[STMediumDetailController alloc] init];
            controller.hidesBottomBarWhenPushed = YES;
            controller.mediumMessageId = model.mediumMessageId;
            controller.mediaModel = model;
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
            controller.mediaModel = model;
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
            controller.mediaModel = model;
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
        return 0.01f;
    }
    return 3.5f;
}

- (void)dealloc {
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
}


@end
