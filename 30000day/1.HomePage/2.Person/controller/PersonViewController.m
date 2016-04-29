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

@interface PersonViewController () <UITableViewDataSource,UITableViewDelegate> {
    
    NSMutableArray *_dataArray;
}

@property (nonatomic,assign) NSInteger state;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self showHeadRefresh:YES showFooterRefresh:NO];
    
    self.state = 0;//列表
    
    //监听个人信息管理模型发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    
    //监听成功添加好友发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:STUserAddFriendsSuccessPostNotification object:nil];
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
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        
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
        
        return 430;
        
    } else {
        
        return 72.1f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.state == 0) {//小图
        
        static NSString *identifier = @"PersonTableViewCell";
        
        PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] firstObject];
        }
        
        cell.informationModel = _dataArray[indexPath.row];
        
        return cell;
        
    } else {//大图
        
        static NSString *identifier_big = @"PersonTableViewCell_big";
        
        PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_big];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.informationModel_second = _dataArray[indexPath.row];
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonDetailViewController *controller = [[PersonDetailViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    controller.informationModel = _dataArray[indexPath.row];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
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
