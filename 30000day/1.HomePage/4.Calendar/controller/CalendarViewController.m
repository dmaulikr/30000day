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
#import "FSCalendar.h"

@interface CalendarViewController () <QGPickerViewDelegate,FSCalendarDataSource, FSCalendarDelegate>
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *lunarCalendar;

@property (strong, nonatomic) NSArray *lunarChars;

@end

// 选一个有意义的日期作倒计时（备注：可添加多个？）
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FSCalendar *calender = [[FSCalendar alloc] initWithFrame:CGRectMake(1, 75, SCREEN_WIDTH - 1, 300)];
    
    calender.dataSource = self;
    
    calender.delegate = self;
    
    calender.layer.cornerRadius = 5;
    
    calender.layer.masksToBounds = YES;
    
    calender.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    
    calender.scrollDirection = FSCalendarScrollDirectionVertical;
    
    calender.appearance.subtitleVerticalOffset = 3;
    
    calender.appearance.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    
    [self.view addSubview:calender];
    
    self.calendar = calender;
    
    _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    _lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
    
    //监听通知
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
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
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.calendar.scope == FSCalendarScopeMonth) {
        
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
        
    } else {
        
        [self.calendar setScope:FSCalendarScopeMonth animated:YES];
    }
}

- (void)swipeAction:(UISwipeGestureRecognizer *)swipe {
    
    if (self.calendar.scope == FSCalendarScopeMonth) {
        
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
        
    } else {
        
        [self.calendar setScope:FSCalendarScopeMonth animated:YES];
    }
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    
    calendar.height = CGRectGetHeight(bounds);
    
    [self.view layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[calendar stringFromDate:date format:@"yyyy/MM/dd"]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    
    NSInteger day = [_lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
    return _lunarChars[day-1];
}



- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [calendar stringFromDate:calendar.currentPage]);
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
//}


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
