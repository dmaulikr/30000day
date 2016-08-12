//
//  SelectFriendViewController.m
//  30000day
//
//  Created by WeiGe on 16/8/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "MTProgressHUD.h"
#import "SelectFriendTableViewCell.h"

@interface SelectFriendViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;  //联系人

@property (nonatomic,strong) NSMutableDictionary *dictionaryData; //状态

@property (nonatomic,strong) NSArray *userIdArray;

@property (nonatomic,strong) UIButton *button;

@end

@implementation SelectFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择联系人";
    
    [self loadPermissionsData];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 26);
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [leftButton setFrame:CGRectMake(10, 30, 50, 30)];
    
    [leftButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftButton];
    
    self.button = leftButton;
    
    
    UIButton *RightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [RightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [RightButton setFrame:CGRectMake(SCREEN_WIDTH - 60, 30, 50, 30)];
    
    [RightButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:RightButton];
    
}

- (void)closeClick {

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)submitClick {

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    NSUInteger section = 0;
    
    NSMutableString *crowdIds = [NSMutableString string];
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        
        SelectFriendTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        UserInformationModel *model = _dataArray[i];
        
        if (cell.isSelect) {
            
            [crowdIds appendFormat:@"%ld,",model.userId.integerValue];
            
        }
        
    }
    
    if (crowdIds!= nil && ![crowdIds isEqualToString:@""]) {
        
        [crowdIds deleteCharactersInRange:NSMakeRange(crowdIds.length - 1,1)];
        
    }
    
    [STDataHandler sendSetSportSwitchWithUserId:STUserAccountHandler.userProfile.userId status:3 crowdIds:crowdIds success:^(BOOL success) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
            if (success) {
                
                [STNotificationCenter postNotificationName:STSportsPermissionsReturnsSpecificFriendsRefreshSendNotification object:nil];
                
                [self closeClick];
                
            }
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    }];

}

- (void)loadPermissionsData {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendGetSportSwitchWithUserId:STUserAccountHandler.userProfile.userId success:^(NSMutableDictionary *dictionaryData) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.dictionaryData = dictionaryData;
            
            NSString *userIds = dictionaryData[@"crowdIds"];
            
            self.userIdArray = [userIds componentsSeparatedByString:@","];
            
            [self getMyFriends];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    }];
    
}

//获取我的好友
- (void)getMyFriends {
    
    [STDataHandler getMyFriendsWithUserId:[NSString stringWithFormat:@"%@",STUserAccountHandler.userProfile.userId] order:[NSString stringWithFormat:@"%d",(int)0] success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _dataArray = dataArray;
            [self.tableView reloadData];
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return _dataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 72.1f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"SelectFriendTableViewCell";
    SelectFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"SelectFriendTableViewCell" owner:nil options:nil][0];
    }
    
    UserInformationModel *model = _dataArray[indexPath.row];
    
    cell.informationModel = model;
    
    for (int i = 0; i < self.userIdArray.count; i++) {
        
        if ([model.userId integerValue] == [self.userIdArray[i] integerValue]) {
            
            cell.isSelect = YES;
            
            break;
        }
        
    }

    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectFriendTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.isSelect = !cell.isSelect;
    
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
