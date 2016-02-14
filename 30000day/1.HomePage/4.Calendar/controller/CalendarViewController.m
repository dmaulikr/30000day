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
#import <EventKit/EventKit.h>
#import "MoreTableViewCell.h"
#import "MoreInfo.h"
#import "MoreMessageViewCtr.h"
#import "MoreTabHeaderView.h"
#import "sys/utsname.h"

@interface CalendarViewController () < JBUnitGridViewDelegate, JBUnitGridViewDataSource, JBUnitViewDelegate, JBUnitViewDataSource,UITableViewDataSource,UITableViewDelegate,ZHPickViewDelegate > {
    
    FMDatabase *db;
    
    NSString *database_path;
    
    int count;// 点击弹出时间或者plist数据的区分计数  1=时间   2=plist文件数据
    
    int selDay;// 点击plist文件数据的时候选择的整十年数
}

@property (nonatomic,strong) NSString *birthdayDate;

@property (nonatomic, copy) NSString *time;// 点击日历某一天之后储存今天的年月月

@property (nonatomic, strong) JBUnitView *unitView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)UIButton *morecell;

@property (nonatomic,strong) MoreMessageViewCtr *MessageViewUpd;

@property (nonatomic,strong)NSMutableArray *array;

@property(nonatomic,strong)ZHPickView *pickview;

@property(nonatomic,copy)NSString *resultString;

@property (nonatomic,strong)UIButton *timeBtn;

@property (nonatomic,strong) UIView *toolView;//底部几个按钮的父视图

@property (nonatomic,strong) UIButton *dateButton;// 顶端第一个按钮，选择日期时间

@property (nonatomic,strong) UIButton *backTodayButton;// 顶端第二个按钮，回到今天

@property (nonatomic,strong) UIButton *pushRemindButton;// 顶端第三个按钮，跳转到添加页面

@property (nonatomic,strong) UIView *updView;

@property (nonatomic,strong) UILabel* lab1;

@property (nonatomic,strong) UILabel* lab2;

@property (nonatomic,strong) UIButton *ageButton;

@property (nonatomic,assign)NSInteger leftX;

- (void)selectorForButton;

-(void)unitView:(JBUnitView *)unitView SelectedDate:(NSDate *)date;

@end

// 选一个有意义的日期作倒计时（备注：可添加多个？）
@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UIScreen mainScreen].bounds.size.width ==  320) {
        
        self.leftX=0;
        
    } else if ([UIScreen mainScreen].bounds.size.width == 375 ) {
        
        self.leftX=25;
        
    } else {
        
        self.leftX=45;
    }
    
    _MessageViewUpd = [[MoreMessageViewCtr alloc] init];
    
    //获取当前时间作为初始化显示需要推送的消息查询条件
    NSDate *senddate = [NSDate date];
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * timeString = [dateformatter stringFromDate:senddate];
    
    _array = [NSMutableArray array];
    
    [self loadData:timeString];
    
    [self addToolView:timeString];
    
    self.unitView = [[JBUnitView alloc] initWithFrame:CGRectMake(self.leftX, CGRectGetMaxY(_toolView.frame), [UIScreen mainScreen].bounds.size.width, 1) UnitType:UnitTypeMonth SelectedDate:[NSDate date] AlignmentRule:JBAlignmentRuleTop Delegate:self DataSource:self];
   
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
    
    MoreTabHeaderView *tabHeader = [[MoreTabHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 66)];
    
    _lab1 = [[UILabel alloc] initWithFrame:CGRectMake(self.leftX, 5, 300, 22)];
    
    [_lab1 setText:[NSString stringWithFormat:@"您出生到这天过去了%d天。",[self getDays:_birthdayDate ToEnd:[self getNowDateFromatAnDate:[NSDate date]]]]];
    
    
    _lab2 = [[UILabel alloc] initWithFrame:CGRectMake(self.leftX, 30, 300, 22)];
    
    [_lab2 setFont:[UIFont fontWithName:@"STHeiti-Medium" size:10]];
    
    NSDate *newBirthday = [self BirthdayAddYear:[self StringToDatess:_birthdayDate] addYears:selDay];
    
    [_lab2 setText:[NSString stringWithFormat:@"从今天到所选岁数还有%d天。",[self getDays:[self DatessToString:[NSDate date]] ToEnd:newBirthday]]];
    
    _ageButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lab2.frame) - 50, 30, 100, 22)];
    
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
}

// 选择整十年的按钮点击事件
- (void)btnClick {
    
        count = 2;
    
        [_pickview remove];
        
        _pickview=[[ZHPickView alloc] initPickviewWithPlistName:@"theWholeTen" isHaveNavControler:NO];
    
        _pickview.delegate=self;
        
        [_pickview show];
}

