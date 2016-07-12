//
//  ActivityIndicatorTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ActivityIndicatorTableViewCell.h"
#import "sys/utsname.h"

@interface ActivityIndicatorTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *label_2;
@property (weak , nonatomic) IBOutlet MDRadialProgressView *indicatiorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lableCenterY;

@end


@implementation ActivityIndicatorTableViewCell

- (void)awakeFromNib {
    
    if ([[self getDeviceType] isEqualToString:@"iPhone4"] ||
        [[self getDeviceType] isEqualToString:@"iPhone4S"]) {
        
        self.label_1.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        self.label_2.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
        self.circleWidth.constant = - ([UIScreen mainScreen].bounds.size.width * 0.43 - [UIScreen mainScreen].bounds.size.width * 0.36);
        self.lableCenterY.constant = - 8;
        
    } else {
        
        self.label_1.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        self.label_2.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData:(float)totalLifeDayNumber birthDayString:(NSString *)birthdayString showLabelTye:(ShowLabelType)type {
    
    NSDateFormatter *formatter = [Common dateFormatterWithFormatterString:@"yyyy-MM-dd"];
    NSDate *birthdayDate = [formatter dateFromString:birthdayString];
    NSString *todayString = [formatter stringFromDate:[NSDate date]];
    NSDate *newToday = [formatter dateFromString:todayString];
    NSTimeInterval interval = [newToday timeIntervalSinceDate:birthdayDate];
    int dayNumber = 0;
    
    if ([Common isObjectNull:birthdayString]) {//表示没设置生日
        dayNumber = 0;
    } else {//有设置了生日
        dayNumber = interval/86400.0f;
    }
    
    self.indicatiorView.progressCounter = dayNumber;
    self.indicatiorView.progressTotal = totalLifeDayNumber;
    self.indicatiorView.theme.sliceDividerHidden = YES;//部分分开是否隐藏
    self.indicatiorView.theme.incompletedColor = RGBACOLOR(230, 230, 230, 1);
    self.indicatiorView.theme.thickness = 30.0;//粗细

    if (type == ShowLabelPastAgeAndAllAgeType) {//过去天龄+总天龄
        
        self.label_1.text = [NSString stringWithFormat:@"%d",dayNumber];
        self.label_2.text = [NSString stringWithFormat:@"%.2f",totalLifeDayNumber];
        
    } else if (type == ShowLabelPastAgeAndSurplusAgeType) {//过去天龄+剩余天龄
        
        self.label_1.text = [NSString stringWithFormat:@"%d",dayNumber];
        self.label_2.text = [NSString stringWithFormat:@"%.2f",totalLifeDayNumber - dayNumber];
        
    } else {//默认是的:剩余天龄+总天龄
        
        self.label_1.text = [NSString stringWithFormat:@"%d",(int)totalLifeDayNumber - dayNumber];
        self.label_2.text = [NSString stringWithFormat:@"%.1f",totalLifeDayNumber];
    }
    
    if (dayNumber == 0) {
        self.indicatiorView.theme.completedColor = RGBACOLOR(230, 230, 230, 1);
    } else {
        self.indicatiorView.theme.completedColor = RGBACOLOR(104, 149, 232, 1);
    }
}

- (int)getDays:(NSString *)theDate {
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *dateArray = [theDate componentsSeparatedByString:@"-"];
    
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
    
    NSTimeInterval cha = now-late;
    
    timeString = [NSString stringWithFormat:@"%f", cha/86400];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    int iDays = [timeString intValue];
    
    return iDays;
}

//获取当前设备
- (NSString*)getDeviceType {

    struct utsname systemInfo;
    uname(&systemInfo);
    
    //get the device model and the system version
    NSString *deviceString=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    
    
    return deviceString;
}

- (void)setType:(ShowLabelType)type {
    
    _type = type;
    
    if (_type == ShowLabelSurplusAgeAndAllAgeType) {//剩余天龄+总天龄
        
        
        
    } else if (_type == ShowLabelPastAgeAndAllAgeType) {//过去天龄+总天龄
        
        
        
    } else if (_type == ShowLabelPastAgeAndSurplusAgeType) {//过去天龄+剩余天龄
        
        
        
    }
}


@end
