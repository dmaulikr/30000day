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
+ (void)getYearArrayMonthArrayDayArrayWithYearNumber:(int)yearNumber
                                              hander:(void (^)(NSMutableArray *yearArray,NSMutableArray *monthArray,NSMutableArray *dayArray) )handler;
/**
 * 获取NSDated的时间字符串
 * @Param   NSDate类型的对象
 * @return  @"2016-12-12"
 */
+ (NSString *)getDateStringWithDate:(NSDate *)date;

/**
 * 获取NSDate对象
 * @Param   formatterString比如:@"yyyy-MM-dd",dateString:比如"2016-12-05"
 * @return  获取NSDate对象
 */
+ (NSDate *)getDateWithFormatterString:(NSString *)formatterString dateString:(NSString *)dateString;

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


+ (UIImage *)imageWithColor:(UIColor *)color;


//专门用来检查URL是否正确的
+ (NSString *)urlStringWithDictionary:(NSMutableDictionary *)dictinary withString:(NSString *)subApi;

//剪切字符串，吧市、自治区、省
+ (NSString *)deletedStringWithParentString:(NSString *)sting;

@end
