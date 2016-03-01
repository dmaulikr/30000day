//
//  CalendarViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CalendarViewController.h"
#import "JBCalendarLogic.h"
#import "JBUnitView.h"
#import "JBUnitGridView.h"
#import "JBSXRCUnitTileView.h"
#import "AddRemindViewController.h"
#import "AgeTableViewCell.h"
#import "RemindContentTableViewCell.h"

@interface CalendarViewController () < JBUnitViewDelegate, JBUnitViewDataSource,UITableViewDataSource,UITableViewDelegate,QGPickerViewDelegate >

@property (nonatomic,strong) NSString *birthdayDate;

@property (nonatomic, copy) NSString *time;// 点击日历某一天之后储存今天的年月月

@property (nonatomic, strong) JBUnitView *unitView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *ageButton;

@property (nonatomic,strong) UIView *lineView;//日历下面的背景线条

@property (nonatomic,strong) NSMutableArray *remindDataArray;

@property (nonatomic,strong) UITableViewCell *birthdayCell;

@property (nonatomic,strong) AgeTableViewCell *ageCell;

@property (nonatomic,strong) NSDate *selectorDate;//表示选中的日期，如果没选中，那么默认是今天

@property (nonatomic,copy) NSString *chooseAgeString;//比如100，90，80，70等等

@property (weak, nonatomic) IBOutlet UIButton *chooseTodayButton;

@property (weak, nonatomic) IBOutlet UIButton *dateTtitleButton;//显示当前选择的日期button

@property (nonatomic , strong) QGPickerView *chooseDatePickView;//点击日期button显示的QGPickView

@property (nonatomic,copy) NSString *chooseDateString;//比如2015-05-12等等

@end

// 选一个有意义的日期作倒计时（备注：可添加多个？）
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.当前显示的天数
    NSDate *senddate = [NSDate date];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *timeString = [dateformatter stringFromDate:senddate];
    
    [self.dateTtitleButton setTitle:timeString forState:UIControlStateNormal];

    //2.主日历
    self.unitView = [[JBUnitView alloc] initWithFrame:CGRectMake(0,120.0f + 11.5f,SCREEN_WIDTH, 1) UnitType:UnitTypeMonth SelectedDate:[NSDate date] AlignmentRule:JBAlignmentRuleTop Delegate:self DataSource:self];
    
    [self.view addSubview:self.unitView];
    
    //3.设置下面提醒事件显示的UITableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.unitView.bounds.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - self.unitView.bounds.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
    
    self.tableView.tableHeaderView = [[UIView alloc]  init];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
    
    NSDate *mydate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setMonth:+1];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    
    [self.unitView selectDate:newdate];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.unitView selectDate:[NSDate date]];
    
    self.selectorDate = [NSDate date];
    
    [_unitView reloadEvents];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0 ,self.unitView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    
    self.lineView.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    
    //选择日期的按钮
    [self.chooseTodayButton setBackgroundImage:[Common imageWithColor:RGBACOLOR(235, 235, 235, 1)] forState:UIControlStateHighlighted];
    //选择标题的按钮
    [self.dateTtitleButton setBackgroundImage:[Common imageWithColor:RGBACOLOR(235, 235, 235, 1)] forState:UIControlStateHighlighted];
    
    [self.unitView addSubview:self.lineView];
    
    self.chooseAgeString = @"80";
    
    [self loadTableViewData];
    
    //监听通知
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:UserAccountHandlerUseProfileDidChangeNotification object:nil];
    
}

//监听通知,刷新数据
- (void)reloadData {
    
    [self reloadShowCalendarDateWith:self.selectorDate];
    
}

//下载self.tableView的数据
- (void)loadTableViewData {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    
    NSString *selectorDateString = [formatter stringFromDate:self.selectorDate];
    
    self.remindDataArray = [[STRemindManager shareRemindManager] allRemindModelWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] dateString:selectorDateString];
    
    [self.tableView reloadData];
}

