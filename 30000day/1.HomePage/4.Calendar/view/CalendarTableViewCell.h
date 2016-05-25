//
//  CalendarTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"

@interface CalendarTableViewCell : UITableViewCell

//点击两个buton的回调
//tag == 1 表示点击的时间选择按钮 tag == 2 表示点击的增加提醒按钮
@property (nonatomic,copy) void (^chooseDateBlock)(NSInteger tag);

@property (nonatomic, strong) FSCalendar *calendar;

@property (nonatomic,strong) UIButton *todayButton;

//点击日期回调
@property (nonatomic,copy) void (^dateBlock)(NSDate *chooseDate);

//点击所有的提醒回调
@property (nonatomic,copy) void (^allBlock)();

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)getCalendarTableViewCellHeight;

@end
