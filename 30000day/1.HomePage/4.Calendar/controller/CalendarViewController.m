//
//  CalendarViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CalendarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JBCalendarLogic.h"
#import "JBUnitView.h"
#import "JBUnitGridView.h"
#import "JBSXRCUnitTileView.h"
#import "MoreTableViewCell.h"
#import "AddRemindViewController.h"

@interface CalendarViewController () < JBUnitGridViewDelegate, JBUnitGridViewDataSource, JBUnitViewDelegate, JBUnitViewDataSource,UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate > {
    
    NSString *database_path;
    
    int count;// 点击弹出时间或者plist数据的区分计数  1=时间   2=plist文件数据
    
    int selDay;// 点击plist文件数据的时候选择的整十年数
}

@property (nonatomic,strong) NSString *birthdayDate;

@property (nonatomic, copy) NSString *time;// 点击日历某一天之后储存今天的年月月

@property (nonatomic, strong) JBUnitView *unitView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)UIButton *morecell;

@property (nonatomic,strong)NSMutableArray *array;

@property(nonatomic,strong)ZHPickView *pickview;

@property(nonatomic,copy)NSString *resultString;

@property (nonatomic,strong) UILabel* lab1;

@property (nonatomic,strong) UILabel* lab2;

@property (nonatomic,strong) UIButton *ageButton;

@property (nonatomic,strong) UIView *lineView;//日历下面的背景线条

@property (nonatomic,strong) NSMutableArray *dataArray_new;

@end

// 选一个有意义的日期作倒计时（备注：可添加多个？）
@implementation CalendarViewController

//选中日期按钮的点击事件
- (IBAction)selectorDateAction:(id)sender {

    count = 1;
    
    [_pickview remove];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:1];
    
    //获取到当前时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    _pickview = [[ZHPickView alloc] initDatePickWithDate:localeDate datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    
    _pickview.delegate = self;
    
    [_pickview show];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];

    //获取当前时间作为初始化显示需要推送的消息查询条件
    NSDate *senddate = [NSDate date];
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * timeString = [dateformatter stringFromDate:senddate];
    
    [self.dateTtitleButton setTitle:timeString forState:UIControlStateNormal];
    
    _array = [NSMutableArray array];
    
//    [self loadData:timeString];
    [self loadData];
    
    self.unitView = [[JBUnitView alloc] initWithFrame:CGRectMake(0,120,SCREEN_WIDTH, 1) UnitType:UnitTypeMonth SelectedDate:[NSDate date] AlignmentRule:JBAlignmentRuleTop Delegate:self DataSource:self];
   
    [self.view addSubview:self.unitView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.unitView.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.unitView.bounds.size.height) style:UITableViewStylePlain];
    
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    
    [self.view addSubview:self.tableView];

    NSDate *mydate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:mydate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setMonth:+1];
    
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:mydate options:0];
    
    [self.unitView selectDate:newdate];
    
    [_unitView reloadEvents];
    
    selDay = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selDay"] intValue];
    
    if(selDay == 0){
        
        selDay = 80;// 设置初始值，默认到80岁。
    }
    
    UIView *tabHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 66)];
    
    _lab1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 22)];
    
    [_lab1 setText:[NSString stringWithFormat:@"您出生到这天过去了%d天。",[self getDays:_birthdayDate ToEnd:[self getNowDateFromatAnDate:[NSDate date]]]]];
    
    
    _lab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 22)];
    
    [_lab2 setFont:[UIFont fontWithName:@"STHeiti-Medium" size:10]];
    
    NSDate *newBirthday = [self BirthdayAddYear:[self StringToDatess:_birthdayDate] addYears:selDay];
    
    [_lab2 setText:[NSString stringWithFormat:@"从今天到所选岁数还有%d天。",[self getDays:[self DatessToString:[NSDate date]] ToEnd:newBirthday]]];
    
    _ageButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lab2.frame) -70, 30, 100, 22)];
    
    [_ageButton setTitle:[NSString stringWithFormat:@"%i岁",selDay] forState:UIControlStateNormal];
    
    [_ageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [_ageButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchDown];
    
    [tabHeader addSubview:_ageButton];
    
    [tabHeader addSubview:_lab1];
    
    [tabHeader addSubview:_lab2];
    
    _tableView.tableHeaderView = tabHeader;

    //带有UITableView的界面如果到遇到警告用这句代码解决
    self.tableView.rowHeight = 44.0f;
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    [self.unitView selectDate:[NSDate date]];
    
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0 ,self.unitView.bounds.size.height - 1, SCREEN_WIDTH, 1)];
    
    self.lineView.backgroundColor = RGBACOLOR(235, 235, 235, 1);
    
    [self.unitView addSubview:self.lineView];
}

