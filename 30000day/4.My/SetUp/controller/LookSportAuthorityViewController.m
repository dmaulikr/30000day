//
//  LookSportAuthorityViewController.m
//  30000day
//
//  Created by WeiGe on 16/8/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "LookSportAuthorityViewController.h"
#import "MTProgressHUD.h"
#import "SelectFriendViewController.h"

@interface LookSportAuthorityViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSDictionary *dictionaryData;

@end

@implementation LookSportAuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"运动记录可见权限";
    
    [self loadData];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 38);
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
    
    [STNotificationCenter addObserver:self selector:@selector(loadData) name:STSportsPermissionsReturnsSpecificFriendsRefreshSendNotification object:nil];
    
}

- (void)loadData {

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendGetSportSwitchWithUserId:STUserAccountHandler.userProfile.userId success:^(NSMutableDictionary *dictionaryData) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.dictionaryData = dictionaryData;
            
            [self.tableView reloadData];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"自己可见";
        
    } else if (indexPath.row == 1) {
    
        cell.textLabel.text = @"朋友可见";
        
    } else if (indexPath.row == 2) {
    
        cell.textLabel.text = @"所有人可见";
        
    } else {
    
        cell.textLabel.text = @"指定人群可见";
        
    }
    
    if ([self.dictionaryData[@"status"] integerValue] == indexPath.row && self.dictionaryData != nil) {
        
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
    } else {
    
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3) {
        
        SelectFriendViewController *controller = [[SelectFriendViewController alloc] init];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        
    } else {
    
        [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
        [STDataHandler sendSetSportSwitchWithUserId:STUserAccountHandler.userProfile.userId status:indexPath.row crowdIds:nil success:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
                if (success) {
                    
                    [self loadData];
                    
                }
                
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
                
            });
            
        }];
    
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
