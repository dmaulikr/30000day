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
#import "CalendarTableViewCell.h"
#import "AllRemindViewController.h"
#import "CountDownTableViewCell.h"

//#define  CHOOSE_AGE_STRING    [Common isObjectNull:[Common readAppDataForKey:USER_CHOOSE_AGENUMBER]] ? @"80" : [Common readAppDataForKey:USER_CHOOSE_AGENUMBER] //用户所选择的年龄比如:100、90、80

@interface CalendarViewController () < QGPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *remindDataArray;

@property (nonatomic,strong) NSDate *selectorDate;//表示选中的日期，如果没选中，那么默认是今天

@property (nonatomic,strong) AgeTableViewCell *birthdayCell;

@property (nonatomic,strong) AgeTableViewCell *ageCell;

@property (nonatomic,strong) CountDownTableViewCell *countDownCell;

@property (nonatomic,strong) CalendarTableViewCell *calendarCell;//日期cell

@property (nonatomic,copy) NSString *chooseDateString;//比如2015-05-12等等

@property (nonatomic,strong) NSDate *countDownDate;//倒计时

@property (nonatomic,strong) NSDate *countDownbuttonDate;//倒计时日期

@end

// 选一个有意义的日期作倒计时（备注：可添加多个？）
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectorDate = [NSDate date];//默认选中的日期是今天
    
    self.remindDataArray = [[NSMutableArray alloc] init];
    
    //重新刷新日历和tableView前两个section数据
    [self reloadShowCalendarDateWith:self.selectorDate];
    
    //下载提醒数据
    [self loadTableViewData];
    
    //监听通知
    [STNotificationCenter addObserver:self selector:@selector(reloadDate) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(deleteOrChangeData) name:STDidSuccessDeleteRemindSendNotification object:nil];
    
    [STNotificationCenter addObserver:self selector:@selector(deleteOrChangeData) name:STDidSuccessChangeOrAddRemindSendNotification object:nil];
}

- (void)deleteOrChangeData {
    
    [self loadTableViewData];
    
    //刷新日历的界面
    [self.calendarCell.calendar reloadData];
}

- (void)reloadDate {
    
    [self reloadShowCalendarDateWith:self.selectorDate];
}