// 选择整十年的按钮点击事件
- (void)btnClick {
    
        count = 2;
    
        [_pickview remove];
        
        _pickview = [[ZHPickView alloc] initPickviewWithPlistName:@"theWholeTen" isHaveNavControler:NO];
    
        _pickview.delegate=self;
        
        [_pickview show];
}

/**
 *   theDate:用户生日
 *   endDate:点击的时间
 **/
- (int)getDays:(NSString*)theDate ToEnd:(NSDate*)endDate {
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSTimeInterval now=[endDate timeIntervalSince1970]*1;
    
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
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString * timeString=[dateformatter stringFromDate:date];
    
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
- (NSDate *)StringToDate:(NSString*)string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate* tomorrow = [inputFormatter dateFromString:string];
    
    return tomorrow;
}
// string转date类型，带秒数的
- (NSDate *)StringToDatess:(NSString*)string {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* tomorrow = [inputFormatter dateFromString:string];
    
    return tomorrow;
}


#pragma mark -
#pragma mark - JBUnitGridViewDataSource
/**************************************************************
 *@Description:获得unitTileView
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:unitTileView
 **************************************************************/
- (JBUnitTileView *)unitTileViewInUnitGridView:(JBUnitGridView *)unitGridView {
    
    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH/7.00f, SCREEN_WIDTH/7.00f)];
    
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件的数量
 *@Params:
 *  unitGridView:当前unitGridView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView NumberOfEventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSInteger eventCount))completedBlock {
    
    completedBlock(calendarDate.day);
    
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件
 *@Params:
 *  unitGridView:当前unitGridView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView EventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSArray *events))completedBlock {
    
    completedBlock(nil);
    
}

#pragma mark -
#pragma mark - JBUnitViewDelegate
/**************************************************************
 *@Description:获取当前UnitView中UnitTileView的高度
 *@Params:
 *  unitView:当前unitView
 *@Return:当前UnitView中UnitTileView的高度
 **************************************************************/
- (CGFloat)heightOfUnitTileViewsInUnitView:(JBUnitView *)unitView {
    
    return SCREEN_WIDTH/7.00f;
    
}

/**************************************************************
 *@Description:获取当前UnitView中UnitTileView的宽度
 *@Params:
 *  unitView:当前unitView
 *@Return:当前UnitView中UnitTileView的宽度
 **************************************************************/
- (CGFloat)widthOfUnitTileViewsInUnitView:(JBUnitView *)unitView {
    
    return SCREEN_WIDTH/7.00f;
    
}

/**************************************************************
 *@Description:更新unitView的frame
 *@Params:
 *  unitView:当前unitView
 *  newFrame:新的frame
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView UpdatingFrameTo:(CGRect)newFrame {
    
    self.tableView.frame = CGRectMake(0.0f,
                                      newFrame.size.height + newFrame.origin.y ,SCREEN_WIDTH,SCREEN_HEIGHT - newFrame.size.height - (self.tableView.tableHeaderView.frame.size.height+10));
    
    self.lineView.y = newFrame.size.height - 1;
}

/**************************************************************
 *@Description:重新设置unitView的frame
 *@Params:
 *  unitView:当前unitView
 *  newFrame:新的frame
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView UpdatedFrameTo:(CGRect)newFrame
{
    
}

#pragma mark -
#pragma mark - JBUnitViewDataSource
/**************************************************************
 *@Description:获得unitTileView
 *@Params:
 *  unitView:当前unitView
 *@Return:unitTileView
 **************************************************************/
