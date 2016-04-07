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
#import "AppointmentModel.h"
#import "MTProgressHUD.h"

@interface AppointmentViewController () <QGPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *timeButton;

@property (nonatomic,strong) NSDate *selectorDate;//记住选中的日期

@property (nonatomic,strong) NSMutableArray *dataArray;//数据源数组

@property (nonatomic,strong) AppointmentTableViewCell *productPriceCell;

@property (nonatomic,strong) NSMutableArray *timeModelArray;

@property (nonatomic,strong) UIButton *conformButton;

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
    
    self.selectorDate = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:@"2016-04-01"];
    
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
    
    self.timeModelArray = [NSMutableArray array];
    
    //3.添加预约按钮
    self.conformButton = [Common addAppointmentBackgroundView:self.view title:@"确认订单" selector:@selector(goToConformController) controller:self];
    
    [self.conformButton setBackgroundImage:[Common imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [self judgeConformButtonCanUse];
}

//2.从服务器下载数据
- (void)loadDataFromServer {
    
    [MTProgressHUD showHUD:[UIApplication sharedApplication].keyWindow];
    
    [self.dataHandler sendFindOrderCanAppointmentWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] productId:self.productId date:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:self.selectorDate] Success:^(NSMutableArray *success) {
        
        self.dataArray = success;
        
        [self.tableView reloadData];
        
        self.timeModelArray = [NSMutableArray array];
        
        [self.productPriceCell clearCell];//清除数据
        
        [self.tableView.mj_header endRefreshing];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    } failure:^(NSError *error) {
    
        [self.tableView.mj_header endRefreshing];
        
        [MTProgressHUD hideHUD:[UIApplication sharedApplication].keyWindow];
        
    }];
}

//前往确认订单界面
- (void)goToConformController {
    
    AppointmentConfirmViewController *controller = [[AppointmentConfirmViewController alloc] init];
    
    controller.selectorDate = self.selectorDate;
    
    controller.timeModelArray = self.timeModelArray;
    
    controller.productId = self.productId;
        
    controller.productName = self.productName;
    
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

- (AppointmentTableViewCell *)productPriceCell {
    
    if (!_productPriceCell) {
        
       _productPriceCell =  [[[NSBundle mainBundle] loadNibNamed:@"AppointmentTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    return _productPriceCell;
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

    [self loadDataFromServer];
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
        
        //点击了预约的回调
        [cell setClickBlock:^(NSMutableArray *timeModelArray) {
           
            self.timeModelArray = timeModelArray;
            
            self.productPriceCell.timeModelArray = timeModelArray;//给统计cell赋值
            
            [self judgeConformButtonCanUse];

        }];
        
        return cell;
        
    } else {
    
        return self.productPriceCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        AppointmentModel *model = [self.dataArray firstObject];
        
        return [AppointmentTableViewCell cellHeightWithTimeArray:model.timeRangeList];
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

//判断确认订单是否可用
- (void)judgeConformButtonCanUse {
    
    if (self.timeModelArray.count) {
        
        self.conformButton.enabled = YES;
        
    } else {
        
        self.conformButton.enabled = NO;
    }
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