//添加提醒按钮点击事件
- (void)addRemindAction {
    
    AddRemindViewController *controller = [[AddRemindViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    controller.changeORAdd = NO;//表示是新增的
    
    [self.navigationController pushViewController:controller animated:YES];
}

//刷新整个日历天数的显示
- (void)reloadShowCalendarDateWith:(NSDate *)selectorDate {
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {
    
        self.birthdayCell.titleLabel.text = @"请在个人信息里设置生日";
        
        self.ageCell.titleLabel.text = @"请设置个人生日";
        
    } else {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
        
        NSString *selectorDateString = [formatter stringFromDate:selectorDate];
        
        NSString *todayString = [formatter stringFromDate:[NSDate date]];
        
        if ([todayString isEqualToString:selectorDateString]) {//如果选中的日期是今天
            
//            self.calendarCell.todayButton.hidden = YES;
            
        } else {
            
//            self.calendarCell.todayButton.hidden = NO;
        }
        
        NSDate *selectorNewDate = [formatter dateFromString:selectorDateString];
        
        NSDate *birthdayDate = [formatter dateFromString:STUserAccountHandler.userProfile.birthday];
        
        NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
        
        NSString *age = [Common isObjectNull:userConfigure[@"Age"]] ? @"80" : userConfigure[@"Age"];
        
        NSDate *chooseAgeDate = [NSDate dateWithTimeInterval:[age  doubleValue]*365*24*60*60 sinceDate:birthdayDate];
        
        NSTimeInterval interval = [chooseAgeDate timeIntervalSinceDate:selectorNewDate];
        
        int dayNumber = interval/86400.0f;
        
        self.ageCell.titleLabel.text = [NSString stringWithFormat:@"从今天到所选岁数还有%d天。",dayNumber];
        
        NSTimeInterval birthdayInterval = [selectorNewDate timeIntervalSinceDate:birthdayDate];
        
        int birthdayNumber = birthdayInterval/86400.0f;
        
        self.birthdayCell.titleLabel.text = [NSString stringWithFormat:@"您出生到这天过去了%d天。",birthdayNumber];
        
        
    }
    
    NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
    
    NSString *age = [Common isObjectNull:userConfigure[@"Age"]] ? @"80" : userConfigure[@"Age"];
    
    [self.ageCell.ageButton setTitle:[NSString stringWithFormat:@"%@岁",age] forState:UIControlStateNormal];//显示用户选择的年龄
    
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy年MM月dd日"];
    
    NSString *dateTime = userConfigure[COUNTDOWN] == nil ? [formatter stringFromDate:[NSDate date]]:userConfigure[COUNTDOWN];
    
    self.countDownbuttonDate = [formatter dateFromString:dateTime];
    
    [self.countDownCell.timeButton setTitle:[NSString stringWithFormat:@"%@",dateTime] forState:UIControlStateNormal];

    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned int unitFlags = NSCalendarUnitDay;
    
    NSString *stringTime = [formatter stringFromDate:[NSDate date]];
    
    NSDate *date = [formatter dateFromString:stringTime];
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self.countDownDate == nil ? date:self.countDownDate toDate:self.countDownbuttonDate == nil ? date:self.countDownbuttonDate options:0];
    
    [self.countDownCell.countDownLable setText:[NSString stringWithFormat:@"从今天到所选日期还有%ld天。",[comps day]]];
    
    [self.tableView reloadData];
}

- (AgeTableViewCell *)birthdayCell {
    
    if (!_birthdayCell) {
        
        _birthdayCell =  [[[NSBundle mainBundle] loadNibNamed:@"AgeTableViewCell" owner:nil options:nil] lastObject];
  
        [_birthdayCell.ageButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    return _birthdayCell;
}

- (AgeTableViewCell *)ageCell {
    
    if (!_ageCell) {
        
        _ageCell = [[[NSBundle mainBundle] loadNibNamed:@"AgeTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    __weak typeof(self) weakSelf = self;
    
    //点击age的回调
    [_ageCell setChooseAgeBlock:^{
        
        QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
        
        picker.delegate = weakSelf;
        
        picker.titleText = @"选择年龄";
        
        //算出当前userId的年龄
        if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {//user生日没设置
            
            NSMutableArray *dataArray = [NSMutableArray array];
            
            for (int i = 200 ; i >= 1; i--) {
                
                [dataArray addObject:[NSString stringWithFormat:@"%d岁",i]];
            }
            
            NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
            
            NSString *age = [Common isObjectNull:userConfigure[@"Age"]] ? @"80" : userConfigure[@"Age"];
            
            //显示QGPickerView
            [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:[NSString stringWithFormat:@"%@岁",age] selectedTitle:nil selectedTitle:nil];
            
        } else {//user生日设置了
            
            NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
            
            NSDate *birthday = [formatter dateFromString:STUserAccountHandler.userProfile.birthday];
            
            NSDate *currentDay = [NSDate date];
            
            NSString *currentDayString = [formatter stringFromDate:currentDay];
            
            currentDay = [formatter dateFromString:currentDayString];
            
            NSTimeInterval interval = [currentDay timeIntervalSinceDate:birthday];
            
            int age = interval / (60*60*24*365);
            
            NSMutableArray *dataArray = [NSMutableArray array];
            
            for (int i = 200 ; i >= age ; i--) {
                
                [dataArray addObject:[NSString stringWithFormat:@"%d岁",i]];
            }
            
            NSDictionary *userConfigure = [Common readAppDataForKey:USER_CHOOSE_AGENUMBER];
            
            NSString *userAge = [Common isObjectNull:userConfigure[@"Age"]] ? @"80" : userConfigure[@"Age"];
            
            //显示QGPickerView
            [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:[NSString stringWithFormat:@"%@岁",userAge] selectedTitle:nil selectedTitle:nil];
        }
    }];
    
    return _ageCell;
}

- (CountDownTableViewCell *)countDownCell {
    
    if (!_countDownCell) {
        
        _countDownCell =  [[[NSBundle mainBundle] loadNibNamed:@"CountDownTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    __weak typeof(self) weakSelf = self;
    
    [_countDownCell setChooseAgeBlock:^{
       
        QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
        
        [picker setTag:1];
        
        picker.delegate = weakSelf;
        
        picker.titleText = @"选择年龄";
        
        [picker showDataPickView:[UIApplication sharedApplication].keyWindow  WithDate:nil datePickerMode:UIDatePickerModeDate minimumDate:[NSDate date] maximumDate:[NSDate dateWithTimeIntervalSinceNow:(500.00000*365.00000*24.000000*60.00000*60.00000)]];
        
    }];
    
    return _countDownCell;
}

- (CalendarTableViewCell *)calendarCell {
    
    if (!_calendarCell) {
        
        _calendarCell = [[CalendarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalendarTableViewCell"];
        
        __weak typeof(self) weakSelf = self;
        
        //选择日期回调
        [_calendarCell setChooseDateBlock:^(NSInteger tag) {
            
            if (tag == 1) {//选择时间
                
                [weakSelf chooseDate];
                
            } else if (tag == 2) {//增加提醒
                
                [weakSelf addRemindAction];
                
            } else if (tag == 3) {//点击今天按钮回调
                
                [weakSelf reloadShowCalendarDateWith:[NSDate date]];
            }
        }];
        
        //点击了日历的时间回调
        [_calendarCell setDateBlock:^(NSDate *chooseDate) {
            
            weakSelf.selectorDate = chooseDate;
            
            weakSelf.countDownDate = chooseDate;
            
            //刷新日期的控件
            [weakSelf reloadShowCalendarDateWith:weakSelf.selectorDate];
            
            [weakSelf loadTableViewData];
            
        }];
        
        //点击所有的提醒回调
        [_calendarCell setAllBlock:^{
           
            AllRemindViewController *controller = [[AllRemindViewController alloc] init];
            
            controller.hidesBottomBarWhenPushed = YES;
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        
    }
    return _calendarCell;
}

//选择日期
- (void)chooseDate {
    
    [self.view endEditing:YES];
    
    QGPickerView *chooseDatePickView = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    chooseDatePickView.delegate = self;
    
    chooseDatePickView.titleText = @"选择日期";
    
    self.chooseDateString = @"";
    
    //显示QGPickerView
    [chooseDatePickView showDataPickView:[UIApplication sharedApplication].keyWindow WithDate:self.selectorDate datePickerMode:UIDatePickerModeDate minimumDate:[NSDate dateWithTimeIntervalSinceNow:-(100.00000*365.00000*24.000000*60.00000*60.00000)] maximumDate:[NSDate dateWithTimeIntervalSinceNow:(100.00000*365.00000*24.000000*60.00000*60.00000)]];
}


#pragma -----
#pragma mark -- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    NSMutableDictionary *userConfigure =  [NSMutableDictionary dictionaryWithDictionary:[Common readAppDataForKey:USER_CHOOSE_AGENUMBER]];
    
    if (userConfigure == nil) {
        
        userConfigure = [NSMutableDictionary dictionary];
        
    }
    
    [userConfigure setObject:[[value componentsSeparatedByString:@"岁"] firstObject] forKey:@"Age"];
    
    [Common saveAppDataForKey:USER_CHOOSE_AGENUMBER withObject:userConfigure];//保存到沙盒里
    
    [self reloadShowCalendarDateWith:self.selectorDate];
}

- (void)didSelectPickView:(QGPickerView *)pickView selectDate:(NSDate *)selectorDate {
    
    if (pickView.tag == 1) {
        
        self.countDownDate = selectorDate;
        
        self.countDownbuttonDate = selectorDate;
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy年MM月dd日"];
        
        NSString *timeString = [formatter stringFromDate:selectorDate] == nil ? [formatter stringFromDate:[NSDate date]]:[formatter stringFromDate:self.countDownDate];
        
        [self.countDownCell.timeButton setTitle:[NSString stringWithFormat:@"%@",timeString] forState:UIControlStateNormal];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        unsigned int unitFlags = NSCalendarUnitDay;

        NSDateComponents *comps = [gregorian components:unitFlags fromDate:self.selectorDate == nil ? [NSDate date]:self.selectorDate toDate:selectorDate options:0];

        [self.countDownCell.countDownLable setText:[NSString stringWithFormat:@"从今天到所选日期还有%ld天。",[comps day]]];
        
        
        NSMutableDictionary *userConfigure = [NSMutableDictionary dictionaryWithDictionary:[Common readAppDataForKey:USER_CHOOSE_AGENUMBER]];
        
        if (userConfigure == nil) {
            
            userConfigure = [NSMutableDictionary dictionary];
            
        }
        
        [userConfigure setObject:[formatter stringFromDate:selectorDate] forKey:COUNTDOWN];
        
        [Common saveAppDataForKey:USER_CHOOSE_AGENUMBER withObject:userConfigure];//保存到沙盒里
        
        
    } else {
    
        self.selectorDate = selectorDate;
        
        [self.calendarCell.calendar selectDate:self.selectorDate scrollToDate:YES];
        
    }
}

#pragma -----
#pragma mark --- UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 3;
        
    } else if (section == 2) {
        
        return self.remindDataArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [CalendarTableViewCell getCalendarTableViewCellHeight];
        
    } else if (indexPath.section == 1) {
        
        return 44.0f;
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 10.0f;
    }

    return 0.005f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {

        return self.calendarCell;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            return self.birthdayCell;
            
        } else if (indexPath.row == 1) {
            
            return self.ageCell;
            
        } else {
        
            return self.countDownCell;
        
        }
        
    } else if (indexPath.section == 2) {
        
        RemindContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindContentTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindContentTableViewCell" owner:nil options:nil] lastObject];
        }
        
        RemindModel *model = [self.remindDataArray objectAtIndex:indexPath.row];
    
        cell.model = model;
        
        cell.longPressIndexPath = indexPath;
        
        //长按出现删除界面
        [cell setLongPressBlock:^(NSIndexPath *longPressIndexPath) {
            
            UIAlertController *alertControlller = [UIAlertController alertControllerWithTitle:@"删除提醒" message:model.content preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //删除数据库里面的东西
                [[STRemindManager shareRemindManager] deleteOjbectWithModel:[self.remindDataArray objectAtIndex:indexPath.row]];
                
                //重新下载数据
                [self loadTableViewData];
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [alertControlller addAction:sureAction];
            
            [alertControlller addAction:cancelAction];
            
            [self presentViewController:alertControlller animated:YES completion:nil];
            
        }];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        AddRemindViewController *controller = [[AddRemindViewController alloc] init];
        
        controller.oldModel = [self.remindDataArray objectAtIndex:indexPath.row];
        
        controller.changeORAdd = YES;//表示修改的
        
        controller.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//下载self.tableView的数据
- (void)loadTableViewData {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    
    NSString *selectorDateString = [formatter stringFromDate:self.selectorDate];
    
    self.remindDataArray = [[STRemindManager shareRemindManager] allRemindModelWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] dateString:selectorDateString];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessDeleteRemindSendNotification object:nil];
    
    [STNotificationCenter removeObserver:self name:STDidSuccessChangeOrAddRemindSendNotification object:nil];
    
    self.remindDataArray = nil;
    
    self.selectorDate = nil;
    
    self.birthdayCell = nil;
    
    self.ageCell = nil;
    
    self.calendarCell = nil;
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
