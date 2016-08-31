//
//  Common.m
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "Common.h"
#import "SFHFKeychainUtils.h"
#import "ThirdPartyLandingViewController.h"

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

+ (void)saveAppIntegerDataForKey : (NSString *) key  withObject : (NSInteger) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

+ (NSInteger)readAppIntegerDataForKey : (NSString *) key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

+ (BOOL)readAppBoolDataForkey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (void) saveAppBoolDataForKey : (NSString *) key  withObject : (BOOL) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}

+ (void)removeAppDataForKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (BOOL)isUserLogin {
    
    return ([Common readAppDataForKey:KEY_SIGNIN_USER_UID] != nil);
}

+ (BOOL) isObjectNull : (id) obj {
    
    if ((obj == nil) || (obj == [NSNull null]) || ([[NSString stringWithFormat:@""] isEqualToString:obj]))
        
        return YES;
    else
        return NO;
}

+ (NSString *)getDateStringWithDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSDate *)getDateWithFormatterString:(NSString *)formatterString dateString:(NSString *)dateString {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:formatterString];
    return [formatter dateFromString:dateString];
}


+ (NSString *)getDateStringWithTimeInterval:(long)timeNumber {
    
    NSDate *date  =  [NSDate dateWithTimeIntervalSince1970:timeNumber/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSString *)addZeroWithString:(NSString *)numberString {

    if ([numberString length] == 1) {

        return numberString = [NSString stringWithFormat:@"0%@",numberString];

    } else {

        return numberString;
    }
}

+ (NSDateFormatter *)dateFormatterWithFormatterString:(NSString *)formatterString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    return formatter;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (NSString *)urlStringWithDictionary:(NSMutableDictionary *)dictinary withString:(NSString *)subApi {
    
    NSString *STAPI = ST_API_SERVER;
    NSString *url = [NSString stringWithFormat:@"%@%@?",STAPI,subApi];
    NSArray *array = [dictinary allKeys];
    NSString *keyValueString = @"";
    
    for (NSString *key in array) {
        
        NSString *newString = [NSString stringWithFormat:@"%@=%@&",key,[dictinary objectForKey:key]];
        keyValueString =  [keyValueString stringByAppendingString:newString];
    }
    
    if ([Common isObjectNull:keyValueString]) {
        
        return nil;
    }
    
    keyValueString = [keyValueString substringToIndex:keyValueString.length - 1];
    url = [NSString stringWithFormat:@"%@%@",url,keyValueString];
    NSLog(@"验证接口 = %@",url);
    return url;
}

+ (NSString *)urlStringWithDictionarySearch:(NSMutableDictionary *)dictinary withString:(NSString *)subApi {
    
    NSString *STAPI = ST_API_SERVER;
    NSString *url = [NSString stringWithFormat:@"%@%@?",STAPI,subApi];
    NSArray *array = [dictinary allKeys];
    NSString *keyValueString = @"";
    
    for (NSString *key in array) {
        
        NSString *newString = [NSString stringWithFormat:@"%@=%@&",key,[dictinary objectForKey:key]];
        keyValueString =  [keyValueString stringByAppendingString:newString];
    }
    
    if ([Common isObjectNull:keyValueString]) {
        
        return nil;
    }
    
    keyValueString = [keyValueString substringToIndex:keyValueString.length - 1];
    url = [NSString stringWithFormat:@"%@%@",url,keyValueString];
    NSLog(@"验证接口 = %@",url);
    return url;
}


//剪切字符串，吧市、自治区、省
+ (NSString *)deletedStringWithParentString:(NSString *)sting {
    
    if ([sting containsString:@"市"]) {
        
        NSArray *array = [sting componentsSeparatedByString:@"市"];
        return [array firstObject];

    } else if ([sting containsString:@"自治区"]) {
        
       NSArray *array = [sting componentsSeparatedByString:@"自治区"];
       return [array firstObject];
        
    } else if ([sting containsString:@"省"]) {
       
        NSArray *array = [sting componentsSeparatedByString:@"省"];
        return [array firstObject];
    }
    
    return sting;
}

//返回星期几
+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *chs_weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return  [chs_weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)getChineseCalendarWithDate:(NSDate *)date {
    
    NSArray *chineseMonths = [NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays = [NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSCalendar *commonCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [commonCalendar components:unitFlags fromDate:date];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    if ([d_str isEqualToString:@"初一"]) {
        
        if (comp.month == 1 && comp.day == 1) {
            
            m_str =  @"元旦";
            
        } else if (comp.month == 2 && comp.day == 14) {
            
            m_str =  @"情人节";
            
        } else if (comp.month == 3 && comp.day == 12) {
            
            m_str =  @"植树节";
            
        } else if (comp.month == 3 && comp.day == 8) {
            
            m_str =  @"女人节";
            
        } else if (comp.month == 4 && comp.day == 4) {
            
            m_str =  @"清明节";
            
        } else if (comp.month == 5 && comp.day == 1) {
            
            m_str =  @"劳动节";
            
        } else if (comp.month == 5 && comp.day == 4) {
            
            m_str =  @"青年节";
            
        } else if (comp.month == 6 && comp.day == 1) {
            
            m_str = @"儿童节";
            
        } else if (comp.month == 7 && comp.day == 1) {
            
            m_str =  @"建党节";
            
        } else if (comp.month == 8 && comp.day == 1) {
            
            m_str =  @"建军节";
            
        } else if (comp.month == 9 && comp.day == 10) {
            
            m_str =  @"教师节";
            
        } else if (comp.month == 10 && comp.day == 31) {
            
            m_str =  @"万圣节";
            
        } else if (comp.month == 11 && comp.day == 11) {
            
            m_str =  @"光混节";
            
        } else if (comp.month == 11 && comp.day == 23) {
            
            m_str =  @"感恩节";
            
        } else if (comp.month == 12 && comp.day == 24) {
            
            m_str =  @"平安节";
            
        } else if (comp.month == 12 && comp.day == 25) {
            
            m_str =  @"圣诞节";
        }
        
        if ([m_str isEqualToString:@"正月"]) {
            
            m_str = @"春节";
        }
        
        return m_str;
        
    } else {
        
        if (comp.month == 1 && comp.day == 1) {
            
            d_str =  @"元旦";
            
        } else if (comp.month == 2 && comp.day == 14) {
            
            d_str =  @"情人节";
            
        } else if (comp.month == 3 && comp.day == 12) {
            
            d_str =  @"植树节";
            
        } else if (comp.month == 3 && comp.day == 8) {
            
            d_str =  @"女人节";
            
        } else if (comp.month == 4 && comp.day == 4) {
            
            d_str =  @"清明节";
            
        } else if (comp.month == 5 && comp.day == 1) {
            
            d_str =  @"劳动节";
            
        } else if (comp.month == 5 && comp.day == 4) {
            
            d_str =  @"青年节";
            
        } else if (comp.month == 6 && comp.day == 1) {
            
            d_str = @"儿童节";
            
        } else if (comp.month == 7 && comp.day == 1) {
            
            d_str =  @"建党节";
            
        } else if (comp.month == 8 && comp.day == 1) {
            
            d_str =  @"建军节";
            
        } else if (comp.month == 9 && comp.day == 10) {
            
            d_str =  @"教师节";
            
        } else if (comp.month == 10 && comp.day == 31) {
            
            d_str =  @"万圣节";
            
        }  else if (comp.month == 11 && comp.day == 11) {
            
            d_str =  @"光混节";
            
        } else if (comp.month == 11 && comp.day == 23) {
            
            d_str =  @"感恩节";
            
        } else if (comp.month == 12 && comp.day == 24) {
            
            d_str =  @"平安节";
            
        } else if (comp.month == 12 && comp.day == 25) {
            
            d_str =  @"圣诞节";
        }
        
        if ([m_str isEqualToString:@"八月"] && [d_str isEqualToString:@"十五"]) {
            
            d_str = @"中秋节";
        }
        
         if ([m_str isEqualToString:@"九月"] && [d_str isEqualToString:@"初九"]) {
            
            d_str = @"重阳节";
        }
        
        if ([m_str isEqualToString:@"腊月"] && [d_str isEqualToString:@"三十"]) {
            
            d_str = @"除夕";
        }
        
        if ([m_str isEqualToString:@"正月"] && [d_str isEqualToString:@"十五"]) {
            
            d_str = @"元宵节";
        }
        
        if ([m_str isEqualToString:@"五月"] && [d_str isEqualToString:@"初五"]) {
            
            d_str = @"端午节";
        }

        return d_str;
    }
}

+ (CGFloat)heightWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.height;
}


+ (CGFloat)widthWithText:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.width;
}

//添加预约按钮
+ (UIButton *)addAppointmentBackgroundView:(UIView *)superView title:(NSString *)title selector:(SEL)selector controller:(UIViewController *)controller {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50.0f, SCREEN_WIDTH, 50)];
    view.backgroundColor = RGBACOLOR(0, 93, 193, 1);
    [superView addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [button addTarget:controller action:selector forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return button;
}


+ (NSMutableAttributedString *)attributedStringWithPrice:(CGFloat)price {
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",price]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, string.length)];
    return string;
}

/** 判断是否在7天以内 */
+ (void)dayNumberWithinNumber:(NSInteger)number inputDate:(NSDate *)inputDate completion:(void(^)(NSInteger day))completion {
    
    NSString *dateStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:inputDate];
    NSString *nowStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate date]];
    
    //在转回去是因为要比较day的区别
    NSDate *date2 = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:dateStr];
    NSDate *date3 = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:nowStr];
    
    NSCalendar *calendar  = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date3 toDate:date2 options:0];
    
    NSInteger newDay  = - cmps.day + 1;
    if (newDay <= number && cmps.year == 0 && cmps.month == 0 ) {
        completion(newDay);
    } else {
        completion(number);
    }
}

