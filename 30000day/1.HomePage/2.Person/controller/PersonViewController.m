//
//  PersonViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonHeadView.h"
#import "myFriendsTableViewCell.h"
#import "UserInformationModel.h"
#import "PersonDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface PersonViewController () <UITableViewDataSource,UITableViewDelegate> {
    
    NSMutableArray *_dataArray;
}

@property (nonatomic,assign) NSInteger state;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.state = 0;//列表

    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    //获取我的好友
    [self getMyFriends];
    
    //监听个人信息管理模型发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    
    //监听成功添加好友发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:STUserAddFriendsSuccessPostNotification object:nil];
}

- (void)reloadData {
    
    [self getMyFriends];
}

//获取我的好友
- (void)getMyFriends {
    
    [self.dataHandler getMyFriendsWithUserId:STUserAccountHandler.userProfile.userId success:^(NSMutableArray *dataArray) {
        
        _dataArray = dataArray;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma ---
#pragma mark ----- UITableViewDelegate/UITableViewDatasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headViewIndentifier = @"PersonHeadView";
    
    PersonHeadView *view = (PersonHeadView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewIndentifier];
    
    if (view == nil) {
        
        view = [[[NSBundle mainBundle] loadNibNamed:headViewIndentifier owner:self options:nil] lastObject];
    }

    view.titleLabel.text = [NSString stringWithFormat:@"当前共有 %ld 位自己人哦！",(unsigned long)_dataArray.count];
    
    [view setChangeStateBlock:^(UIButton *changeStatusButton){
       
        self.state = self.state ? 0 : 1 ;
        
        [self.tableView reloadData];
        
    }];
    
    if (self.state == 1) {
        
        [view.changeStatusButton setImage:[UIImage imageNamed:@"bigPicture.png"] forState:UIControlStateNormal];
        
        [view.changeStatusButton setTitle:@" 列表" forState:UIControlStateNormal];
        
    } else {
        
        [view.changeStatusButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
        
        [view.changeStatusButton setTitle:@" 大图" forState:UIControlStateNormal];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 44;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.state) {
        
        return 425;
        
    } else {
        
        return 81;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInformationModel *informationModel = _dataArray[indexPath.row];
    
    myFriendsTableViewCell *cell;
    
    if (self.state) {
        
        static NSString *ID = @"friendsBigIMGCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyFriendsBigIMGTableViewCell" owner:nil options:nil] lastObject];
        }
        
    } else {
        
        static NSString *ID = @"myFriendsCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"myFriendsTableViewCell" owner:nil options:nil] lastObject];
        }
    }
    
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:informationModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    cell.nameLab.text = informationModel.nickName;
    
    cell.logName.text = [Common isObjectNull:informationModel.remark] ? @"暂无简介" :informationModel.remark;
    
    cell.informationModel = informationModel;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonDetailViewController *controller = [[PersonDetailViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    controller.informationModel = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
