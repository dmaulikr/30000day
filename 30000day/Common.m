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

+ (void)saveAppIntegerDataForKey : (NSString *) key  withObject : (NSInteger) value {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:value forKey:key];
    
    [defaults synchronize];
    
}

+ (NSInteger)readAppIntegerDataForKey : (NSString *) key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults integerForKey:key];
    
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


+ (BOOL) isObjectNull : (id) obj
{
    if ((obj == nil) || (obj == [NSNull null]) || ([[NSString stringWithFormat:@""] isEqualToString:obj]))
        return YES;
    else
        return NO;
}

/**
 * yearArray存储的是 @"2016年",@"2015年"等字符串（100个）
 * monthArray存储的是 @"1月",@"2月"等字符串(12个)
 * dayArray存储的是  @"1日"，@"2日"等字符串（31个）
 **/
+ (void)getYearArrayMonthArrayDayArrayWithYearNumber:(int) yearNumber
                                              hander:(void (^)(NSMutableArray *yearArray,NSMutableArray *monthArray,NSMutableArray *dayArray) )handler {
    
    dispatch_async(dispatch_queue_create("creatArrays", DISPATCH_QUEUE_SERIAL), ^{
        
        NSMutableArray *yearArray = [NSMutableArray array];
        
        NSMutableArray *monthArray = [NSMutableArray array];
        
        NSMutableArray *dayArray = [NSMutableArray array];
        
        for (int i = 0; i < yearNumber; i++) {
            
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

+ (UIImage *)imageWithColor:(UIColor *)color
{
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
    
    NSString *url = [NSString stringWithFormat:@"%@%@?",ST_API_SERVER,subApi];
    
    NSArray *array = [dictinary allKeys];
    
    NSString *keyValueString = @"";
    
    for (NSString *key in array) {
        
        NSString *newString = [NSString stringWithFormat:@"%@=%@&",key,[dictinary objectForKey:key]];
        
        keyValueString =  [keyValueString stringByAppendingString:newString];
        
    }
    
    keyValueString = [keyValueString substringToIndex:keyValueString.length - 1];
    
    url = [NSString stringWithFormat:@"%@%@",url,keyValueString];
    
    return url;
    
}


+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    NSParameterAssert(asset);
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    
    CFTimeInterval thumbnailImageTime = time;
    
    NSError *thumbnailImageGenerationError = nil;
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

@end
