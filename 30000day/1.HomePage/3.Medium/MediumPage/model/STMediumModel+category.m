//
//  STMediumModel+category.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumModel+category.h"

@implementation STMediumModel (category)

- (NSAttributedString *)getShowMediumString:(BOOL)isSpecial {
    
    if (isSpecial) {//有待进一步开发，因为老专家发布资讯的是一段链接，要做标记
    
        NSString *dataString = [NSString stringWithFormat:@"%@:%@",self.originalNickName,[self getContent]];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:dataString];
        [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:[dataString rangeOfString:self.originalNickName]];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:[dataString rangeOfString:[self getContent]]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, string.length)];
        return string;
        
    } else {
        
        if ([self.weMediaType isEqualToString:@"0"]) {//自媒体显示内容
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.infoContent];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, string.length)];
             [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, string.length)];
            return string;
            
        } else if ([self.weMediaType isEqualToString:@"1"]) {//资讯显示标题
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.infoName];
            [string addAttribute:NSForegroundColorAttributeName value:LOWBLUECOLOR range:NSMakeRange(0, string.length)];
             [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, string.length)];
            
            return string;
        }
        
        return [[NSAttributedString alloc] init];
    }
}

- (NSString *)getContent {
    
    if ([self.weMediaType isEqualToString:@"0"]) {//自媒体显示内容
        return self.infoContent;
    } else if ([self.weMediaType isEqualToString:@"1"]) {//资讯显示标题
        return self.infoName;
    }
    
    return @"";
}

- (STMediumModel *)getOriginMediumModel {
    if (self.retweeted_status) {
        return self.retweeted_status;
    } else {
        return self;
    }
}

@end
