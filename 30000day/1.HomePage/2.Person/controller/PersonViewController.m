//
//  PersonViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonHeadView.h"
#import "PersonTableViewCell.h"
#import "UserInformationModel.h"
#import "PersonDetailViewController.h"
#import "PersonInformationsManager.h"
#import "NewFriendsViewController.h"
#import "NewFriendManager.h"

@interface PersonViewController () <UITableViewDataSource,UITableViewDelegate> {
    
    NSMutableArray *_dataArray;
}

@property (nonatomic,strong) PersonTableViewCell *firstCell;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    //监听个人信息管理模型发出的通知
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    //监听成功添加好友发出的通知
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUserAddFriendsSuccessPostNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUseDidSuccessDeleteFriendSendNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
    
    //成功的切换模式
    [STNotificationCenter addObserver:self selector:@selector(headerRefreshing) name:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    //获取角标
    [[NewFriendManager shareManager] getBadgeNumber:^(NSInteger badgeNumber) {
        
        if (badgeNumber <= 99) {
            
            if (badgeNumber == 0) {
                
                self.firstCell.badgeView.badgeText = @"";
                
            } else {
                
               self.firstCell.badgeView.badgeText = [NSString stringWithFormat:@"%d",(int)badgeNumber];
            }
            
        } else {
            
            self.firstCell.badgeView.badgeText = @"99+";
        }
    }];
}

- (void)reloadData {
    
    [self getMyFriends];
}

- (void)headerRefreshing {
    
    [self getMyFriends];
}

//获取我的好友
- (void)getMyFriends {
    
    [self.dataHandler getMyFriendsWithUserId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] success:^(NSMutableArray *dataArray) {
        
        _dataArray = dataArray;
        
        //给这个好友管理器赋值
        [PersonInformationsManager shareManager].informationsArray = dataArray;
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (PersonTableViewCell *)firstCell {
    
    if (!_firstCell) {
        
        _firstCell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil][2];
        
    }
    return _firstCell;
}

#pragma ---
#pragma mark ----- UITableViewDelegate/UITableViewDatasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
     
        static NSString *headViewIndentifier = @"PersonHeadView";
        
        PersonHeadView *view = (PersonHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewIndentifier];
        
        if (view == nil) {
            
            view = [[[NSBundle mainBundle] loadNibNamed:headViewIndentifier owner:self options:nil] lastObject];
        }
        
        view.titleLabel.text = [NSString stringWithFormat:@"当前共有 %ld 位自己人哦！",(unsigned long)_dataArray.count];
        
        view.titleLabel.hidden = NO;
        
        [view setChangeStateBlock:^(UIButton *changeStatusButton) {
            
            [self.tableView reloadData];
            
            [STNotificationCenter postNotificationName:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
            
        }];
        
        if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
            
            [view.changeStatusButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
            
            [view.changeStatusButton setTitle:@" 列表" forState:UIControlStateNormal];
            
        } else {
            
            [view.changeStatusButton setImage:[UIImage imageNamed:@"bigPicture.png"] forState:UIControlStateNormal];
            
            [view.changeStatusButton setTitle:@" 大图" forState:UIControlStateNormal];
        }
        
        return view;
        
    } else {
        
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 44;
    }
    
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else {
        
       return _dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 72.1f;
        
    } else {
        
        if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
            
            return SCREEN_WIDTH + 75.0f;
            
        } else {
            
            return 72.1f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {

        return self.firstCell;
        
    } else {
        
        if (![Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {//小图
            
            static NSString *identifier = @"PersonTableViewCell";
            
            PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil][0];
            }
            
            cell.informationModel = _dataArray[indexPath.row];
            
            return cell;
            
        } else {//大图
            
            static NSString *identifier_big = @"PersonTableViewCell_big";
            
            PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_big];
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil][1];
            }
            cell.informationModel_second = _dataArray[indexPath.row];
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NewFriendsViewController *controller = [[NewFriendsViewController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
        //清除badgeNumber
        [[NewFriendManager shareManager] cleanApplyFiendBadgeNumber:^(NSInteger badgerNumber) {
           
            self.firstCell.badgeView.badgeText = @"";
        }];
        
    } else {
        
        PersonDetailViewController *controller = [[PersonDetailViewController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        UserInformationModel *model = _dataArray[indexPath.row];
        
        controller.friendUserId = model.userId;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STUserAddFriendsSuccessPostNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STUseDidSuccessDeleteFriendSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    
    _dataArray = nil;
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
