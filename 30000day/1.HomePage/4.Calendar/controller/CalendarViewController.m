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
#import "MoreTableViewCell.h"
#import "AddRemindViewController.h"
#import "AgeTableViewCell.h"

@interface CalendarViewController () < JBUnitViewDelegate, JBUnitViewDataSource,UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate,QGPickerViewDelegate > {
    
    int count;// 点击弹出时间或者plist数据的区分计数  1=时间   2=plist文件数据
    
    int selDay;// 点击plist文件数据的时候选择的整十年数
}

@property (nonatomic,strong) NSString *birthdayDate;

@property (nonatomic, copy) NSString *time;// 点击日历某一天之后储存今天的年月月

@property (nonatomic, strong) JBUnitView *unitView;

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic,strong)ZHPickView *pickview;

@property(nonatomic,copy)NSString *resultString;

@property (nonatomic,strong) UIButton *ageButton;

@property (nonatomic,strong) UIView *lineView;//日历下面的背景线条

@property (nonatomic,strong) NSMutableArray *dataArray_new;

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
    
    //获取当前时间作为初始化显示需要推送的消息查询条件
    NSDate *senddate = [NSDate date];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *timeString = [dateformatter stringFromDate:senddate];
    
    [self.dateTtitleButton setTitle:timeString forState:UIControlStateNormal];
    
    [self loadData];
    
    self.unitView = [[JBUnitView alloc] initWithFrame:CGRectMake(0,120.0f + 11.5f,SCREEN_WIDTH, 1) UnitType:UnitTypeMonth SelectedDate:[NSDate date] AlignmentRule:JBAlignmentRuleTop Delegate:self DataSource:self];
    
    [self.view addSubview:self.unitView];
    
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
    
    selDay = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selDay"] intValue];
    
    if(selDay == 0){
        
        selDay = 80;// 设置初始值，默认到80岁。
    }
    
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
    
    //监听通知
    [STNotificationCenter addObserver:self selector:@selector(reloadData) name:UserAccountHandlerUseProfileDidChangeNotification object:nil];
    
}

//监听通知
- (void)reloadData {
    
    [self reloadShowCalendarDateWith:self.selectorDate];
    
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
        
        picker.titleText = @"年龄的选择";
        
        //显示QGPickerView
        [picker showOnView:[UIApplication sharedApplication].keyWindow withPickerViewNum:1 withArray:@[@"100岁",@"90岁",@"80岁",@"70岁",@"60岁"] withArray:nil withArray:nil selectedTitle:@"80岁" selectedTitle:nil selectedTitle:nil];
        
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

//    count = 1;
//    
//    [_pickview remove];
//    
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
//    
//    //获取到当前时区
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    
//    NSInteger interval = [zone secondsFromGMTForDate: date];
//    
//    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
//    
//    _pickview = [[ZHPickView alloc] initDatePickWithDate:localeDate datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
//    
//    _pickview.delegate = self;
//    
//    [_pickview show];
    
    [self chooseDate];
    
}

//选择生日
- (void)chooseDate {
    
    [self.view endEditing:YES];
    
    self.chooseDatePickView = [[QGPickerView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 250, SCREEN_WIDTH, 250)];
    
    self.chooseDatePickView.delegate = self;
    
    self.chooseDatePickView.titleText = @"日期选择";
    
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
    
    [controller setAddSuccessBlock:^{
       
        [self loadData];
        
        [self.tableView reloadData];
        
    }];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (void)loadData {
    
    self.dataArray_new = [[STRemindManager shareRemindManager] allRemindModelWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID]];
    
    [self.tableView reloadData];
}

/**
 *   theDate:用户生日
 *   endDate:点击的时间
 **/
- (int)getDays:(NSString*)theDate ToEnd:(NSDate*)endDate {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval late = [d timeIntervalSince1970]*1;
    
    NSTimeInterval now = [endDate timeIntervalSince1970]*1;
    
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    int iDays = [timeString intValue];
    
    return iDays;
}

- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

// 输入一个生日的date跟要加的int年份，返回一个生日加上int年份之后的date   比如 1991  20 返回2011
- (NSDate*)BirthdayAddYear:(NSDate*)birthday addYears:(int)addyear {
    
    NSString *string = [self DateToString:birthday];
    
    NSArray *arr = [string componentsSeparatedByString:@" "];
    
    NSArray *arr1 = [arr[0] componentsSeparatedByString:@"-"];
    
    NSString *newYear = [NSString stringWithFormat:@"%d-%@-%@ %@",[arr1[0] intValue]+addyear,arr1[1],arr1[2],arr[1]];

    return [self StringToDate:newYear];
}

