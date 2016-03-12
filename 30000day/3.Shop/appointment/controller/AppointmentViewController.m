//
//  AppointmentViewController.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentViewController.h"
#import "QGPickerView.h"
#import "AppointmentCollectionView.h"

@interface AppointmentViewController () <QGPickerViewDelegate,AppointmentCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet AppointmentCollectionView *appointmentView;

@end

@implementation AppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.设置选择时间的标题按钮
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [timeButton setTitle:@"03-01/周三" forState:UIControlStateNormal];
    
    [timeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [timeButton addTarget:self action:@selector(timeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = timeButton;
    
    //2.设置预约表格视图
    self.appointmentView.dataArray = [NSMutableArray arrayWithArray:@[@"1号场",@"2号场",@"3号场",@"4号场",@"5号场",@"6号场",@"7号场",@"8号场"]];
    
    self.appointmentView.time_dataArray = [NSMutableArray arrayWithArray:@[@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00"]];
    
    self.appointmentView.delegate = self;
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

- (IBAction)submitAppoinmentAction:(id)sender {
    
    
    
}

#pragma ---
#pragma mark --- AppointmentCollectionViewDelegate

- (void)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView didSelectionAppointmentIndexPath:(NSIndexPath *)indexPath {
    
    
    
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
