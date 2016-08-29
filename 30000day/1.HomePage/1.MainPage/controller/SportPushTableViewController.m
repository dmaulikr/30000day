//
//  SportPushTableViewController.m
//  30000day
//
//  Created by WeiGe on 16/8/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportPushTableViewController.h"
#import "SportTableViewCell.h"
#import "SportTrajectoryViewController.h"
#import "SportInformationTableManager.h"
#import "SportInformationModel.h"
#import "SportTrajectoryLookViewController.h"
#import "SportHeadTableViewCell.h"
#import "MTProgressHUD.h"

@interface SportPushTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) SportInformationTableManager *sportInformationTableManager;

@end

@implementation SportPushTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开始跑步";
    
    self.modelArray = [NSMutableArray array];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 38);
    
    [self showHeadRefresh:NO showFooterRefresh:YES];
    
    _sportInformationTableManager = [[SportInformationTableManager alloc] init];
    
    self.page = 2;
    
    [self loadData];
    
    //刷新运动历史记录
    [STNotificationCenter addObserver:self selector:@selector(loadData) name:STDidSuccessSportInformationSendNotification object:nil];
}

- (void)footerRereshing {
    
    [STDataHandler sendGetSportHistoryListWithCurUserId:STUserAccountHandler.userProfile.userId userId:nil currentPage:self.page success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.modelArray addObjectsFromArray:dataArray];
            
            if (dataArray.count > 0) {
                
                self.page ++;
                
                [self.tableView.mj_footer setState:MJRefreshStateIdle];
                
            } else {
                
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                
            }
            
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

- (void)loadData {
    
    //查询本地数据
    self.modelArray = [NSMutableArray arrayWithArray:[self.sportInformationTableManager selectSportInformation:STUserAccountHandler.userProfile.userId]];
    
    self.modelArray = (NSMutableArray *)[[self.modelArray reverseObjectEnumerator] allObjects];
    
    [self.tableView reloadData];
    
    if (self.modelArray.count > 20) { //删除20条之外的数据
        
        for (int i = 19; i < self.modelArray.count; i++) {
            
            SportInformationModel *model = self.modelArray[i];
            
            [_sportInformationTableManager deleteSportInformation:model.lastMaxID];
            
        }
        
    }
    
    
    for (int i = 0; i < self.modelArray.count; i++) { //查找未提交到服务器的数据提交到服务器
        
        SportInformationModel *model = self.modelArray[i];
        
        if (!model.isSave.boolValue) {
            
            [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
            
            [STDataHandler sendCommitSportHistoryWithSportInformationModel:model success:^(BOOL success) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success) {
                        
                        model.isSave = [NSNumber numberWithBool:YES];
                        
                        [_sportInformationTableManager updateSportInformationWithLastMaxID:model.lastMaxID isSave:[NSNumber numberWithBool:YES]];
                        
                        NSLog(@"上次未保存的数据保存成功");
                    }
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                });
                
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                });
            }];
            
        }
        
    }
    //如果本地数据不足10条 那就向服务器请求数据
    if (self.modelArray.count <= 10) {
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        
        [STDataHandler sendGetSportHistoryListWithCurUserId:STUserAccountHandler.userProfile.userId userId:nil currentPage:1 success:^(NSMutableArray *dataArray) {
            
            for (NSInteger i = self.modelArray.count; i < dataArray.count; i++) { //去重复添加
                
                SportInformationModel *model = dataArray[i];
                
                [self.modelArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
            });
            
        }];
        
    } else {
        
        [self.tableView reloadData];
        
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else {
        
        return self.modelArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.1f;
        
    } else {
        
        return 20;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 100;
        
    }
    
    return 74;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        return YES;
        
    }
    
    return NO;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        SportInformationModel *model = self.modelArray[indexPath.row];
        
        if (model.sportId == nil) {
            
            [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
            
            [STDataHandler senddeleteSportHistoryWithSportId:nil sportNo:[NSString stringWithFormat:@"%@",model.sportNo] success:^(BOOL success) {
                
                [_modelArray removeObjectAtIndex:indexPath.row];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success) {
                        
                        [_sportInformationTableManager deleteSportInformation:model.lastMaxID];
                        
                        [STNotificationCenter postNotificationName:STDidSuccessSportInformationSendNotification object:nil]; //发送通知刷新历史记录
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                        
                        [self loadData];
                        
                    }
                    
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                });
                
            }];
            
        } else {
            
            [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
            
            [STDataHandler senddeleteSportHistoryWithSportId:model.sportId sportNo:nil success:^(BOOL success) {
                
                [_modelArray removeObjectAtIndex:indexPath.row];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (success) {
                        
                        [STNotificationCenter postNotificationName:STDidSuccessSportInformationSendNotification object:nil]; //发送通知刷新历史记录
                        
                        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                        
                        [self loadData];
                        
                    }
                    
                });
                
            } failure:^(NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                    
                });
                
            }];
            
        }

    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        SportHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportHeadTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SportHeadTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        __weak typeof(cell) weakSelf = cell;
        
        [cell setButtonBlock:^(UIButton *btn) {
            
            if (btn.tag) {
                
                [self.tableView setEditing:!self.tableView.editing animated:YES];
                
                if (self.tableView.editing) {
                    
                    weakSelf.editorLable.text = @"完成";
                    
                } else {
                    
                    weakSelf.editorLable.text = @"编辑";
                    
                }
                
                [self.tableView reloadData];
                
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
                
                [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
                
            } else {
                
                AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
                
                [manger startMonitoring];
                
                [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    
                    if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"到户外去运动吧！" message:@"室内运动会导致运动记录不准确无法获取运动轨迹" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"继续运动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            SportTrajectoryViewController *controller = [[SportTrajectoryViewController alloc] init];
                            
                            [self.navigationController presentViewController:controller animated:YES completion:nil];
                            
                        }];
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                        
                        [alert addAction:continueAction];
                        
                        [alert addAction:cancelAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                        
                    } else {
                        
                        SportTrajectoryViewController *controller = [[SportTrajectoryViewController alloc] init];
                        
                        [self.navigationController presentViewController:controller animated:YES completion:nil];
                        
                    }
                    
                }];
                
                [manger stopMonitoring];
                
            }
            
        }];
        
        return cell;
        
    } else {
        
        SportInformationModel *model = self.modelArray[indexPath.row];
        
        SportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportTableViewCell"];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SportTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        cell.sportInformationModel = model;
        
        return cell;
        
    }
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        SportInformationModel *model = self.modelArray[indexPath.row];
        
        if ([Common isObjectNull:model.xcoordinate] || [Common isObjectNull:model.ycoordinate]) {
            
            [self showToast:@"无轨迹线路可查看"];
            
            return;
            
        }
        
        SportTrajectoryLookViewController *controller = [[SportTrajectoryLookViewController alloc] init];
        
        controller.sportInformationModel = model;
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
        
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
