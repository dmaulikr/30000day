//
//  STMediumModel+category.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumModel+category.h"

@implementation STMediumModel (category)

- (NSAttributedString *)getShowMediumString:(BOOL)isRelay {
    
    if (isRelay) {//转发操作
        
        if ([self.weMediaType isEqualToString:@"0"]) {
            NSString *dataString = [NSString stringWithFormat:@"%@:%@",self.originalNickName,[self getContent]];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dataString];
            [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:[dataString rangeOfString:self.originalNickName]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[dataString rangeOfString:[self getContent]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, string.length)];
            //添加
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate error:nil];
            [self setDataDetectorsAttributedAttributedString:string atText:string.string withRegularExpression:detector];
            return string;
        } else if ([self.weMediaType isEqualToString:@"1"]) {
            NSString *dataString = [NSString stringWithFormat:@"%@:%@",self.originalNickName,[self getContent]];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dataString];
            [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:[dataString rangeOfString:self.originalNickName]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[dataString rangeOfString:[self getContent]]];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, string.length)];
            //添加
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate error:nil];
            [self setDataDetectorsAttributedAttributedString:string atText:string.string withRegularExpression:detector];
            return string;
        } else {
            return [[NSMutableAttributedString alloc] init];
        }
    } else {
        
        if ([self.weMediaType isEqualToString:@"0"]) {//自媒体显示内容
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self decodingContent]];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, string.length)];
             [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, string.length)];
            //添加
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate error:nil];
            [self setDataDetectorsAttributedAttributedString:string atText:string.string withRegularExpression:detector];
            return string;
        } else if ([self.weMediaType isEqualToString:@"1"]) {//资讯显示标题
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.infoName];
            [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:NSMakeRange(0, string.length)];
             [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, string.length)];
            //添加
            NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber | NSTextCheckingTypeDate error:nil];
            [self setDataDetectorsAttributedAttributedString:string atText:string.string withRegularExpression:detector];
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
                                  
                                  if ([result resultType] == NSTextCheckingTypeLink) {
                                      NSURL *url = [result URL];
                                      [attributedString addAttribute:NSLinkAttributeName value:url range:matchRange];
                                  } else if ([result resultType] == NSTextCheckingTypePhoneNumber) {
                                      NSString *phoneNumber = [result phoneNumber];
                                      [attributedString addAttribute:NSLinkAttributeName value:phoneNumber range:matchRange];
                                  } else if ([result resultType] == NSTextCheckingTypeDate) {
                                      //NSDate *date = [result date];
                                  }
                              }];
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