#pragma mark --- 互换时间类型跟字符串类型
// date转string类型，不带秒数的
- (NSString *)DateToString:(NSDate*)date {
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * timeString = [dateformatter stringFromDate:date];
    
    return timeString;
}
// date转string类型，带秒数的
- (NSString *)DatessToString:(NSDate*)date {
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * timeString=[dateformatter stringFromDate:date];
    
    return timeString;
}
// string转date类型，不带秒数的
- (NSDate *)StringToDate:(NSString *)string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate* tomorrow = [inputFormatter dateFromString:string];
    
    return tomorrow;
}
// string转date类型，带秒数的
- (NSDate *)StringToDatess:(NSString *)string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* tomorrow = [inputFormatter dateFromString:string];
    
    return tomorrow;
}

#pragma mark -
#pragma mark - JBUnitViewDelegate

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

#pragma mark -
#pragma mark - JBUnitViewDataSource

- (JBUnitTileView *)unitTileViewInUnitView:(JBUnitView *)unitView {
    
    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH / 7, 46.0f)];
}

- (void)unitView:(JBUnitView *)unitView SelectedDate:(NSDate *)date {
    
    self.selectorDate = date;
    
    //刷新整个日历的天数显示,tableView,以及一些按钮的显示
    [self reloadShowCalendarDateWith:self.selectorDate];
    
}

//刷新整个日历天数的显示
- (void)reloadShowCalendarDateWith:(NSDate *)selectorDate {
    
    if ([Common isObjectNull:STUserAccountHandler.userProfile.birthday]) {
    
        self.birthdayCell.textLabel.text = @"您还没有设置您的生日,请在个人信息里设置生日";
        
        self.ageCell.titleLabel.text = @"请设置个人生日";
        
    } else {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
        
        NSString *selectorDateString = [formatter stringFromDate:selectorDate];
        
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

#pragma mark ZhpickVIewDelegate
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    
    if ( count == 1 ) {
        
        //取到时间后跳转到对应日期，并且重新设置导航栏显示的日期
        NSArray *arr = [resultString componentsSeparatedByString:@" "];
        
        _resultString = [NSString stringWithFormat:@"%@ %@",arr[0],arr[1]];
        
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate* tomorrow = [inputFormatter dateFromString:_resultString];
        
        [self.unitView selectDate:tomorrow];
        
        [self.dateTtitleButton setTitle:arr[0] forState:UIControlStateNormal];
        
    } else if (count == 2) {
        
        selDay = [resultString intValue];
        
        // 保存生日到本地文件，用于其他地方提取计算数值
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",selDay] forKey:@"selDay"];
        
        // 提交到文件中
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([_birthdayDate isEqualToString:@" "] || [_birthdayDate isEqualToString:@" :00"]){
            
            [self.birthdayCell.textLabel setText:[NSString stringWithFormat:@"您还没有设置您的生日"]];
            
        } else {
            
            [self.birthdayCell.textLabel setText:[NSString stringWithFormat:@"您出生到这天过去了%d天。",[self getDays:_birthdayDate ToEnd:[self StringToDatess:[NSString stringWithFormat:@"%@ 00:00:00",_time]]]]];
        }
        
        NSDate *newBirthday = [self BirthdayAddYear:[self StringToDatess:_birthdayDate] addYears:selDay];
        
        self.ageCell.titleLabel.text =  [NSString stringWithFormat:@"从今天到所选岁数还有%d天。",[self getDays:[self DatessToString:[NSDate date]] ToEnd:newBirthday]];
        
        [_ageButton setTitle:[NSString stringWithFormat:@"%i岁",selDay] forState:UIControlStateNormal];
        
        [_tableView reloadData];
    }
}


#pragma ---
#pragma mark -- UITableViewDelegate/UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return  2;
        
    } else if ( section == 1 ){
        
        return self.dataArray_new.count;
        
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
        
        MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:nil options:nil] lastObject];
            
        }
        
        RemindModel *info = [ self.dataArray_new objectAtIndex:indexPath.row];
        
        cell.titleLab.text = info.title;
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
        
        cell.timeLab.text = [formatter stringFromDate:info.date];
        
        return cell;
        
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.5f;
        
    }
    return 1;
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
