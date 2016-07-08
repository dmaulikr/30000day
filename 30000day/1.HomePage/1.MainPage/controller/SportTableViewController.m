//
//  SportTableViewController.m
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportTableViewController.h"
#import "SportTableViewCell.h"
#import "SportTrajectoryViewController.h"
#import "SportInformationTableManager.h"
#import "SportInformationModel.h"

@interface SportTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *modelArray;

@property (nonatomic,strong) SportInformationTableManager *SFTable;

@end

@implementation SportTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开始跑步";
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [self showHeadRefresh:NO showFooterRefresh:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.modelArray = [NSArray array];
    
    self.SFTable = [[SportInformationTableManager alloc] init];
    
    self.modelArray = [self.SFTable selectSportInformation:STUserAccountHandler.userProfile.userId];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
        
    } else {
    
        return self.modelArray.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        
        return 0.1f;
        
    } else {
    
        return 20;
    
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return 100;
        
    }
    
    return 54;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        SportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportTableViewCell"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"SportTableViewCell" owner:nil options:nil][0];
            
        }
        
        [cell setButtonBlock:^(UIButton *btn) {
            
            SportTrajectoryViewController *controller = [[SportTrajectoryViewController alloc] init];
            
            [self.navigationController presentViewController:controller animated:YES completion:nil];
            
        }];
        
        return cell;
        
    } else {
        
        SportInformationModel *model = self.modelArray[indexPath.row];
    
        SportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportInformationCell"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"SportTableViewCell" owner:nil options:nil][1];
            
        }
        
        cell.sportInformationModel = model;
        
        return cell;
    
    }
    

    
    return nil;

}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
