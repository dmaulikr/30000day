//
//  AllRemindViewController.m
//  30000day
//
//  Created by GuoJia on 16/5/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  所有的提醒界面

#import "AllRemindViewController.h"
#import "STRemindManager.h"
#import "RemindContentTableViewCell.h"
#import "AddRemindViewController.h"

@interface AllRemindViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation AllRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isShowBackItem = YES;
    
    self.tableViewStyle = STRefreshTableViewPlain;
    
    self.tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.title = @"所有的提醒";
    
    [self loadRemindDataFromCoreData];
}

- (void)loadRemindDataFromCoreData {
    
    self.dataArray = [[STRemindManager shareRemindManager] allRemindModelWithUserId:STUserAccountHandler.userProfile.userId];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark -- UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RemindContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindContentTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindContentTableViewCell" owner:nil options:nil] lastObject];
    }
    
    RemindModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddRemindViewController *controller = [[AddRemindViewController alloc] init];
    
    controller.oldModel = [self.dataArray objectAtIndex:indexPath.row];
    
    controller.changeORAdd = YES;//表示修改的
    
    controller.hidesBottomBarWhenPushed = YES;
    
    //成功增加或者修改的一些回调
    [controller setSaveOrChangeSuccessBlock:^{
        
        [self loadRemindDataFromCoreData];
        
    }];
    
    //成功删除一条提醒的回调
    [controller setDeleteSuccessBlock:^{
        
        [self loadRemindDataFromCoreData];
        
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
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