//从数据库里面取数据
-(void)loadData:(NSString*)timeString{
    
    NSString *birthStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserBirthday"];
    
    _birthdayDate = [NSString stringWithString:birthStr==nil?@" ":birthStr];
    

    [self.view setUserInteractionEnabled:YES];
    
    // fmdb初始化
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
    
    //sql 语句 创建表
    if ([db open]) {
        
        NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)",DB_TABLENAME,DB_ID,DB_TITLE,DB_CONTENT,DB_DATE,DB_TIME,DB_NUMBER,DB_USERID];
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if (!res) {
            
            NSLog(@"error when creating db table");
            
        } else {
            
            NSLog(@"success to creating db table");
        }
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ WHERE TIME='%@'",DB_TABLENAME,timeString];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            MoreInfo *info = [[MoreInfo alloc] init];
            
            info.title = [rs stringForColumn:DB_TITLE];
            
            info.content = [rs stringForColumn:DB_CONTENT];
            
            info.date = [rs stringForColumn:DB_DATE];
            
            info.time = [rs stringForColumn:DB_TIME];
            
            info.number = [rs stringForColumn:DB_NUMBER];
            
            info.userid = [rs stringForColumn:DB_USERID];
            
            NSLog(@"%@  %@  %@  %@  %@  %@",info.title,info.content,info.date,info.time,info.number,info.userid);
            
            [_array addObject:info];
            
            NSLog(@"%@",_array);
        }
        
        [db close];
    }
    
}

-(void)addToolView:(NSString*)time {
    
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 45)];
    
    [self.view addSubview:_toolView];
    
    int btu1Width = 100;
    
    int btu2Width = btu1Width / 2;
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_dateButton setFrame:CGRectMake(self.leftX, 10, btu1Width, 25)];
    
    [_dateButton setTitle:time forState:UIControlStateNormal];
    
    [_dateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [_dateButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_dateButton addTarget:self action:@selector(selDate:) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolView addSubview:_dateButton];
    
    _backTodayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_backTodayButton setFrame:CGRectMake(self.leftX + btu1Width + 10, 10, btu2Width, 25)];
    
    [_backTodayButton setTitle:@"今天" forState:UIControlStateNormal];
    
    [_backTodayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [_backTodayButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_backTodayButton addTarget:self action:@selector(selectorForButton) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolView addSubview:_backTodayButton];
    
    _pushRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_pushRemindButton setFrame:CGRectMake(self.leftX + btu1Width + 10 + btu2Width, 10, btu2Width, 25)];
    
    [_pushRemindButton setTitle:@"➕" forState:UIControlStateNormal];
    
    [_pushRemindButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [_pushRemindButton.titleLabel setFont:[UIFont systemFontOfSize:18]];

    [_pushRemindButton addTarget:self action:@selector(pushRemindButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_toolView addSubview:_pushRemindButton];
}

//推出提醒控制器的按钮的点击事件
- (void)pushRemindButtonClick {
    
    _MessageViewUpd.time = self.time;
    
    _MessageViewUpd.into = @"add";
    
    [self.navigationController pushViewController:_MessageViewUpd animated:YES];
    
}

// 弹出时间选择器视图
-(void)selDate:(UIButton*)Btn {
    
    count = 1;
    
    [_pickview remove];
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:1];
    
    //获取到当前时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    _pickview=[[ZHPickView alloc] initDatePickWithDate:localeDate datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    
    _pickview.delegate = self;
    
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
-(NSDate*)BirthdayAddYear:(NSDate*)birthday addYears:(int)addyear
{
    NSString *string = [self DateToString:birthday];
    NSArray *arr = [string componentsSeparatedByString:@" "];
    NSArray *arr1 = [arr[0] componentsSeparatedByString:@"-"];
    NSString *newYear = [NSString stringWithFormat:@"%d-%@-%@ %@",[arr1[0] intValue]+addyear,arr1[1],arr1[2],arr[1]];
    //NSLog(@"%@",newYear);
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
#pragma mark - Class Extensions
- (void)selectorForButton {
    
    [self.unitView selectDate:[NSDate date]];
    
}

#pragma mark -
#pragma mark - JBUnitGridViewDelegate
/**************************************************************
 *@Description:获取当前UnitGridView中UnitTileView的高度
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:当前unitGridView中UnitTileView的高度
 **************************************************************/
- (CGFloat)heightOfUnitTileViewsInUnitGridView:(JBUnitGridView *)unitGridView {
    
    return 46.0f;
    
}


/**************************************************************
 *@Description:获取当前UnitGridView中UnitTileView的宽度
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:当前UnitGridView中UnitTileView的宽度
 **************************************************************/
- (CGFloat)widthOfUnitTileViewsInUnitGridView:(JBUnitGridView *)unitGridView {
    
    return 46.0f;
    
}

//  ------------选中了当前月份或周之外的时间--------------
/**************************************************************
 *@Description:选中了当前Unit的上一个Unit中的时间点
 *@Params:
 *  unitGridView:当前unitGridView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView selectedOnPreviousUnitWithDate:(JBCalendarDate *)date {
    
    NSLog(@"-----%@",date);
    
}

/**************************************************************
 *@Description:选中了当前Unit的下一个Unit中的时间点
 *@Params:
 *  unitGridView:当前unitGridView
 *  date:选中的时间点
 *@Return:nil
 **************************************************************/
- (void)unitGridView:(JBUnitGridView *)unitGridView selectedOnNextUnitWithDate:(JBCalendarDate *)date {
    
    
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
    
    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 46.0f, 46.0f)];
    
}