- (UITableViewCell *)birthdayCell {
    
    if (!_birthdayCell) {
        
        _birthdayCell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        
        _birthdayCell.textLabel.font = [UIFont systemFontOfSize:15];
        
        _birthdayCell.textLabel.textColor = [UIColor darkGrayColor];
        
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
            
            for (int i = 100 ; i >= 1; i--) {
                
                [dataArray addObject:[NSString stringWithFormat:@"%d岁",i]];
                
            }
            
            //显示QGPickerView
            [picker showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:@"80岁" selectedTitle:nil selectedTitle:nil];
            
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
            [picker showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:dataArray withArray:nil withArray:nil selectedTitle:[NSString stringWithFormat:@"%@岁",weakSelf.chooseAgeString] selectedTitle:nil selectedTitle:nil];
            
        }
    }];
    
    return _ageCell;
}

#pragma -----
#pragma mark -- QGPickerViewDelegate

- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex {
    
    if (self.chooseDatePickView == pickView) {
        
        self.chooseDateString = [self.chooseDateString stringByAppendingString:value];
        
        if (index == 3) {
            
            NSArray *array  = [self.chooseDateString componentsSeparatedByString:@"年"];
            
            NSArray *array_second = [(NSString *)array[1] componentsSeparatedByString:@"月"];
            
            NSArray *array_third = [(NSString *)array_second[1] componentsSeparatedByString:@"日"];
            
            self.chooseDateString = [NSString stringWithFormat:@"%@-%@-%@",array[0],[Common addZeroWithString:array_second[0]],[Common addZeroWithString:array_third[0]]];
            
            NSDate *date = [Common getDateWithFormatterString:@"yyyy-MM-dd" dateString:self.chooseDateString];
        
           self.selectorDate = date;
            
           [self.unitView selectDate:date];
            
           [self.unitView reloadEvents];//刷新日历
            
           self.chooseDateString = @"";
            
        }
        
    } else {
        
        [self.ageCell.ageButton setTitle:value forState:UIControlStateNormal];
        
        self.chooseAgeString = [[value componentsSeparatedByString:@"岁"] firstObject];
        
        [self reloadShowCalendarDateWith:self.selectorDate];
    }
}

//选中日期按钮的点击事件
- (IBAction)selectorDateAction:(id)sender {
    
    [self chooseDate];
    
}

//选择生日
- (void)chooseDate {
    
    [self.view endEditing:YES];
    
    self.chooseDatePickView = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    self.chooseDatePickView.delegate = self;
    
    self.chooseDatePickView.titleText = @"选择日期";
    
    self.chooseDateString = @"";
    
    //3.赋值
    [Common getYearArrayMonthArrayDayArrayWithYearNumber:200 hander:^(NSMutableArray *yearArray, NSMutableArray *monthArray, NSMutableArray *dayArray) {
      
        NSArray *dateArray = [[Common getDateStringWithDate:self.selectorDate] componentsSeparatedByString:@"-"];//选中的日期
        
        NSString *monthStr = dateArray[1];
        
        NSString *dayStr = dateArray[2];
        
        if (monthStr.length == 2 && [[monthStr substringToIndex:1] isEqualToString:@"0"]) {
            
            monthStr = [NSString stringWithFormat:@"%@月",[monthStr substringFromIndex:1]];
            
        } else {
            
            monthStr = [NSString stringWithFormat:@"%@月",monthStr];
        }
        
        if (dayStr.length == 2 && [[dayStr substringToIndex:1] isEqualToString:@"0"]) {
            
            dayStr = [NSString stringWithFormat:@"%@日",[dayStr substringFromIndex:1]];
            
        } else {
            
            dayStr = [NSString stringWithFormat:@"%@日",dayStr];
        }
        
        //显示QGPickerView
        [self.chooseDatePickView showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:3 withArray:yearArray withArray:monthArray withArray:dayArray selectedTitle:[NSString stringWithFormat:@"%@年",dateArray[0]] selectedTitle:monthStr selectedTitle:dayStr];
    }];
}

//返回今天按钮点击事件
- (IBAction)backTodayAction:(id)sender {
    
    [self.unitView selectDate:[NSDate date]];
    
}

