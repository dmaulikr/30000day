//
//  STMediumRemindDetailController.m
//  30000day
//
//  Created by GuoJia on 16/10/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumRemindDetailController.h"

@interface STMediumRemindDetailController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation STMediumRemindDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI {
    self.title = @"自媒体详情";
    self.tableViewStyle = STRefreshTableViewGroup;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self  showHeadRefresh:NO showFooterRefresh:NO];
}

#pragma ----
#pragma mark --- UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
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
