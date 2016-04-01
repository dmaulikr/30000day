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

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源数组

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.配置UI界面
    [self configUI];
    
    //2.下载数据
    [self loadDataFromServer];
}

//配置UI界面
- (void)configUI {
    
    self.selectorDate = [NSDate date];
    
    self.tableViewStyle = STRefreshTableViewGroup;
    
    self.tableView.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT- 64 - 50);
    
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
    
    //3.添加预约按钮
    [Common addAppointmentBackgroundView:self.view title:@"确认订单" selector:@selector(goToConfirmController) controller:self];
}

//2.从服务器下载数据
- (void)loadDataFromServer {
    
    [self.dataHandler sendFindOrderCanAppointmentWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] productId:self.productId date:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:self.selectorDate] Success:^(NSMutableArray *success) {
        
        self.dataArray = success;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
    
        
    }];
}

//前往确认订单界面
- (void)goToConfirmController {
    
    AppointmentConfirmViewController *controller = [[AppointmentConfirmViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:YES];
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
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AppointmentTableViewCell" owner:nil options:nil] firstObject];
            
        }
        //1.设置数据源数组
        cell.dataArray = self.dataArray;
        
        return cell;
        
    } else {
        
        AppointmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppointmentTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"AppointmentTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return [AppointmentTableViewCell cellHeightWithTimeArray:[NSMutableArray arrayWithArray:@[@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"16:30",@"17:00",@"17:30",@"18:00",@"18:30",@"19:00"]]];
    }
    return 44.0f;
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
