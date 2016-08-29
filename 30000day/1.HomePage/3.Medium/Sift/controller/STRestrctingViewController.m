//
//  STRestrctingViewController.m
//  30000day
//
//  Created by GuoJia on 16/8/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRestrctingViewController.h"
#import "STGroupTableViewCell.h"
#import "STRestrictingManager.h"
#import "UserInformationModel.h"
#import "MTProgressHUD.h"

@interface STRestrctingViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *informationArray;
@end

@implementation STRestrctingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self loadDataFromServers];
}

- (void)configUI {
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.informationArray = [[NSMutableArray alloc] init];
}

- (void)loadDataFromServers {
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendGetWemediaSwitchWithUserId:STUserAccountHandler.userProfile.userId
                                             type:self.type
                                          success:^(NSMutableArray *dataArray) {
                                              
                                              self.dataArray = [[NSMutableArray alloc] init];
                                              self.informationArray = dataArray;
                                              for (int i = 0; i < dataArray.count; i++) {
                                                  UserInformationModel *model = dataArray[i];
                                                  STGroupCellModel *cellModel = [[STGroupCellModel alloc] init];
                                                  cellModel.imageViewURL = [model showHeadImageUrlString];
                                                  cellModel.title = [model showNickName];
                                                  [self.dataArray addObject:cellModel];
                                              }
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.tableView reloadData];
                                                  [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                                              });
                                              
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToast:[Common errorStringWithError:error optionalString:@"获取自媒体权限失败"]];
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        });
    }];
}

#pragma mark --- UITableViewDataSource / UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    STGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STGroupTableViewCell"];
    if (cell == nil) {
        cell = [[STGroupTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"STGroupTableViewCell"];
    }
    
    cell.isMainGroup = YES;//写在前面
//    cell.memberMutableArray = self.dataArray;
    
    [cell configGroupTableViewCellWith:self.dataArray];
    [cell setMemberButtonBlock:^(NSInteger imageViewIndex, BOOL isAdmin) {//回调
        
        if (isAdmin) {//群主
            
            if (imageViewIndex == self.informationArray.count + 1) {//点击了踢人按钮
                
                [STRestrictingManager removeMemberFromController:self
                                                          userId:STUserAccountHandler.userProfile.userId
                                                          status:@0
                                                            type:self.type
                                           informationModelArray:self.informationArray
                                                        callBack:^(BOOL success, NSError *error) {
                                               
                                               if (success) {
                                                   [self showToast:@"移除成功"];
                                                   [self loadDataFromServers];
                                               } else {
                                                   [self showToast:[Common errorStringWithError:error optionalString:@"移除失败"]];
                                               }
                                           }];
                
            } else if (imageViewIndex == self.informationArray.count) {//点击增加人按钮
                
                [STRestrictingManager addMemberFromController:self userId:STUserAccountHandler.userProfile.userId
                                                       status:@0
                                                         type:self.type
                                        informationModelArray:self.informationArray
                                                     callBack:^(BOOL success, NSError *error) {
                                                         if (success) {
                                                             [self showToast:@"添加成功"];
                                                             [self loadDataFromServers];
                                                         } else {
                                                             [self showToast:[Common errorStringWithError:error optionalString:@"添加失败"]];
                                                         }
                                                     }];
                
            } else {//点击了普通按钮
                
            }
            
        } else {
            
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [STGroupTableViewCell groupTableViewCellHeight:[[NSMutableArray alloc] init]];
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
