//
//  Common.m
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (void) saveAppDataForKey : (NSString *) key  withObject : (id) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:value forKey:key];
    
    [defaults synchronize];
}

+ (id)readAppDataForKey : (NSString *) key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:key];
}

+ (void) saveAppBoolDataForKey : (NSString *) key  withObject : (BOOL) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:value forKey:key];
    
    [defaults synchronize];
}

+ (BOOL)isUserLogin {
    
    return ([Common readAppDataForKey:KEY_SIGNIN_USER_UID] != nil);
}

+ (void)removeAppDataForKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:key];
    
    [defaults synchronize];
}

+ (BOOL) isObjectNull : (id) obj
{
    if ((obj == nil) || (obj == [NSNull null]) || ([[NSString stringWithFormat:@""] isEqualToString:obj]))
        return YES;
    else
        return NO;
}


+ (void)getYearArrayMonthArrayDayArray:(void (^)(NSMutableArray *yearArray,NSMutableArray *monthArray,NSMutableArray *dayArray) )handler {
    
    dispatch_async(dispatch_queue_create("creatArrays", DISPATCH_QUEUE_SERIAL), ^{
        
        NSMutableArray *yearArray = [NSMutableArray array];
        
        NSMutableArray *monthArray = [NSMutableArray array];
        
        NSMutableArray *dayArray = [NSMutableArray array];
        
        for (int i = 0; i < 100; i++) {
            
            NSString *yearStr = [NSString stringWithFormat:@"%ld年",(long)(1917+i)];
            
            [yearArray addObject:yearStr];
        }
        
        for (int i = 0; i < 12; i++) {
            
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)(1+i)];
            
            [monthArray addObject:monthStr];
        }
        
        for (int i = 0; i < 31; i++) {
            
            NSString *dayStr = [NSString stringWithFormat:@"%ld日",(long)(1+i)];
            
            [dayArray addObject:dayStr];
        }
        
        //主线程返回
        dispatch_async(dispatch_get_main_queue(), ^{
            
            handler(yearArray,monthArray,dayArray);
            
        });
        
    });
}

+ (NSString *)getCurrentDateString {
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)getDateStringWithTimeInterval:(long)timeNumber {
    
    NSDate *date  =  [NSDate dateWithTimeIntervalSince1970:timeNumber/1000];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    return [formatter stringFromDate:date];
}

@end
