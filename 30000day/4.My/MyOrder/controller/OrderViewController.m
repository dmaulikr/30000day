//
//  OrderViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "OrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "MTProgressHUD.h"

@interface OrderViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0.5f)];
    
    lineView.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    
    [self.view addSubview:lineView];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.isShowFootRefresh = NO;
    
    [self loadDataFromServer];
}

- (void)loadDataFromServer {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    [self.dataHandler sendFindOrderUserId:STUserAccountHandler.userProfile.userId type:@1 Success:^(NSMutableArray *success) {
        
        self.dataArray = success;
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
       [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)headerRefreshing {
    
    [self loadDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark ---- UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.orderModel = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 122;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
