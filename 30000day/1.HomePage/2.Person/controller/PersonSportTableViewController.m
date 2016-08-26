//
//  PersonSportTableViewController.m
//  30000day
//
//  Created by WeiGe on 16/8/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonSportTableViewController.h"
#import "SportTableViewCell.h"
#import "SportInformationModel.h"
#import "SportTrajectoryLookViewController.h"
#import "MTProgressHUD.h"

@interface PersonSportTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) NSInteger page;

@end

@implementation PersonSportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"运动记录";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 38);
    
    [self showHeadRefresh:NO showFooterRefresh:YES];
    
    self.page = 2;
    
    [self loadData];
    
}

- (void)loadData {

    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [STDataHandler sendGetSportHistoryListWithCurUserId:STUserAccountHandler.userProfile.userId userId:self.personId currentPage:1 success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.modelArray = dataArray;
            
            [self.tableView reloadData];
            
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
            
        });
        
    }];

}

- (void)footerRereshing {

    [STDataHandler sendGetSportHistoryListWithCurUserId:STUserAccountHandler.userProfile.userId userId:self.personId currentPage:self.page success:^(NSMutableArray *dataArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            for (NSInteger i = 0; i < dataArray.count; i++) {
                
                [self.modelArray addObject:dataArray[i]];
                
            }
            
            if (dataArray.count > 0) {
                
                self.page ++;
                
            }
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        });
        
    } failure:^(NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView.mj_footer endRefreshing];
            
        });
        
    }];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArray.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 74;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01f;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SportInformationModel *model = self.modelArray[indexPath.row];
    
    SportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SportTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    cell.sportInformationModel = model;
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SportInformationModel *model = self.modelArray[indexPath.row];
    
    if ([Common isObjectNull:model.xcoordinate] || [Common isObjectNull:model.ycoordinate]) {
        
        [self showToast:@"无轨迹线路可查看"];
        
        return;
        
    }
    
    SportTrajectoryLookViewController *controller = [[SportTrajectoryLookViewController alloc] init];
    
    controller.sportInformationModel = model;
    
    controller.birthday = self.birthday;
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
