//
//  RemindContentTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/25.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "RemindContentTableViewCell.h"

@implementation RemindContentTableViewCell

- (void)awakeFromNib {
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    longPress.minimumPressDuration = 1.0;
    
    [self addGestureRecognizer:longPress];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    if (self.longPressBlock) {
        
        self.longPressBlock(self.longPressIndexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RemindModel *)model {
    
    _model = model;
    
    self.contentLabel.text = model.title;
    
    self.timeLabel.text = [self compareDateWithCurrentTodayWithDate:model.date];
}

/**
 * @pram date:创建提醒时候的date
 *
 * @return:比如：今天 12:12 昨天 12:12  2016-12-12 12:12
 **/
- (NSString *)compareDateWithCurrentTodayWithDate:(NSDate *)date {
    
    if ([self isThisDay:date]) {
        
        return [NSString stringWithFormat:@"今天 %@",[[[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:date] componentsSeparatedByString:@" "] lastObject]];
        
    } else if ([self isYesterDay:date]) {
        
        return [NSString stringWithFormat:@"昨天 %@",[[[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:date] componentsSeparatedByString:@" "] lastObject]];
        
    } else if ([self istomorrow:date]) {
        
        return [NSString stringWithFormat:@"明天 %@",[[[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:date] componentsSeparatedByString:@" "] lastObject]];
        
    } else {
        
        return [[Common dateFormatterWithFormatterString:@"yyyy年MM月dd日 HH:mm"] stringFromDate:date];
    }
}

/** 判断是否为昨天 */
- (BOOL)isYesterDay:(NSDate *)inputDate {
    //date == 2014-04-30 00:00:00
    //now ==2014-05-01   00:00:00
    
    // day = 1;hour = 0 minite = 0 second = 0 只看日期不看分钟和小时
    
    NSString *dateStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:inputDate];
    
    NSString *nowStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate date]];
    
    //在转回去是因为要比较day的区别
    NSDate *date2 = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:dateStr];
    
    NSDate *date3 = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:nowStr];
    
    NSCalendar *calendar  = [NSCalendar currentCalendar];//[[NSCalendar alloc] init]这样才对
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:date3 toDate:date2 options:0];
    
    return cmps.day == -1 && cmps.year == 0 && cmps.month == 0;//这样才是相差一天,昨天
}

/** 判断是否为明天 */
- (BOOL)istomorrow:(NSDate *)inputDate {
    //date == 2014-04-30 00:00:00
    //now ==2014-05-01   00:00:00
    // day = 1;hour = 0 minite = 0 second = 0 只看日期不看分钟和小时
    
    NSString *dateStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:inputDate];
    
    NSString *nowStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate date]];
    
    //在转回去是因为要比较day的区别
    NSDate *date2 = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:dateStr];
    
    NSDate *date3 = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] dateFromString:nowStr];
    
    NSCalendar *calendar  = [NSCalendar currentCalendar];//[[NSCalendar alloc] init]这样才对
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:date3 toDate:date2 options:0];
    
    return cmps.day == 1 && cmps.year == 0 && cmps.month == 0;//这样才是相差一天,昨天
}

/** 判断某个时间是否为今天--年月日一样*/
- (BOOL)isThisDay:(NSDate *)inputDate {
    
    NSString *dateStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:inputDate];
    
    NSString *nowStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd"] stringFromDate:[NSDate date]];
    
    return [dateStr isEqual:nowStr];
}

@end
