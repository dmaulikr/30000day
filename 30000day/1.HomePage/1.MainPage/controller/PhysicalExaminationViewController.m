//
//  PhysicalExaminationViewController.m
//  30000day
//
//  Created by wei on 16/5/13.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PhysicalExaminationViewController.h"

@interface PhysicalExaminationViewController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIDatePicker *physicalExaminationLastTimePicker;

@property (weak, nonatomic) IBOutlet UIPickerView *physicalExaminationIntervalPicker;

@property (nonatomic,assign) NSInteger selectRow;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation PhysicalExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加体检提醒";
    
    self.physicalExaminationLastTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    self.physicalExaminationLastTimePicker.datePickerMode = UIDatePickerModeDate;
    
    self.physicalExaminationLastTimePicker.maximumDate = [NSDate date];
    
    self.physicalExaminationLastTimePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:(-5 * 365.00000 * 24.000000 * 60.00000 * 60.00000)];
    
    self.physicalExaminationLastTimePicker.backgroundColor = [UIColor whiteColor];
    
    [self.physicalExaminationLastTimePicker addTarget:self action:@selector(timeChange:) forControlEvents:UIControlEventValueChanged];
    
    if ([Common isObjectNull:[Common readAppDataForKey:CHECK_DATE]]) {//表示之前没存储过时间
        
        self.physicalExaminationLastTimePicker.date = [NSDate date];
        
        [Common saveAppDataForKey:CHECK_DATE withObject:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:[NSDate date]]];
        
        [Common saveAppDataForKey:CHECK_DATE withObject:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:self.physicalExaminationLastTimePicker.date]];
        
    } else {//已经有存储了时间
        
        self.physicalExaminationLastTimePicker.date = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] dateFromString:[Common readAppDataForKey:CHECK_DATE]];
    }
    
    self.physicalExaminationIntervalPicker.showsSelectionIndicator = YES;
    
    self.physicalExaminationIntervalPicker.dataSource = self;
    
    self.physicalExaminationIntervalPicker.delegate = self;
    
    self.physicalExaminationIntervalPicker.backgroundColor = [UIColor whiteColor];
    
    if ([Common isObjectNull:[Common readAppDataForKey:CHECK_REPEAT]]) {
        
        [Common saveAppDataForKey:CHECK_REPEAT withObject:@0];
        
        [self.physicalExaminationIntervalPicker selectRow:0 inComponent:0 animated:NO];
        
    } else {
        
        if ([[Common readAppDataForKey:CHECK_REPEAT] isEqualToNumber:@0]) {
            
            [self.physicalExaminationIntervalPicker selectRow:0 inComponent:0 animated:NO];
            
            self.selectRow = 0;
            
        } else {
            
            self.selectRow = 1;
            
            [self.physicalExaminationIntervalPicker selectRow:1 inComponent:0 animated:NO];
        }
    }
    
    //判断开关
     self.switchButton.on = [Common readAppBoolDataForkey:CHECK_NOTIFICATION];
}

//时间值改变
- (void)timeChange:(UIDatePicker *)datePicker {
    
    [self configCheckLocaleNotification:self.switchButton.on];
}

- (IBAction)switchAction:(id)sender {
    
    UISwitch *switchButton = (UISwitch *)sender;
    
    [self configCheckLocaleNotification:switchButton.on];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (row == 0) {
        
        return @"半年";
        
    } else {
        
        return @"一年";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectRow = row;
    
    [self configCheckLocaleNotification:self.switchButton.on];
}

#pragma mark -- 设置提醒逻辑
- (UILocalNotification *)getNotication {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.timeZone = [NSTimeZone defaultTimeZone];
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    notification.alertBody = @"今天该体检，请您早点准备";
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[@"alertTitle"] = @"体检提醒";
    
    dictionary[CHECK_NOTIFICATION] = CHECK_NOTIFICATION;
    
    notification.userInfo = dictionary; //添加额外的信息
    
    return notification;
}

- (void)configCheckLocaleNotification:(BOOL)addOrDelete {//YES:add NO:delete

    [Common saveAppBoolDataForKey:CHECK_NOTIFICATION withObject:self.switchButton.on];
    
    if (addOrDelete) {
        
#pragma ---- 存储通知并修改
        [Common saveAppDataForKey:CHECK_REPEAT withObject:[NSNumber numberWithInt:(int)self.selectRow]];
        
        [Common saveAppDataForKey:CHECK_DATE withObject:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:self.physicalExaminationLastTimePicker.date]];
        
        NSString *oldString = [Common readAppDataForKey:CHECK_DATE];
        
        oldString = [[oldString componentsSeparatedByString:@" "] firstObject];
        
        oldString = [NSString stringWithFormat:@"%@ 11:00",oldString];
        
        NSDate *oldDate = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] dateFromString:oldString];
        
        if ([[Common readAppDataForKey:CHECK_REPEAT] isEqualToNumber:@0]) {//半年
            
            NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:oldDate];
            
            float flag = time / (182.500000 * 24.000000 * 60.00000 * 60.0000000);
            
            NSString *floatString = [NSString stringWithFormat:@"%.2f",flag];
            
            int  x  = [floatString intValue] + 1;
            
            for( int i = x; i < 20 ; i++ ) {//表示创建10个半年的提醒
                
                UILocalNotification *notification_2 = [self getNotication];
                
                notification_2.fireDate = [NSDate dateWithTimeInterval:i * 182.500000 * 24.000000 * 60.00000 * 60.0000000 sinceDate:oldDate];
                
                notification_2.repeatInterval = 0;
                
                [[UIApplication sharedApplication] scheduleLocalNotification: notification_2];
            }
            
        } else {//1年
            
            NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:oldDate];
            
            float flag = time / (365.000000 * 24.000000 * 60.00000 * 60.0000000);
            
            NSString *floatString = [NSString stringWithFormat:@"%.2f",flag];
            
            int  x  = [floatString intValue] + 1;
            
            UILocalNotification *notification_3 = [self getNotication];
            
            notification_3.repeatInterval = NSCalendarUnitYear;
            
            notification_3.fireDate = [NSDate dateWithTimeInterval: x * 365.000000 * 24.000000 * 60.00000 * 60.0000000 sinceDate:oldDate];
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification_3];
        }
        
    } else {
        
        //2.删除注册在通知中心的通知
        NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        for (int i = 0; i < notificationArray.count; i++) {
            
            UILocalNotification *localNotification = [notificationArray objectAtIndex:i];
            
            NSDictionary *userInfo = localNotification.userInfo;
            
            if ([userInfo[CHECK_NOTIFICATION] isEqualToString:CHECK_NOTIFICATION]) {//健康提醒
                
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
    
    if (self.setSuccessBlock) {//回调刷新之前的界面
        
        self.setSuccessBlock();
    }
}

@end
