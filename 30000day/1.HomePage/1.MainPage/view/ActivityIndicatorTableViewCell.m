//
//  ActivityIndicatorTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ActivityIndicatorTableViewCell.h"

@implementation ActivityIndicatorTableViewCell

- (void)awakeFromNib {
    
   self.label_1.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
   self.label_2.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(float)totalLifeDayNumber {
    
    int hasbeen;
    
    int count = 0;
    
    if ([[UserAccountHandler shareUserAccountHandler].userProfile.birthday isEqualToString:@""] || [UserAccountHandler shareUserAccountHandler].userProfile.birthday == nil) {
        
        hasbeen = 0;
        
    } else {
        
        hasbeen = [self getDays:[UserAccountHandler shareUserAccountHandler].userProfile.birthday];
    }
    
    NSArray *array = [[UserAccountHandler shareUserAccountHandler].userProfile.birthday componentsSeparatedByString:@"/"];
    
    int year = [array[0] intValue];
    
    for (int i = year; i < year + 80; i++) {
        
        if (i % 400 == 0 || ( i%4 == 0 && i % 100 != 0)) {
            
            count += 366;
            
        } else {
            
            count += 365;
        }
    }
    
    self.indicatiorView.progressCounter = hasbeen;
    
    self.indicatiorView.progressTotal = totalLifeDayNumber;
    
    self.indicatiorView.theme.sliceDividerHidden = YES;//部分分开是否隐藏
    
    self.indicatiorView.theme.incompletedColor = RGBACOLOR(230, 230, 230, 1);
    
    self.indicatiorView.theme.thickness = 30.0;//粗细

    self.label_1.text = [NSString stringWithFormat:@"%.2d",hasbeen];
    
    self.label_2.text = [NSString stringWithFormat:@"%.2f",totalLifeDayNumber];
    
    if (hasbeen==0) {
        self.indicatiorView.theme.completedColor = RGBACOLOR(230, 230, 230, 1);
    }else{
        self.indicatiorView.theme.completedColor = RGBACOLOR(104, 149, 232, 1);
    }
    
}

- (int)getDays:(NSString *)theDate {
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *dateArray = [theDate componentsSeparatedByString:@"/"];
    
    theDate = [NSString stringWithFormat:@"%@-%@-%@",dateArray[0],dateArray[1],dateArray[2]];
    
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    //获取当前系统时间
    NSDate *adate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: adate];
    
    NSDate *localeDate = [adate  dateByAddingTimeInterval: interval];
    
    NSTimeInterval now=[localeDate timeIntervalSince1970]*1;
    
    NSString *timeString = @"";
    
    NSLog(@"mainViewCtr:%@", localeDate);
    
    NSTimeInterval cha = now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    int iDays = [timeString intValue];
    
    return iDays;
}


@end
