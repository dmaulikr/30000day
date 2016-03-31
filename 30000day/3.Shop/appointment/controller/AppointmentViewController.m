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

@property (nonatomic,strong) UIButton *timeButton;

@property (nonatomic,strong) NSDate *selectorDate;//记住选中的日期

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectorDate = [NSDate date];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT- 64);

    self.isShowBackItem = YES;
    
    self.isShowFootRefresh = NO;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    //1.设置选择时间的标题按钮
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    timeButton.frame = CGRectMake(0, 0, 150, 40);
    
    [timeButton setTitle:[self titleStringFromDate:[NSDate date]] forState:UIControlStateNormal];
    
    [timeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeButton = timeButton;
    
    self.navigationItem.titleView = timeButton;
    
    //3.预约下一步
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"预约" style:UIBarButtonItemStylePlain target:self action:@selector(submitAppoinmentAction:)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

//通过一个输入date来返回标题
- (NSString *)titleStringFromDate:(NSDate *)inputDate {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    
    NSString *title = [[formatter stringFromDate:inputDate] substringFromIndex:5];
    
    NSString *weekDayString = [Common weekdayStringFromDate:inputDate];
    
    return [NSString stringWithFormat:@"%@/%@",title,weekDayString];
}

- (void)timeButtonAction:(UIButton *)timeButton {
    
    QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    picker.delegate = self;
    
    picker.titleText = @"选择预约日期";
    
    [picker showDataPickView:[UIApplication sharedApplication].keyWindow WithDate:self.selectorDate datePickerMode:UIDatePickerModeDate minimumDate:[NSDate date] maximumDate:[NSDate dateWithTimeIntervalSinceNow:(7.0000000*10.0000000*24.000000*60.00000*60.00000)]];
}

- (void)submitAppoinmentAction:(id)sender {
    
    AppointmentConfirmViewController *controller = [[AppointmentConfirmViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma ----
#pragma mark --- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView selectDate:(NSDate *)selectorDate {
    
    self.selectorDate = selectorDate;
    
    [self.timeButton setTitle:[self titleStringFromDate:selectorDate] forState:UIControlStateNormal];
}

#pragma ---
#pragma mark --- 父类的方法
- (void)headerRefreshing {
 
    [self.tableView.mj_header endRefreshing];
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
