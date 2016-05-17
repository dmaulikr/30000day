//
//  PromoteAgeTableViewCell.m
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PromoteAgeTableViewCell.h"

@implementation PromoteAgeTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)switchAction:(id)sender {
    
    UISwitch *switchButton = (UISwitch *)sender;
    
    if (self.row == 1) {//健康提醒
        
        //把上次选择存存储进沙河
        [Common saveAppBoolDataForKey:WORK_REST_NOTIFICATION withObject:switchButton.on];
        
        [self configLocaleNotification:switchButton.on];
        
    } else if (self.row == 2) {//体检提醒
        
        //把上次选择存储进沙河
        [Common saveAppBoolDataForKey:CHECK_NOTIFICATION withObject:switchButton.on];
        
        [self configCheckLocaleNotification:switchButton.on];
    }
}

- (void)reloadData {
    
    if (self.row == 2) {
        
        //把上次选择存存储进沙河
        [Common saveAppBoolDataForKey:CHECK_NOTIFICATION withObject:self.switchButton.on];
        
        [self configLocaleNotification:self.switchButton.on];
    }
}

- (UILocalNotification *)getNotication {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if ([Common isObjectNull:[Common readAppDataForKey:CHECK_DATE]]) {//之前没存储过：默认时间是：00：00
        
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.000000];
        
    } else {//之前有储存了
        
        NSString *dateString = [Common readAppDataForKey:CHECK_DATE];
        
        NSDate *newDate =  [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] dateFromString:dateString];
        
        notification.fireDate = newDate;
    }
    
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
    
    if (addOrDelete) {
        
        UILocalNotification *notification = [self getNotication];
        
        NSDate *oldDate = notification.fireDate;
        
        if ([Common isObjectNull:[[Common readAppDataForKey:CHECK_REPEAT] stringValue]]) {//无记录
    
            for( int i = 0; i < 10; i++ ) {//表示创建10个半年的提醒
                
                UILocalNotification *notification_1 = [self getNotication];
                
                notification_1.fireDate = [NSDate dateWithTimeInterval:i * 60.000000 sinceDate:oldDate];//0.500000000 *365.00000 * 24.000000 * 60.00000 * 60.0000000
                
                notification_1.repeatInterval = 0;
                
                [[UIApplication sharedApplication] scheduleLocalNotification: notification_1];
            }
            
        } else {//有记录
            
            if ([[Common readAppDataForKey:CHECK_REPEAT] isEqualToNumber:@0]) {//半年
                
                for( int i = 0; i < 10 ; i++ ) {//表示创建10个半年的提醒
                    
                    UILocalNotification *notification_2 = [self getNotication];

                    notification_2.fireDate = [NSDate dateWithTimeInterval:i * 60.00000 sinceDate:oldDate];//0.500000000 *365.00000 * 24.000000 * 60.000000 * 60.000000
                    
                    notification_2.repeatInterval = 0;
                    
                    [[UIApplication sharedApplication] scheduleLocalNotification: notification_2];
                }
                
            } else {//1年
                
                UILocalNotification *notification_3 = [self getNotication];
                
                notification_3.repeatInterval = NSCalendarUnitYear;
            
                [[UIApplication sharedApplication] scheduleLocalNotification:notification_3];
            }
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
}

- (void)configLocaleNotification:(BOOL)addOrDelete {//YES:add NO:delete
    
    if (addOrDelete) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        NSString *dateString = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate date]];
        
        dateString = [NSString stringWithFormat:@"%@ 09:00",dateString];
        
        NSDate *newDate =  [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] dateFromString:dateString];
        
        NSDate *nowDate = [NSDate date];
        
        if ([[NSDate date] compare:nowDate] == NSOrderedAscending) {
            
            notification.fireDate = newDate;
            
        } else {
            
            notification.fireDate = [NSDate dateWithTimeInterval:24.000000*60.000000*60.000000 sinceDate:newDate];
        }
        
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        notification.alertBody = @"早上7点起床，晚上九点睡觉";
        
        notification.repeatInterval = NSCalendarUnitDay;
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        dictionary[@"alertTitle"] = @"每日健康提醒";
        
        dictionary[WORK_REST_NOTIFICATION] = WORK_REST_NOTIFICATION;
        
        notification.userInfo = dictionary; //添加额外的信息
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
    } else {
        
        //2.删除注册在通知中心的通知
        NSArray *notificationArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
        
        for (int i = 0; i < notificationArray.count; i++) {
            
            UILocalNotification *localNotification = [notificationArray objectAtIndex:i];
            
            NSDictionary *userInfo = localNotification.userInfo;
            
            if ([userInfo[WORK_REST_NOTIFICATION] isEqualToString:WORK_REST_NOTIFICATION]) {//健康提醒
                
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                
            }
        }
    }
}

@end
