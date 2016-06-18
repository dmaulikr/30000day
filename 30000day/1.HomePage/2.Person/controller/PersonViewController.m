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
#import "AddFriendsViewController.h"
#import "MailListManager.h"
#import "MailListTableViewCell.h"
#import "ChineseString.h"
#import "MTProgressHUD.h"
#import "STGroupViewController.h"

@interface PersonViewController () <UITableViewDataSource,UITableViewDelegate> {
    
    NSMutableArray *_dataArray;
}

@property (nonatomic,strong) PersonTableViewCell *firstCell;

@property (nonatomic,assign) NSInteger sortTab;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 50);
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    //监听个人信息管理模型发出的通知
    [STNotificationCenter addObserver:self selector:@selector(getMyFriends) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    //监听成功添加好友发出的通知
    [STNotificationCenter addObserver:self selector:@selector(getMyFriends) name:STUserAddFriendsSuccessPostNotification object:nil];
    //成功移除好友的时候发送的通知
    [STNotificationCenter addObserver:self selector:@selector(getMyFriends) name:STUseDidSuccessDeleteFriendSendNotification object:nil];
    //当成功的更新好友的信息（好友的昵称、备注头像）所发出的通知
    [STNotificationCenter addObserver:self selector:@selector(getMyFriends) name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
    //成功的切换模式
    [STNotificationCenter addObserver:self selector:@selector(getMyFriends) name:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    //别人同意加为好友
    [STNotificationCenter addObserver:self selector:@selector(getMyFriends) name:STDidApplyAddFriendSuccessSendNotification object:nil];
    
    [self getMyFriends];
    //设置右面的按钮
    UIBarButtonItem *addFriendItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"addFriends"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addFriendsAction)];
    
    self.navigationItem.rightBarButtonItem = addFriendItem;
    
    //有人请求加为好友
    [STNotificationCenter addObserver:self selector:@selector(changeState) name:STDidApplyAddFriendSendNotification object:nil];
}

- (void)changeState {
    
    self.firstCell.badgeView.hidden = NO;//显示cell的badge
}

- (void)addFriendsAction {
    
    AddFriendsViewController *addfvc = [[AddFriendsViewController alloc] init];
    
    addfvc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addfvc animated:YES];
}

- (void)headerRefreshing {
    
    [self getMyFriends];
}

//获取我的好友
- (void)getMyFriends {

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [STDataHandler getMyFriendsWithUserId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] order:[NSString stringWithFormat:@"%d",(int)self.sortTab] success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            _dataArray = dataArray;
            
            //给这个好友管理器赋值
            [PersonInformationsManager shareManager].informationsArray = dataArray;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [self.tableView.mj_header endRefreshing];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        });
        
    }];
}

- (PersonTableViewCell *)firstCell {
    
    if (!_firstCell) {
        
        _firstCell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil][2];
        
        _firstCell.badgeView.hidden = [Common readAppIntegerDataForKey:USER_BADGE_NUMBER] ? NO : YES;//显示cell的badge
        
        self.tabBarItem.badgeValue = [Common readAppBoolDataForkey:USER_BADGE_NUMBER] ? @"" : nil;//显示底部badge
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
        
        view.titleLabel.text = [NSString stringWithFormat:@"当前共有 %ld 位自己人",(unsigned long)_dataArray.count];
        
        view.titleLabel.hidden = NO;
        
        [view setChangeStateBlock:^(UIButton *changeStatusButton) {
            
            [self.tableView reloadData];
            
            [STNotificationCenter postNotificationName:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
            
        }];
        
        if (self.sortTab) {
        
            [view.sortButton setTitle:@"降序" forState:UIControlStateNormal];
            
            view.sortButton.selected = YES;
        
        } else {
            
            [view.sortButton setTitle:@"升序" forState:UIControlStateNormal];
        
            view.sortButton.selected = NO;
        }

        [view setSortButtonBlock:^(UIButton *button) {
            
            if (button.isSelected) {
                
                button.selected = NO;
                
                self.sortTab = 0;
                
                [button setTitle:@"升序" forState:UIControlStateNormal];
                
            } else {
                
                button.selected = YES;
                
                self.sortTab = 1;
                
                [button setTitle:@"降序" forState:UIControlStateNormal];
            }
            
            [self getMyFriends];
            
        }];

        
        if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
            
            [view.changeStatusButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
            
            [view.changeStatusButton setTitle:@" 列表" forState:UIControlStateNormal];
            
        } else {
            
            [view.changeStatusButton setImage:[UIImage imageNamed:@"bigPicture.png"] forState:UIControlStateNormal];
            
            [view.changeStatusButton setTitle:@" 大图" forState:UIControlStateNormal];
        }
        
        return view;
        
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 44;
    }
    
    return 25.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    }  else {
        
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
        
        if (indexPath.row == 0) {
            
            return self.firstCell;
            
        } else if (indexPath.row == 1) {
            
            static NSString *indentifier = @"PersonTableViewCell_group";
            
            PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
            
            if (cell == nil) {
                
                cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil][2];
            }
            
            cell.imageView_third.image = [UIImage imageNamed:@"add_friend_icon_addgroup"];
            
            cell.badgeView.hidden = YES;
            
            cell.label_third.text = @"群组";
            
            return cell;
        }
        
        return nil;
        
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            NewFriendsViewController *controller = [[NewFriendsViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
            
            self.firstCell.badgeView.hidden = YES;//清除cell的badge
            
            [Common saveAppIntegerDataForKey:USER_BADGE_NUMBER withObject:0];//把plist里面存储的badge清空
            
            self.tabBarItem.badgeValue = nil;//清除底部按钮badge
            
        } else if (indexPath.row == 1) {
            
            STGroupViewController *controller = [[STGroupViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:controller animated:YES];
        }

    }  else {
        
        PersonDetailViewController *controller = [[PersonDetailViewController alloc] init];
        
        controller.hidesBottomBarWhenPushed = YES;
        
        UserInformationModel *model = _dataArray[indexPath.row];
        
        controller.friendUserId = model.userId;
        
        controller.informationModel = model;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STUserAddFriendsSuccessPostNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STUseDidSuccessDeleteFriendSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessUpdateFriendInformationSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STUserDidSuccessChangeBigOrSmallPictureSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidApplyAddFriendSuccessSendNotification object:nil];
    
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
