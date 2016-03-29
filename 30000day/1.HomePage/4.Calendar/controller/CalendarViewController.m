//
//  CalendarViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CalendarViewController.h"
#import "AddRemindViewController.h"
#import "AgeTableViewCell.h"
#import "RemindContentTableViewCell.h"
#import "CalendarTableViewCell.h"
#import "AgeTableViewCell.h"

@interface CalendarViewController () < QGPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

@end

// 选一个有意义的日期作倒计时（备注：可添加多个？）
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //监听通知
//    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
//
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
//    
//    swipe.direction = UISwipeGestureRecognizerDirectionUp;
//    
//    [self.view addGestureRecognizer:swipe];
//
//    UISwipeGestureRecognizer *swipe_1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
//    
//    swipe_1.direction = UISwipeGestureRecognizerDirectionDown;
//    
//    [self.view addGestureRecognizer:swipe_1];
    
    //2.scrollView
//    CalendarScrollView *scrollView = [[CalendarScrollView alloc] initWithFrame:CGRectMake(0,370.0f, SCREEN_WIDTH, SCREEN_HEIGHT - 365 - 44)];
//    
//    [scrollView setMoveBlock:^{
//       
//        if (self.calendar.scope == FSCalendarScopeMonth) {
//            
//            [self.calendar setScope:FSCalendarScopeWeek animated:YES];
//            
//        } else {
//            
//            [self.calendar setScope:FSCalendarScopeMonth animated:YES];
//        }
//        
//    }];
//    
//    self.scrollView = scrollView;//保存scrollView
//    
//    [self.view addSubview:scrollView];
}



//#pragma -----
//#pragma mark -- QGPickerViewDelegate
//
//- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
//    
//    [self.ageCell.ageButton setTitle:value forState:UIControlStateNormal];
//    
//    self.chooseAgeString = [[value componentsSeparatedByString:@"岁"] firstObject];
//    
//    [self reloadShowCalendarDateWith:self.selectorDate];
//}
//
//- (void)didSelectPickView:(QGPickerView *)pickView selectDate:(NSDate *)selectorDate {
//    
//    self.selectorDate = selectorDate;
//
//    self.chooseDateString = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:selectorDate];
//    
//    self.selectorDate = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:self.chooseDateString];
//
//}


////选中日期按钮的点击事件
//- (IBAction)selectorDateAction:(id)sender {
//    
//    [self chooseDate];
//    
//}
//
////选择日期
//- (void)chooseDate {
//    
//    [self.view endEditing:YES];
//    
//    QGPickerView *chooseDatePickView = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
//    
//    chooseDatePickView.delegate = self;
//    
//    chooseDatePickView.titleText = @"选择日期";
//    
//    self.chooseDateString = @"";
//    
//    //显示QGPickerView
//    [chooseDatePickView showDataPickView:[UIApplication sharedApplication].keyWindow WithDate:self.selectorDate datePickerMode:UIDatePickerModeDate minimumDate:[NSDate dateWithTimeIntervalSinceNow:-(100.00000*365.00000*24.000000*60.00000*60.00000)] maximumDate:[NSDate dateWithTimeIntervalSinceNow:(100.00000*365.00000*24.000000*60.00000*60.00000)]];
//}
//
//
////添加提醒按钮点击事件
//- (IBAction)addRemindAction:(id)sender {
//    
//    AddRemindViewController *controller = [[AddRemindViewController alloc] init];
//    
//    controller.hidesBottomBarWhenPushed = YES;
//    
//    controller.changeORAdd = NO;//表示是新增的
//    
//    [controller setSaveOrChangeSuccessBlock:^{
//       
//        [self loadTableViewData];
//        
//        [self.tableView reloadData];
//        
//    }];
//    
//    [self.navigationController pushViewController:controller animated:YES];
//    
//}
//
//
////刷新整个日历天数的显示
//- (void)reloadShowCalendarDateWith:(NSDate *)selectorDate {
//    
//    if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {
//    
//        self.birthdayCell.textLabel.text = @"您还没有设置您的生日,请在个人信息里设置生日";
//        
//        self.ageCell.titleLabel.text = @"请设置个人生日";
//        
//    } else {
//        
//        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
//        
//        NSString *selectorDateString = [formatter stringFromDate:selectorDate];
//        
//        NSString *todayString = [formatter stringFromDate:[NSDate date]];
//        
//        if ([todayString isEqualToString:selectorDateString]) {//如果选中的日期是今天
//            
//            self.chooseTodayButton.hidden = YES;
//            
//        } else {
//            
//            self.chooseTodayButton.hidden = NO;
//        }
//        
//        NSDate *selectorNewDate = [formatter dateFromString:selectorDateString];
//        
//        NSDate *birthdayDate = [formatter dateFromString:STUserAccountHandler.userProfile.birthday];
//        
//        NSDate *chooseAgeDate = [NSDate dateWithTimeInterval:[self.chooseAgeString doubleValue]*365*24*60*60 sinceDate:birthdayDate];
//        
//        NSTimeInterval interval = [chooseAgeDate timeIntervalSinceDate:selectorNewDate];
//        
//        int dayNumber = interval/86400.0f;
//        
//        self.ageCell.titleLabel.text = [NSString stringWithFormat:@"从今天到所选岁数还有%d天。",dayNumber];
//        
//        NSTimeInterval birthdayInterval = [selectorNewDate timeIntervalSinceDate:birthdayDate];
//        
//        
//        int birthdayNumber = birthdayInterval/86400.0f;
//        
//        self.birthdayCell.textLabel.text = [NSString stringWithFormat:@"您出生到这天过去了%d天。",birthdayNumber];
//        
//    }
//    
//    //拿出来重写是因为就算不设置生日有会显示该按钮
//    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
//    
//    NSString *selectorDateString = [formatter stringFromDate:selectorDate];
//    
//    //刷新上面的当前选择的日期button
//    [self.dateTtitleButton setTitle:selectorDateString forState:UIControlStateNormal];
//    
//    [self.tableView reloadData];
//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        CalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[CalendarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarTableViewCell"];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            AgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgeTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"AgeTableViewCell" owner:self options:nil] lastObject];
            }
            
            cell.titleLabel.text = @"从您出生到这天过去了16814天";
            
            [cell.ageButton setImage:[UIImage imageNamed:@"icon_add_events"] forState:UIControlStateNormal];
            
            [cell.ageButton setTitle:@"" forState:UIControlStateNormal];
            
            return cell;
            
        } else if (indexPath.row == 1) {
            
            AgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgeTableViewCell"];
            
            if (cell == nil) {
                
                cell = [[[NSBundle mainBundle] loadNibNamed:@"AgeTableViewCell" owner:self options:nil] lastObject];
            }
            
            cell.titleLabel.text = @"从今天到所选岁数还有-16815天";
            
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 300;
        
    } else if (indexPath.section == 1) {
        
        return 44;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
