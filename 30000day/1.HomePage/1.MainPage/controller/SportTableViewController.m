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

@interface SportTableViewController () <UITableViewDelegate,UITableViewDataSource>

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

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 1;
        
    } else {
    
        return 1;
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
    
    return 44;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SportTableViewCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SportTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    [cell setButtonBlock:^(UIButton *btn) {
       
        SportTrajectoryViewController *controller = [[SportTrajectoryViewController alloc] init];
        
        [self.navigationController presentViewController:controller animated:YES completion:nil];
        
    }];
    
    return cell;

}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