/**************************************************************
 *@Description:设置unitGridView中的weekdaysBarView
 *@Params:
 *  unitGridView:当前unitGridView
 *@Return:weekdaysBarView
 **************************************************************/
- (UIView *)weekdaysBarViewInUnitGridView:(JBUnitGridView *)unitGridView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weekdaysBarView"]];
    
    return imageView;
    
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
    
    return 46.0f;
    
}

/**************************************************************
 *@Description:获取当前UnitView中UnitTileView的宽度
 *@Params:
 *  unitView:当前unitView
 *@Return:当前UnitView中UnitTileView的宽度
 **************************************************************/
- (CGFloat)widthOfUnitTileViewsInUnitView:(JBUnitView *)unitView {
    
    return 46.0f;
    
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
                                      newFrame.size.height + newFrame.origin.y ,
                                      self.view.bounds.size.width,
                                      self.view.bounds.size.height - newFrame.size.height - (self.tableView.tableHeaderView.frame.size.height+10+_toolView.frame.size.height));
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
    return [[JBSXRCUnitTileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width/7, 46.0f)];
}

/**************************************************************
 *@Description:设置unitView中的weekdayView
 *@Params:
 *unitView:当前unitView
 *@Return:weekdayView
 **************************************************************/
- (UIView *)weekdaysBarViewInUnitView:(JBUnitView *)unitView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"weekdaysBarView"]];
    return imageView;
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

//获取当前设备
- (NSString*)getDeviceType {
    
    //需要导入 "sys/utsname.h"
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    //get the device model and the system version
    NSString *deviceString=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5c";
    
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5c";
    
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5s";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5s";
    
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    
    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPodTouch1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPodTouch2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPodTouch3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPodTouch4G";
    
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPodTouch5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad2(WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    //Simulator
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}


#pragma mark ZhpickVIewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    if(count == 1){
        // 取到时间后跳转到对应日期，并且重新设置导航栏显示的日期
        NSArray *arr = [resultString componentsSeparatedByString:@" "];
        _resultString = [NSString stringWithFormat:@"%@ %@",arr[0],arr[1]];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
        [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate* tomorrow = [inputFormatter dateFromString:_resultString];
        [self.unitView selectDate:tomorrow];
        
        [_timeBtn setTitle:arr[0] forState:UIControlStateNormal];
        //[self setNavigationBarButtonItems:arr[0]];
        [_dateButton setTitle:arr[0] forState:UIControlStateNormal];
    }else if (count == 2)
    {
        selDay = [resultString intValue];
        // 保存生日到本地文件，用于其他地方提取计算数值
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",selDay] forKey:@"selDay"];
        //// 提交到文件中
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([_birthdayDate isEqualToString:@" "] || [_birthdayDate isEqualToString:@" :00"]){
            [_lab1 setText:[NSString stringWithFormat:@"您还没有设置您的生日"]];
        }else
        {
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
    
    if (date.month<10) {
        
        monthStr = [NSString stringWithFormat:@"0%lu",(unsigned long)date.month];
        
    } else {
        
        monthStr = [NSString stringWithFormat:@"%lu",(unsigned long)date.month];
        
    } if (date.day<10) {
        
        day = [NSString stringWithFormat:@"0%lu",(unsigned long)date.day];
        
    } else {
        
        day = [NSString stringWithFormat:@"%lu",(unsigned long)date.day];
    }
    
    _time = [NSString stringWithFormat:@"%lu-%@-%@",(unsigned long)date.year,monthStr,day];
    
    [_dateButton setTitle:_time forState:UIControlStateNormal];
    
    [_array removeAllObjects];
    
    if ([db open]) {
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ WHERE TIME='%@'",DB_TABLENAME,_time];
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            MoreInfo *info = [[MoreInfo alloc] init];
            
            info.title = [rs stringForColumn:DB_TITLE];
            
            info.content = [rs stringForColumn:DB_CONTENT];
            
            info.date = [rs stringForColumn:DB_DATE];
            
            info.time = [rs stringForColumn:DB_TIME];
            
            info.number = [rs stringForColumn:DB_NUMBER];
            
            info.userid = [rs stringForColumn:DB_USERID];
            
            [_array addObject:info];
            
        }
        
        [db close];
    }
    
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
    
    return _array.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:nil options:nil] lastObject];
        
    }
    
    MoreInfo *info = [_array objectAtIndex:indexPath.row];
    
    cell.titleLab.text = info.title;
    
    cell.timeLab.text = info.date;
    
    cell.moreInfo = info;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 根据点击行号去到对应cell
    MoreTableViewCell *cell = (MoreTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];

    // 跳转
    _MessageViewUpd.moreInfo = cell.moreInfo;
    
    _MessageViewUpd.into = @"upd";
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
