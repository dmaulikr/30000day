//
//  SearchWriterViewController.m
//  30000day
//
//  Created by GuoJia on 16/4/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchWriterViewController.h"
#import "InformationWriterHomepageViewController.h"
#import "SubscribeTableViewCell.h"
#import "InformationWriterModel.h"

@interface SearchWriterViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *searchResultArray;//搜索结果数组

@property (nonatomic,assign) BOOL isSearch;//搜索状态

@end

@implementation SearchWriterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索中心";
    
    self.isSearch = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.searchBar becomeFirstResponder];
    
    self.searchBar.placeholder = @"输入作者名字/账号";
    
    self.isChangeSearchBarHeight = NO;
    
    [self.cancelButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
}

#pragma ---
#pragma mark ---- 父视图的生命周期方法
- (void)searchBarDidBeginRestore:(BOOL)isAnimation  {
    
    [super searchBarDidBeginRestore:isAnimation];
    
    self.isSearch = NO;
    
    [self.tableView reloadData];
}

#pragma ---
#pragma mark --- UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    //意思是如果搜素的string为空那么就是不处于搜索状态，反之亦然
    self.isSearch = [Common isObjectNull:self.searchBar.text] ? NO : YES;
    
    if (self.isSearch) {
        
        [self.dataHandler sendSearchWriterListWithWriterName:self.searchBar.text userId:[NSString stringWithFormat:@"%d",STUserAccountHandler.userProfile.userId.intValue] success:^(NSMutableArray *success) {
            
            self.searchResultArray = success;
            
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            
            [self ShowAlert:@"服务器走神了"];
        }];
    }
    
    [searchBar resignFirstResponder];
}

#pragma ---
#pragma mark --- UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.isSearch ? self.searchResultArray.count : 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *searchResultIdentifier = @"SubscribeTableViewCell";
    
    SubscribeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchResultIdentifier];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:searchResultIdentifier owner:self options:nil] lastObject];
    }
    
    InformationWriterModel *model = self.searchResultArray[indexPath.row];
    
    //点击订阅回调
    [cell setClickActionBlock:^(UIButton *subcribeButton) {
        
        if (model.isMineSubscribe == 0) {//订阅操作
            
            [self.dataHandler sendSubscribeWithWriterId:model.writerId userId:[STUserAccountHandler.userProfile.userId stringValue] success:^(BOOL success) {
                
                model.isMineSubscribe = 1;
                
                [subcribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
                
                [STNotificationCenter postNotificationName:STDidSuccessSubscribeSendNotification object:NSStringFromClass([self class])];
                
            } failure:^(NSError *error) {
                
                [self showToast:@"订阅失败"];
                
            }];
            
        } else {
            
            [self.dataHandler sendCancelSubscribeWriterId:model.writerId userId:[STUserAccountHandler.userProfile.userId stringValue] success:^(BOOL success) {
                
                model.isMineSubscribe = 0;
                
                [subcribeButton setTitle:@"订阅" forState:UIControlStateNormal];
                
                [STNotificationCenter postNotificationName:STDidSuccessCancelSubscribeSendNotification object:NSStringFromClass([self class])];
                
            } failure:^(NSError *error) {
                
                [self showToast:@"取消失败"];
                
            }];
        }
        
    }];
    
    cell.writerModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InformationWriterModel *model = self.searchResultArray[indexPath.row];
    
    InformationWriterHomepageViewController *controller = [[InformationWriterHomepageViewController alloc] init];
    
    controller.writerId = model.writerId;
    
    [self.navigationController pushViewController:controller animated:YES];
    
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
