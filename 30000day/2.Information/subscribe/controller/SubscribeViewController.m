//
//  SubscribeViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeViewController.h"
#import "SubscribeListTableViewCell.h"
#import "MySubscribeViewController.h"

@interface SubscribeViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) BOOL isSearch;

@property (nonatomic ,strong) NSMutableArray *dataArray;

@end

@implementation SubscribeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订阅中心";
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.isSearch = NO;
    
    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"我的订阅" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarbuttonAction)];
    
    rightBarbutton.tintColor = [UIColor darkGrayColor];
    
    self.navigationItem.rightBarButtonItem = rightBarbutton;
}

- (void)rightBarbuttonAction {
    
    MySubscribeViewController *controller = [[MySubscribeViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---
#pragma mark ---- 父类控制器的调用方法
//键盘搜索按钮点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.isSearch = [searchBar.text isEqualToString:@""] ? NO : YES;
    
    self.dataArray = [NSMutableArray array];
    
    [self.tableView reloadData];
}

- (void)searchBarDidBeginRestore {
    
    [super searchBarDidBeginRestore];
    
    self.isSearch = NO;
    
    [self.tableView reloadData];
}

#pragma ----
#pragma mark --- UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        
        return self.dataArray.count;
        
    } else {
        
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SubscribeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubscribeListTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SubscribeListTableViewCell" owner:nil options:nil] lastObject];
    }
    if (indexPath.row > 4) {
        
        [cell.actionButton setImage:[UIImage imageNamed:@"icon_subscribe"] forState:UIControlStateNormal];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 81.0f;
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
