//
//  STMediumRemindListController.m
//  30000day
//
//  Created by GuoJia on 16/10/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumRemindListController.h"
#import "STMediumRemindListModel.h"
#import "STMediumRemindListTableViewCell.h"
#import "STMediumRemindDetailController.h"

@interface STMediumRemindListController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int currentPage;

@end

@implementation STMediumRemindListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self confiureUI];
    [self loadDataFromServerHeadRefresh];
}

- (void)confiureUI {
    self.title = @"消息列表";
    self.tableViewStyle = STRefreshTableViewPlain;
    [self showHeadRefresh:YES showFooterRefresh:YES];
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.currentPage = 1;
}

- (void)footerRereshing {
    [self loadDataFromServerFooterRefresh];
}

- (void)headerRefreshing {
    [self loadDataFromServerHeadRefresh];
}

- (void)loadDataFromServerHeadRefresh {
    
    [STDataHandler sendSearchMyRelativeWithUserId:STUserAccountHandler.userProfile.userId
                                      currentPage:1
                                          success:^(NSMutableArray <STMediumRemindListModel *>*dataArray) {
                                              
                                              self.dataArray = dataArray;
                                              self.currentPage = 1;
                                              [self.tableView reloadData];
                                              [self.tableView.mj_header endRefreshing];
                                              [self.tableView.mj_footer setState:MJRefreshStateIdle];
                                              
                                          } failure:^(NSError *error) {
                                              [self showToast:[Common errorStringWithError:error optionalString:@"服务器连接失败"]];
                                          }];
}

- (void)loadDataFromServerFooterRefresh {
    
    [STDataHandler sendSearchMyRelativeWithUserId:STUserAccountHandler.userProfile.userId
                                      currentPage:self.currentPage + 1
                                          success:^(NSMutableArray <STMediumRemindListModel *>*dataArray) {
                                              
                                              if (dataArray.count) {
                                                  
                                                  [self.dataArray addObjectsFromArray:dataArray];
                                                  self.currentPage += 1;
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

#pragma ---
#pragma mark ---- UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"STMediumRemindListTableViewCell";
    STMediumRemindListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[STMediumRemindListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell configureWithListModel:[self.dataArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [STMediumRemindListTableViewCell heightWithWithListModel:[self.dataArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    STMediumRemindDetailController *controller = [[STMediumRemindDetailController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    STMediumRemindListModel *model =  [self.dataArray objectAtIndex:indexPath.row];
    controller.weMediaId = model.weMediaId;
    controller.visibleType = model.visibleType;
    [self.navigationController pushViewController:controller animated:YES];
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