//添加提醒按钮点击事件
- (IBAction)addRemindAction:(id)sender {
    
    AddRemindViewController *controller = [[AddRemindViewController alloc] init];
    
    controller.hidesBottomBarWhenPushed = YES;
    
    controller.changeORAdd = NO;//表示是新增的
    
    [controller setSaveOrChangeSuccessBlock:^{
       
        [self loadTableViewData];
        
        [self.tableView reloadData];
        
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark -
#pragma mark - JBUnitViewDelegate / JBUnitViewDataSource

- (CGFloat)heightOfUnitTileViewsInUnitView:(JBUnitView *)unitView {
    
    return SCREEN_WIDTH/7.00f;
    
}

- (CGFloat)widthOfUnitTileViewsInUnitView:(JBUnitView *)unitView {
    
    return SCREEN_WIDTH/7.00f;
    
}

- (void)unitView:(JBUnitView *)unitView UpdatingFrameTo:(CGRect)newFrame {
    
    self.tableView.frame = CGRectMake(0.0f,
                                      newFrame.size.height + newFrame.origin.y,SCREEN_WIDTH,SCREEN_HEIGHT - newFrame.size.height - newFrame.origin.y);
    
    self.lineView.y = newFrame.size.height - 1;
}

- (JBUnitTileView *)unitTileViewInUnitView:(JBUnitView *)unitView {
    
    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH / 7, 46.0f)];
}

- (void)unitView:(JBUnitView *)unitView SelectedDate:(NSDate *)date {
    
    self.selectorDate = date;
    
    //刷新整个日历的天数显示,tableView,判断今天的按钮到底显示不显示,以及一些按钮的显示
    [self reloadShowCalendarDateWith:self.selectorDate];
    
    //刷新下面的tableView
    [self loadTableViewData];

}

//刷新整个日历天数的显示
- (void)reloadShowCalendarDateWith:(NSDate *)selectorDate {
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {
    
        self.birthdayCell.textLabel.text = @"您还没有设置您的生日,请在个人信息里设置生日";
        
        self.ageCell.titleLabel.text = @"请设置个人生日";
        
    } else {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
        
        NSString *selectorDateString = [formatter stringFromDate:selectorDate];
        
        NSString *todayString = [formatter stringFromDate:[NSDate date]];
        
        if ([todayString isEqualToString:selectorDateString]) {//如果选中的日期是今天
            
            self.chooseTodayButton.hidden = YES;
            
        } else {
            
            self.chooseTodayButton.hidden = NO;
        }
        
        NSDate *selectorNewDate = [formatter dateFromString:selectorDateString];
        
        NSDate *birthdayDate = [formatter dateFromString:STUserAccountHandler.userProfile.birthday];
        
        NSDate *chooseAgeDate = [NSDate dateWithTimeInterval:[self.chooseAgeString doubleValue]*365*24*60*60 sinceDate:birthdayDate];
        
        NSTimeInterval interval = [chooseAgeDate timeIntervalSinceDate:selectorNewDate];
        
        int dayNumber = interval/86400.0f;
        
        self.ageCell.titleLabel.text = [NSString stringWithFormat:@"从今天到所选岁数还有%d天。",dayNumber];
        
        NSTimeInterval birthdayInterval = [selectorNewDate timeIntervalSinceDate:birthdayDate];
        
        
        int birthdayNumber = birthdayInterval/86400.0f;
        
        self.birthdayCell.textLabel.text = [NSString stringWithFormat:@"您出生到这天过去了%d天。",birthdayNumber];
        
    }
    
    //拿出来重写是因为就算不设置生日有会显示该按钮
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    
    NSString *selectorDateString = [formatter stringFromDate:selectorDate];
    
    //刷新上面的当前选择的日期button
    [self.dateTtitleButton setTitle:selectorDateString forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}


#pragma ---
#pragma mark -- UITableViewDelegate/UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return  2;
        
    } else if ( section == 1 ){
        
        return self.remindDataArray.count;
        
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
        
            return self.birthdayCell;
            
        } else if (indexPath.row == 1) {
            
            return self.ageCell;
            
        }
        
    } else if (indexPath.section == 1) {
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.5f;
        
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
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
