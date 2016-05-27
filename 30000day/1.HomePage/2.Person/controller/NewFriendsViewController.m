//
//  NewFriendsViewController.m
//  30000day
//
//  Created by GuoJia on 16/5/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "PersonTableViewCell.h"
#import "MTProgressHUD.h"
#import "NewFriendManager.h"

@interface NewFriendsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的朋友";
    self.isShowBackItem = YES;
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    [self getDataFromServer];
}

- (void)headerRefreshing {
    
    [self getDataFromServer];
}

//获取数据
- (void)getDataFromServer {
    
    [STDataHandler sendFindAllApplyAddFriendWithUserId:STUserAccountHandler.userProfile.userId success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dataArray = dataArray;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
            
            [self.tableView.mj_header endRefreshing];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource / UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 72.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PersonTableViewCell_fourth";
    
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:self options:nil][3];
    }
    
    cell.friendModel = self.dataArray[indexPath.row];
    
    __weak typeof(cell) weakCell = cell;
    
    [cell setButtonAction:^(NewFriendModel *friendModel) {
       
        [STDataHandler sendPushMessageWithCurrentUserId:STUserAccountHandler.userProfile.userId
                                                    userId:[NSNumber numberWithLongLong:[friendModel.userId longLongValue]]
                                               messageType:@2
                                                   success:^(BOOL success) {
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                           [weakCell setType:ButtonTypeAccept];
                                                       
                                                       });

                                                       //发出通知
                                                       [STNotificationCenter postNotificationName:STUserAddFriendsSuccessPostNotification object:nil];
                                                       
                                                       UserInformationModel *otherModle = [[UserInformationModel alloc] init];
                                                       
                                                       otherModle.userId = [NSNumber numberWithLongLong:[friendModel.userId longLongValue]];
                                                       
                                                       otherModle.nickName = friendModel.friendNickName;
                                                       
                                                       otherModle.originalNickName = friendModel.friendNickName;
                                                       
                                                       otherModle.originalHeadImg = friendModel.friendHeadImg;
                                                       
                                                       otherModle.headImg = friendModel.friendHeadImg;
                                                       
                                                       [NewFriendManager acceptPresenceSubscriptionRequestFrom:otherModle andCallback:^(BOOL succeeded, NSError *error) {
                                                           
                                                           
                                                       }];
                                                       
                                                   }
                                                   failure:^(NSError *error) {
                                                       
                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                           [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
                                                       
                                                       });

                                                   }];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NewFriendModel *model = self.dataArray[indexPath.row];
        
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        
        [STDataHandler sendDeleteApplyAddFriendWithUserId:STUserAccountHandler.userProfile.userId friendUserId:[NSNumber numberWithLongLong:[model.userId longLongValue]] success:^(BOOL success) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.dataArray removeObject:model];
                
                [self.tableView reloadData];
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            });
            
        } failure:^(NSError *error) {

            dispatch_async(dispatch_get_main_queue(), ^{
            
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                [self showToast:error.userInfo[NSLocalizedDescriptionKey]];
                
            });
        }];   
    }
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
