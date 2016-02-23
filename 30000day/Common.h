//
//  Common.h
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (BOOL)isUserLogin;//判断客户端过去是否登录过

+ (void)saveAppDataForKey : (NSString *) key  withObject : (id) value;

+ (id)readAppDataForKey : (NSString *) key;

+ (void)saveAppIntegerDataForKey : (NSString *) key  withObject : (NSInteger) value;

+ (NSInteger)readAppIntegerDataForKey : (NSString *) key;

+ (void) saveAppBoolDataForKey : (NSString *) key  withObject : (BOOL) value;

+ (void)removeAppDataForKey:(NSString *)key ;

+ (BOOL) isObjectNull : (id) obj;

/**
 * yearArray存储的是 @"2016年",@"2015年"等字符串（100个）
 * monthArray存储的是 @"1月",@"2月"等字符串(12个)
 * dayArray存储的是  @"1日"，@"2日"等字符串（31个）
 **/
+ (void)getYearArrayMonthArrayDayArray:(void (^)(NSMutableArray *yearArray,NSMutableArray *monthArray,NSMutableArray *dayArray) )handler;

/**
 * 获取现在的时间字符串
 *
 * @return  @"2016-12-12"
 */
+ (NSString *)getCurrentDateString;

/**
 *  @param  timeNumber long类型的数字
 *
 *  @return  @"2015-12-12"
 **/
+ (NSString *)getDateStringWithTimeInterval:(long)timeNumber;

/**
 * 给定一个数字string（长度为1）前面加个0,比如: 1 ----> 01
 *
 */
+ (NSString *)addZeroWithString:(NSString *)numberString;

/**
 * 给定一个string,比如: @"yyyy-MM-dd HH:mm" ---->NSDateFormatter
 *
 */
+ (NSDateFormatter *)dateFormatterWithFormatterString:(NSString *)formatterString;

@end
