//
//  STRedPacketListController.m
//  30000day
//
//  Created by GuoJia on 16/9/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STRedPacketListController.h"
#import "STRedPacketListCell.h"
#import "STShowRedPacketController.h"

@interface STRedPacketListController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation STRedPacketListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI {
    self.title = @"红包列表";
    self.tableViewStyle = STRefreshTableViewPlain;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma ---
#pragma mark --- UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STRedPacketListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STRedPacketListCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"STRedPacketListCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [STRedPacketListCell heightCellWithShowText:@"跑10000步，才可以领取红包"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    STShowRedPacketController *controller = [[STShowRedPacketController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
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
