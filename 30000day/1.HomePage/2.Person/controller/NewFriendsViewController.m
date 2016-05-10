//
//  NewFriendsViewController.m
//  30000day
//
//  Created by GuoJia on 16/5/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NewFriendsViewController.h"

@interface NewFriendsViewController ()

@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新的朋友";
    self.isShowBackItem = YES;
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
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
