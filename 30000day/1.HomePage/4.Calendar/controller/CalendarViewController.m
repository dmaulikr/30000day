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

@property (nonatomic,strong) NSMutableArray *remindDataArray;

@property (nonatomic,strong) NSDate *selectorDate;//表示选中的日期，如果没选中，那么默认是今天

@property (nonatomic,strong) AgeTableViewCell *birthdayCell;

@property (nonatomic,strong) AgeTableViewCell *ageCell;

@end

// 选一个有意义的日期作倒计时（备注：可添加多个？）
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //监听通知
//    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];

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

- (AgeTableViewCell *)birthdayCell {
    
    if (!_birthdayCell) {
        
        _birthdayCell =  [[[NSBundle mainBundle] loadNibNamed:@"AgeTableViewCell" owner:nil options:nil] lastObject];
        
        _birthdayCell.titleLabel.text = @"从您出生到这天过去了16814天";
        
        [_birthdayCell.ageButton setImage:[UIImage imageNamed:@"icon_add_events"] forState:UIControlStateNormal];
        
        [_birthdayCell.ageButton setTitle:@"" forState:UIControlStateNormal];
        
    }
    
    return _birthdayCell;
}

- (AgeTableViewCell *)ageCell {
    
    if (!_ageCell) {
        
        _ageCell = [[[NSBundle mainBundle] loadNibNamed:@"AgeTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    _ageCell.titleLabel.text = @"从今天到所选岁数还有-16815天";
    
    __weak typeof(self) weakSelf = self;
    
    //点击age的回调
    [_ageCell setChooseAgeBlock:^{
        
        QGPickerView *picker = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
        
        picker.delegate = weakSelf;
        
        picker.titleText = @"选择年龄";
        
        //算出当前userId的年龄
        
        if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {//user生日没设置
            
            NSMutableArray *dataArray = [NSMutableArray array];
            
            for (int i = 100 ; i >= 1; i--) {
                
                [dataArray addObject:[NSString stringWithFormat:@"%d岁",i]];
                
            }
            
            //显示QGPickerView
            [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:@"80岁" selectedTitle:nil selectedTitle:nil];
            
        } else {//user生日设置了
            
            NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
            
            NSDate *birthday = [formatter dateFromString:STUserAccountHandler.userProfile.birthday];
            
            NSDate *currentDay = [NSDate date];
            
            NSString *currentDayString = [formatter stringFromDate:currentDay];
            
            currentDay = [formatter dateFromString:currentDayString];
            
            NSTimeInterval interval = [currentDay timeIntervalSinceDate:birthday];
            
            int age = interval / (60*60*24*365);
            
            NSMutableArray *dataArray = [NSMutableArray array];
            
            for (int i = 100 ; i >= age ; i--) {
                
                [dataArray addObject:[NSString stringWithFormat:@"%d岁",i]];
            }
            
            //显示QGPickerView
//            [picker showPickView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:[NSString stringWithFormat:@"%@岁",weakSelf.chooseAgeString] selectedTitle:nil selectedTitle:nil];
            
        }
    }];
    
    return _ageCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
        
    } else if (section == 1) {
        
        return 2;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 300;
        
    } else if (indexPath.section == 1) {
        
        return 44;
    }
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.0f;
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
            
            return self.birthdayCell;
            
        } else if (indexPath.row == 1) {
            
            return self.ageCell;
            
        }
        
    } else if (indexPath.section == 2) {
        
        RemindContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindContentTableViewCell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindContentTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        RemindModel *model = [self.remindDataArray objectAtIndex:indexPath.row];
        
        cell.contentLabel.text = model.title;
        
        cell.timeLabel.text = [self compareDateWithCurrentTodayWithDate:model.date];
        
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
    
    if (indexPath.section == 1) {
        
        AddRemindViewController *controller = [[AddRemindViewController alloc] init];
        
        controller.oldModel = [self.remindDataArray objectAtIndex:indexPath.row];
        
        controller.changeORAdd = YES;//表示修改的
        
        controller.hidesBottomBarWhenPushed = YES;
        
        //成功增加或者修改的一些回调
        [controller setSaveOrChangeSuccessBlock:^{
            
            [self loadTableViewData];
            
            [self.tableView reloadData];
            
        }];
        
        //成功删除一条提醒的回调
        [controller setDeleteSuccessBlock:^{
            
            [self loadTableViewData];
            
            [self.tableView reloadData];
            
        }];
        
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

/**
 * @pram date:创建提醒时候的date
 *
 * @return:比如：今天 12:12 昨天 12:12  2016-12-12 12:12
 **/
- (NSString *)compareDateWithCurrentTodayWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components =  [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    if (components.day == 1) {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
        
        return [NSString stringWithFormat:@"昨天 %@",[[[formatter stringFromDate:date] componentsSeparatedByString:@" "] lastObject]];
        
    } else if (components.day == 0) {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
        
        return [NSString stringWithFormat:@"今天 %@",[[[formatter stringFromDate:date] componentsSeparatedByString:@" "] lastObject]];
        
    } else {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
        
        return [formatter stringFromDate:date];
    }
    
    return @"";
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