//截取本地视频缩略图
+ (UIImage *)getThumbnailImage:(NSString *)videoURL {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;//按正确方向对视频进行截图,关键点是将AVAssetImageGrnerator对象的appliesPreferredTrackTransform属性设置为YES。
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
}

+ (NSError *)errorWithString:(NSString *)errorString {
    
    if ([Common isObjectNull:errorString]) {
        return [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"发生了未知因素"}];
    } else {
        return [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:errorString}];
    }
}

+ (NSString *)errorStringWithError:(NSError *)error optionalString:(NSString *)optionalString {
    if ([Common isObjectNull:error.userInfo[NSLocalizedDescriptionKey]]) {
        return optionalString;
    } else {
        return error.userInfo[NSLocalizedDescriptionKey];
    }
}

//获取设备唯一标识符
+ (NSString *)keyChainValue {
    
    NSString *SERVICE_NAME = @"com.shutian.30000day";//最好用程序的bundle id
    NSString *string =  [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:SERVICE_NAME error:nil];  // 从keychain获取数据
    
    if ([string length] <= 0) {
        string  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];  // 保存UUID作为手机唯一标识符
        [SFHFKeychainUtils storeUsername:@"UUID"
                             andPassword:string
                          forServiceName:SERVICE_NAME
                          updateExisting:1
                                   error:nil];  //往keychain添加数据
    }
    return string;
}

