//
//  AppointmentViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentViewController.h"
#import "QGPickerView.h"
#import "AppointmentConfirmViewController.h"
#import "AppointmentTableViewCell.h"

@interface AppointmentViewController () <QGPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT- 64);

    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    //1.设置选择时间的标题按钮
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [timeButton setTitle:@"03-01/周三" forState:UIControlStateNormal];
    
    [timeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = timeButton;
    
    //3.预约下一步
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(submitAppoinmentAction:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

#pragma ---
#pragma mark --- 父类的方法
- (void)headerRefreshing {
 
    [self.tableView.mj_header endRefreshing];
}

- (void)timeButtonAction:(UIButton *)timeButton {
    
    QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    picker.delegate = self;
    
    picker.titleText = @"选择预约日期";
    
    [picker showDataPickView:[UIApplication sharedApplication].keyWindow WithDate:[NSDate date] datePickerMode:UIDatePickerModeDate minimumDate:[NSDate date] maximumDate:[NSDate dateWithTimeIntervalSinceNow:(10.0000000*24.000000*60.00000*60.00000)]];
}

#pragma ----
#pragma mark --- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView selectDate:(NSDate *)selectorDate {
    
}

- (void)submitAppoinmentAction:(id)sender {
    
    AppointmentConfirmViewController *controller = [[AppointmentConfirmViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma ---
#pragma mark --- UITableViewDataSource/UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentTableViewCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AppointmentTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    //2.设置预约表格视图

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 327;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
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