- (JBUnitTileView *)unitTileViewInUnitView:(JBUnitView *)unitView
{
    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH / 7, 46.0f)];
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件的数量
 *@Params:
 *  unitView:当前unitView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView NumberOfEventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSInteger eventCount))completedBlock
{
    completedBlock(calendarDate.day);
}

/**************************************************************
 *@Description:获取calendarDate对应的时间范围内的事件
 *@Params:
 *  unitView:当前unitView
 *  calendarDate:时间范围
 *  completedBlock:回调代码块
 *@Return:nil
 **************************************************************/
- (void)unitView:(JBUnitView *)unitView EventsInCalendarDate:(JBCalendarDate *)calendarDate WithCompletedBlock:(void (^)(NSArray *events))completedBlock
{
    completedBlock(nil);
}

#pragma mark ZhpickVIewDelegate
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    
    if ( count == 1 ) {
        
        // 取到时间后跳转到对应日期，并且重新设置导航栏显示的日期
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
            
            [_lab1 setText:[NSString stringWithFormat:@"您还没有设置您的生日"]];
            
        } else {
            
            [_lab1 setText:[NSString stringWithFormat:@"您出生到这天过去了%d天。",[self getDays:_birthdayDate ToEnd:[self StringToDatess:[NSString stringWithFormat:@"%@ 00:00:00",_time]]]]];
        }
        
        NSDate *newBirthday = [self BirthdayAddYear:[self StringToDatess:_birthdayDate] addYears:selDay];
        
        [_lab2 setText:[NSString stringWithFormat:@"从今天到所选岁数还有%d天。",[self getDays:[self DatessToString:[NSDate date]] ToEnd:newBirthday]]];
        
        [_ageButton setTitle:[NSString stringWithFormat:@"%i岁",selDay] forState:UIControlStateNormal];
        
        [_tableView reloadData];
    }
}

/**************************************************************
 *@Description:选择某一天
 *@Params:
 *  unitView:当前unitView
 *  date:选择的日期
 *@Return:nil
 **************************************************************/

- (void)unitView:(JBUnitView *)unitView SelectedDate:(NSDate *)date {
    
    NSString *monthStr;
    
    NSString *day;
    
    if (date.month < 10) {
        
        monthStr = [NSString stringWithFormat:@"0%lu",(unsigned long)date.month];
        
    } else {
        
        monthStr = [NSString stringWithFormat:@"%lu",(unsigned long)date.month];
        
    } if (date.day < 10) {
        
        day = [NSString stringWithFormat:@"0%lu",(unsigned long)date.day];
        
    } else {
        
        day = [NSString stringWithFormat:@"%lu",(unsigned long)date.day];
    }
    
    _time = [NSString stringWithFormat:@"%lu-%@-%@",(unsigned long)date.year,monthStr,day];
    
    [self.dateTtitleButton setTitle:_time forState:UIControlStateNormal];
    
    [_array removeAllObjects];
    
    if ([_birthdayDate isEqualToString:@" "] || [_birthdayDate isEqualToString:@" :00"]) {
        
        [_lab1 setText:[NSString stringWithFormat:@"您还没有设置您的生日"]];
        
    } else {
        
        [_lab1 setText:[NSString stringWithFormat:@"您出生到这天过去了%d天。",[self getDays:_birthdayDate ToEnd:[self StringToDatess:[NSString stringWithFormat:@"%@ 00:00:00",_time]]]]];
    }
    
    NSDate *newBirthday = [self BirthdayAddYear:[self StringToDatess:_birthdayDate] addYears:selDay];
    
    [_lab2 setText:[NSString stringWithFormat:@"从今天到所选岁数还有%d天。",[self getDays:[self DatessToString:[NSDate date]] ToEnd:newBirthday]]];
    
    [_ageButton setTitle:[NSString stringWithFormat:@"%i岁",selDay] forState:UIControlStateNormal];
    
    [_tableView reloadData];
}


#pragma ---
#pragma mark -- UITableViewDelegate/UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.dataArray_new.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
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
