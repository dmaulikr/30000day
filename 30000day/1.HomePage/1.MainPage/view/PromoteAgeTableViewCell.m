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
    
    //把上次选择存存储进沙河
    [Common saveAppBoolDataForKey:WORK_REST_NOTIFICATION withObject:switchButton.on];
    
    [self configLocaleNotification:switchButton.on];
}

- (void)configLocaleNotification:(BOOL)addOrDelete {//YES:add NO:delete
    
    if (addOrDelete) {
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        NSString *dateString = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate date]];
        
        dateString = [NSString stringWithFormat:@"%@ 21:30",dateString];
        
        NSDate *newDate =  [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] dateFromString:dateString];
        
        if ([[NSDate date] compare:newDate] == NSOrderedAscending) {
            
            notification.fireDate = newDate;
            
        } else {
            
            notification.fireDate = [NSDate dateWithTimeInterval:24.000000 * 60.000000 * 60.000000 sinceDate:newDate];
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
