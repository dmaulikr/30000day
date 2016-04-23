//
//  myFriendsTableViewCell.m
//  30000天
//
//  Created by wei on 16/1/25.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "myFriendsTableViewCell.h"

@implementation myFriendsTableViewCell

- (void)awakeFromNib {
    
    self.iconImg.layer.cornerRadius = 3;
    
    self.iconImg.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInformationModel:(UserInformationModel *)informationModel {
    
    _informationModel = informationModel;
    
    int hasbeen;
    
    int count = 0;
    
    if ([Common isObjectNull:_informationModel.birthday]) {
        
        hasbeen = 0;
        
    } else {
        
        hasbeen = [self getDays:_informationModel.birthday];
    }
    
    NSArray *array = [_informationModel.birthday componentsSeparatedByString:@"-"];
    
    int year = [array[0] intValue];
    
    for (int i = year; i < year + 80; i++) {
        
        if (i % 400 == 0 || ( i % 4 == 0 && i % 100 != 0)) {
            
            count += 366;
            
        } else {
            
            count += 365;
        }
    }
    
    self.progressView.progressCounter = hasbeen;
    
    self.progressView.progressTotal = [_informationModel.curLife floatValue];
    
    self.progressView.theme.sliceDividerHidden = YES;//部分分开是否隐藏
    
    self.progressView.theme.incompletedColor = RGBACOLOR(230, 230, 230, 1);
    
    self.progressView.theme.thickness = 10.0;//粗细
    
    if (hasbeen == 0) {
        
        self.progressView.theme.completedColor = RGBACOLOR(230, 230, 230, 1);
        
    } else {
        
        self.progressView.theme.completedColor = RGBACOLOR(104, 149, 232, 1);
    }
    
    //设置升降image
    if ([_informationModel.chgLife floatValue] > 0 ) {
        
        self.upDownImg.image = [UIImage imageNamed:@"up"];
        
    } else {
        
        self.upDownImg.image = [UIImage imageNamed:@"lower"];
        
    }
}

- (int)getDays:(NSString *)dateString {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];

    NSDate *birthdayDate = [formatter dateFromString:dateString];
    
    NSTimeInterval birthdayInterval = [birthdayDate timeIntervalSince1970]*1;
    
    //获取当前系统时间
    NSDate *currentDate = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: currentDate];
    
    NSDate *localeDate = [currentDate  dateByAddingTimeInterval: interval];
    
    NSTimeInterval now = [localeDate timeIntervalSince1970]*1;
    
    NSString *timeString = @"";
    
    NSTimeInterval cha = now - birthdayInterval;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    
    timeString = [timeString substringToIndex:timeString.length - 7];
    
    int iDays = [timeString intValue];
    
    return iDays;
}


@end
