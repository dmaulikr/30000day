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
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components =  [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    if (components.day == 1) {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
        
        return [NSString stringWithFormat:@"昨天 %@",[[[formatter stringFromDate:date] componentsSeparatedByString:@" "] lastObject]];
        
    } else if (components.day == 0) {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
        
        return [NSString stringWithFormat:@"今天 %@",[[[formatter stringFromDate:date] componentsSeparatedByString:@" "] lastObject]];
        
    } else {
        
        NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"];
        
        return [formatter stringFromDate:date];
    }
    
    return @"";
}


@end