//需要绑定
+ (BOOL)needBind {

    if ([Common isObjectNull:STUserAccountHandler.userProfile.mobile]) {
        return YES;
    } else {
        return NO;
    }
}

+ (ThirdPartyLandingViewController *)getBindController {
    ThirdPartyLandingViewController *controller = [[ThirdPartyLandingViewController alloc] init];
    controller.type = [Common readAppDataForKey:KEY_LOGIN_TYPE];
    controller.name = STUserAccountHandler.userProfile.nickName;
    controller.uid = [Common readAppDataForKey:KEY_SIGNIN_USER_NAME];
    controller.url = STUserAccountHandler.userProfile.headImg;
    controller.isConceal = YES;
    controller.hidesBottomBarWhenPushed = YES;
    return controller;
}
//前往绑定控制器
+ (void)presentBindControllerWithSuperController:(UIViewController *)superController {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"该功能需要绑定手机，是否前往绑定？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [superController.navigationController pushViewController:[Common getBindController] animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:action];
    [controller addAction:cancelAction];
    [superController presentViewController:controller animated:YES completion:nil];
}

+ (NSString *)getNumberString:(NSNumber *)numberString {
    
    int count = [numberString intValue];
    if (count) {
        
        if (count < 10000) {//小于一万
            return [NSString stringWithFormat:@"%@",numberString];
        } else {
            double wan = count / 10000.0;
            NSString *title = [NSString stringWithFormat:@"%.1f万",wan];
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
            return title;
        }
    } else {
        return [NSString stringWithFormat:@"%@",numberString];
    }
}
//如果超过一万的话的显示:xx.x万 显示一位小数
//如果16879 1.6万
//11478 1.1万
// 10263 1万


@end
