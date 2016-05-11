//
//  NewFriendsViewController.m
//  30000day
//
//  Created by GuoJia on 16/5/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "PersonTableViewCell.h"

@interface NewFriendsViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的朋友";
    self.isShowBackItem = YES;
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource / UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 72.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"PersonTableViewCell_fourth";
    
    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"PersonTableViewCell" owner:self options:nil][3];
    }
    
    return cell;
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
