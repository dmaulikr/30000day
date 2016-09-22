//
//  STMediumModel+category.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumModel+category.h"

@interface STAttributedString_model: NSObject

@property (nonatomic,strong) NSURL     *URL;
@property (nonatomic,copy)   NSString  *string;

@end

@implementation STAttributedString_model

@end

@implementation STMediumModel (category)

- (NSAttributedString *)getShowMediumString:(BOOL)isRelay {
    
    if (isRelay) {//转发操作
        
        if ([self.weMediaType isEqualToString:@"0"]) {
            NSString *dataString = [NSString stringWithFormat:@"%@:%@",self.originalNickName,[self getContent]];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dataString];
            [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:[dataString rangeOfString:self.originalNickName]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[dataString rangeOfString:[self getContent]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, string.length)];
            //添加
            [self regularExpression:string];
            [self regularExpressionForPhone:string];
            return string;
        } else if ([self.weMediaType isEqualToString:@"1"]) {
            NSString *dataString = [NSString stringWithFormat:@"%@:%@",self.originalNickName,[self getContent]];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dataString];
            [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:[dataString rangeOfString:self.originalNickName]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[dataString rangeOfString:[self getContent]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, string.length)];
            //添加
            [self regularExpression:string];
            [self regularExpressionForPhone:string];
            return string;
        } else {
            return [[NSMutableAttributedString alloc] init];
        }
    } else {
        
        if ([self.weMediaType isEqualToString:@"0"]) {//自媒体显示内容
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self decodingContent]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, string.length)];
             [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, string.length)];
            //添加
            [self regularExpression:string];
            [self regularExpressionForPhone:string];
            return string;
        } else if ([self.weMediaType isEqualToString:@"1"]) {//资讯显示标题
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.infoName];
            [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:NSMakeRange(0, string.length)];
             [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, string.length)];
            //添加
            [self regularExpression:string];
            [self regularExpressionForPhone:string];
            return string;
        }
        return [[NSAttributedString alloc] init];
    }
}

- (void)setDataDetectorsAttributedAttributedString:(NSMutableAttributedString *)attributedString
                                            atText:(NSString *)text
                             withRegularExpression:(NSRegularExpression *)expression {
    
    [expression enumerateMatchesInString:text
                                 options:0
                                   range:NSMakeRange(0, [text length])
                              usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                  
                                  NSRange matchRange = [result range];
                                  if ([result resultType] == NSTextCheckingTypePhoneNumber) {
                                      NSString *phoneNumber = [result phoneNumber];
                                      [attributedString addAttribute:NSLinkAttributeName value:phoneNumber range:matchRange];
                                      [attributedString addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:matchRange];
                                  } else if ([result resultType] == NSTextCheckingTypeDate) {
                                      //NSDate *date = [result date];
                                  } else if ([result resultType] == NSTextCheckingTypeLink) {
                                      
                                  }
                              }];
}

- (void)regularExpression:(NSMutableAttributedString *)attributedString {
    
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";//正则表达式检查URL
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:attributedString.string options:0 range:NSMakeRange(0, [attributedString.string length])];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        NSString *substringForMatch = [attributedString.string substringWithRange:match.range];
        NSURL *URL = [NSURL URLWithString:substringForMatch];
        
        STAttributedString_model *modle = [[STAttributedString_model alloc] init];
        modle.URL = URL;
        modle.string = substringForMatch;
        [array addObject:modle];
    }
    //替换NSMutableAttributedString
    for (int i = 0; i < array.count; i++) {
        STAttributedString_model *modle = array[i];
        [attributedString replaceCharactersInRange:[attributedString.string rangeOfString:modle.string] withAttributedString:[self getAttributedStringWithURL:modle.URL]];
    }
}

- (void)regularExpressionForPhone:(NSMutableAttributedString *)attributedString {
    NSError *error;
    NSString *regulaStr = @"(([0-9]{11})|((400|800)([0-9\\-]{7,10})|(([0-9]{4}|[0-9]{3})(-| )?)?([0-9]{7,8})((-| |转)*([0-9]{1,4}))?))";;//正则取出手机号码和电话号码
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:attributedString.string options:0 range:NSMakeRange(0, [attributedString.string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches) {
        NSString *substringForMatch = [attributedString.string substringWithRange:match.range];
        NSURL *URL = [NSURL URLWithString:substringForMatch];
        [attributedString addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:match.range];
        [attributedString addAttribute:NSLinkAttributeName value:URL range:match.range];
    }
}

- (NSMutableAttributedString *)getAttributedStringWithURL:(NSURL *)URL {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"网页链接"];
    [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:[@"网页链接" rangeOfString:@"网页链接"]];
    [string addAttribute:NSLinkAttributeName value:URL range:[@"网页链接" rangeOfString:@"网页链接"]];
    return string;
}

- (NSString *)getContent {
    if ([self.weMediaType isEqualToString:@"0"]) {//自媒体显示内容
        return [self decodingContent];
    } else if ([self.weMediaType isEqualToString:@"1"]) {//资讯显示标题
        return self.infoName;
    }
    return @"";
}

- (NSString *)decodingContent {
    return [self.infoContent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
