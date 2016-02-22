//
//  MoreMessageViewCtr.m
//  30000天
//
//  Created by 30000天_001 on 14-12-18.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "MoreMessageViewCtr.h"

@interface MoreMessageViewCtr () < UITextFieldDelegate,UIActionSheetDelegate,ZHPickViewDelegate>
{
    int clickCount;
}

@property(nonatomic,strong) ZHPickView *pickview;

@property(nonatomic,copy) NSString *resultString;

@property (nonatomic) UIView *toolView;

@property (nonatomic, strong) UISwipeGestureRecognizer *RightSwipeGestureRecognizer;

@end

@implementation MoreMessageViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"添加提醒";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addCalendar)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    _titleTxt.text = _moreInfo.title;
    
    _contentTxt.text = _moreInfo.content;
    
    if (_moreInfo.date == nil) {// 代表点添加进来的
        
        [_dateBtn setTitle:@"00:00" forState:UIControlStateNormal];
        
        _deleteBtn.hidden = YES;
        
    } else// 代表点cell进来修改的
    {
        [_dateBtn setTitle:_moreInfo.date forState:UIControlStateNormal];
        
        _time = _moreInfo.time;
    }
}

- (void)addCalendar {
    
    if (clickCount != 10) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择一个提醒的时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
        return;
    }
    
    if (_moreInfo == nil) {
        
        _moreInfo = [[MoreInfo alloc] init];
    }
    
    _moreInfo.title = _titleTxt.text;
    
    _moreInfo.content = _contentTxt.text;
    
    _moreInfo.date = _dateBtn.titleLabel.text;
    
    _moreInfo.time = _time;
    
    //判断是点击哪里进来这个页面，点添加进来的就用添加的方式，点原来就有的推送消息就用修改的方式
    if ([_into isEqualToString:@"add"]) {
        
        [self addInfo];
        
    } else if ([_into isEqualToString:@"upd"]) {
        
        [self updInfo];
    }
    //好像无意义...只是为了返回之后可以刷新tableview。。。
    [self.CalDelegate CalendarNew:_moreInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addInfo {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    if (localNotification == nil) {
        
        return;
    }
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate* inputDate = [inputFormatter dateFromString:_resultString];
    //设置本地通知的触发时间（如果要立即触发，无需设置）
    localNotification.fireDate = inputDate;
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody = _contentTxt.text;
    //设置通知动作按钮的标题
    localNotification.alertAction = @"确定";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置通知的相关信息，截取通知的时间中的数字作为删除标识
    NSString *idStr = [self stringSubNumber:_resultString];
    
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:_titleTxt.text,@"title",idStr,@"id", nil];
    
    _moreInfo.number = idStr;
    
    localNotification.userInfo = infoDic;
    
    //在规定的日期触发通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    NSArray *arr = [_resultString componentsSeparatedByString:@" "];
    
    if ([db open]) {
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@', '%@', '%@')",
                               DB_TABLENAME, DB_TITLE, DB_CONTENT, DB_DATE, DB_TIME, DB_NUMBER, DB_USERID, _titleTxt.text, _contentTxt.text, arr[1], _time, idStr, userid];
        NSLog(@"%@",insertSql1);
        
        BOOL res = [db executeUpdate:insertSql1];
        
        if (!res) {
            
            NSLog(@"error when insert db table");
            
        } else {
            
            NSLog(@"success to insert db table");
        }
        
        [db close];
    }
}
//修改本地推送。先删除当前这个，再添加更新的这个
- (void)updInfo {
    
    [self cancelLocationNotification:_moreInfo.number];
    
    [self addInfo];
}

- (void)cancelLocationNotification:(NSString*)NotificationID {
    
    //删除数据库种的这条数据   先取消的话，没有这条通知了就会直接被return出去，不会往下删除了。
    if ([db open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               DB_TABLENAME, DB_NUMBER, NotificationID];
        BOOL res = [db executeUpdate:deleteSql];
        
        if (!res) {
            
            NSLog(@"error when delete db table");
            
        } else {
            
            NSLog(@"success to delete db table");
        }
        
        [db close];
    }
    
    //取消某一个通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    //获取当前所有的本地通知
    if (!notificaitons || notificaitons.count <= 0) {
        return;
    }
    
    for (UILocalNotification *notify in notificaitons) {
        
        if ([[notify.userInfo objectForKey:@"id"] isEqualToString:NotificationID]) {
            
            //取消一个特定的通知
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            
            break;
        }
    }
}

// 删除本条信息
- (IBAction)deleteBtnClick:(UIButton *)sender {
    
    [self cancelLocationNotification:_moreInfo.number];
    
    //好像无意义...只是为了返回之后可以刷新tableview。。。
    [self.CalDelegate CalendarNew:_moreInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}


// 截取字符串中的数字
- (NSString*)stringSubNumber:(NSString*)str {
    
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    
    NSString *tempStr;
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        
        [numberString appendString:tempStr];
        
        tempStr = @"";
    }
    
    return numberString;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)timeBtn:(UIButton*)sender {
    
    [_pickview remove];
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    //时区
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"GTM+8"];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    _pickview=[[ZHPickView alloc] initDatePickWithDate:localeDate datePickerMode:UIDatePickerModeTime isHaveNavControler:YES];
    
    _pickview.delegate = self;
    
    [_pickview show];
}

#pragma mark ZhpickVIewDelegate

- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    //-[__NSDate timeIntervalSinceReferenceDate]: message sent to deallocated instance
    NSArray *arr = [resultString componentsSeparatedByString:@" "];
    
    _resultString = [NSString stringWithFormat:@"%@ %@",_time,arr[1]];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate* tomorrow = [inputFormatter dateFromString:_resultString];
    
    NSDate *earlier_date = [tomorrow earlierDate:date];
    
    if ([earlier_date isEqualToDate:date]) {
        
        [_dateBtn setTitle:arr[1] forState:UIControlStateNormal];
        
        clickCount = 10;// 代表选择过时间了
        
    }else// 如果选择了当前以前的时间，则提示不能选择这个时间
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"不能选择这个时间提示" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
    }
}


//当用户按下return键或者按回车键，keyboard消失
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

// 失去焦点时退出键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.titleTxt resignFirstResponder];
    
    [self.contentTxt resignFirstResponder];
}

+ (id)initWithTime:(NSString *)time intoMode:(NSString *)into {
    
    MoreMessageViewCtr *mm = [[MoreMessageViewCtr alloc] init];
    
    mm.time = time;
    
    mm.into = into;
    
    return mm;
}

+ (id)initWithInfo:(MoreInfo *)info intoMode:(NSString *)into {
    
    MoreMessageViewCtr *mm = [[MoreMessageViewCtr alloc] init];
    
    mm.moreInfo = info;
    
    mm.into = into;
    
    return mm;
}

@end
