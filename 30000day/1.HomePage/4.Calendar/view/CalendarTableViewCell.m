//
//  CalendarTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CalendarTableViewCell.h"
#import "STRemindManager.h"

@interface CalendarTableViewCell () <FSCalendarDataSource, FSCalendarDelegate ,FSCalendarDelegateAppearance >

@end

@implementation CalendarTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUI];
        
    }
    
    return self;
}

- (void)configUI {

    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(1,0, SCREEN_WIDTH - 1, [CalendarTableViewCell getCalendarTableViewCellHeight])];
    
    calendar.dataSource = self;
    
    calendar.delegate = self;
    
    calendar.layer.cornerRadius = 5;
    
    calendar.layer.masksToBounds = YES;

    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    
    calendar.appearance.subtitleVerticalOffset = 3;
    
    calendar.appearance.subtitleFont = [UIFont systemFontOfSize:10.0f];
    
    calendar.appearance.titleFont = [UIFont fontWithName:@"ArialMT" size:18.0f];
    
    calendar.appearance.weekdayTextColor = LOWBLUECOLOR;
    
    calendar.appearance.headerTitleColor = LOWBLUECOLOR;
    
    calendar.appearance.weekdayFont = [UIFont fontWithName:@"ArialMT" size:18.0f];
    
    calendar.appearance.headerTitleFont = [UIFont fontWithName:@"ArialMT" size:18.0f];
    
    calendar.appearance.todayColor = LOWBLUECOLOR;
    
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    
    self.calendar = calendar;
    
    calendar.appearance.adjustsFontSizeToFitContentSize = NO;
    
    [self addSubview:calendar];
    
    //选择日期按钮
    UIButton *todayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [todayButton setTitle:@"今" forState:UIControlStateNormal];
    
    todayButton.frame = CGRectMake(SCREEN_WIDTH - 80.0f, 3.0f, 40.0f, 40.0f);
    
    [todayButton setTitleColor:RGBACOLOR(0, 111, 225, 1) forState:UIControlStateNormal];
    
    todayButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    [todayButton addTarget:self action:@selector(todayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    todayButton.tag = 3;
    
    self.todayButton = todayButton;
    
    [calendar setCurrentPage:[NSDate date] animated:NO];//设置
    
    [self addSubview:todayButton];
    
    //所有的提醒
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [allButton setTitle:@"所有提醒" forState:UIControlStateNormal];
    
    allButton.frame = CGRectMake(15.0f, 3.0f, 80.0f, 40.0f);
    
    [allButton setTitleColor:RGBACOLOR(0, 111, 225, 1) forState:UIControlStateNormal];
    
    allButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    [allButton addTarget:self action:@selector(allButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:allButton];
    
    //选择日期
    UIButton *chooseDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    chooseDateButton.frame = CGRectMake(SCREEN_WIDTH /2.0f - 60.0f, 1.0f, 120.0f, 40.0f);
    
    chooseDateButton.tag = 1;
    
    [chooseDateButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:chooseDateButton];
    
    //增加提醒时间
    UIButton *addRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addRemindButton.frame = CGRectMake(SCREEN_WIDTH - 40.0f, 1.0f, 40.0f, 40.0f);
    
    [addRemindButton setImage:[UIImage imageNamed:@"icon_add_events"] forState:UIControlStateNormal];
    
    [addRemindButton setTitle:@"" forState:UIControlStateNormal];
    
    addRemindButton.tag = 2;
    
    [addRemindButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:addRemindButton];
}

//选择日期
- (void)buttonClick:(UIButton *)button {
    
    if (self.chooseDateBlock) {
        
        self.chooseDateBlock(button.tag);
    }
}

- (void)allButtonClick {
    
    if (self.allBlock) {
        
        self.allBlock();
    }
}

//选择今天
- (void)todayButtonClick:(UIButton *)button {
    
    [_calendar selectDate:[NSDate date]];
    
    if (self.chooseDateBlock) {
        
        self.chooseDateBlock(button.tag);
    }
}

+ (CGFloat)getCalendarTableViewCellHeight {
    
    if (SCREEN_HEIGHT > 480 ) {
        
        return 350;
        
    } else {
        
        return 320;
    }
}

#pragma mark ---日历代理
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    
    NSMutableArray *dataArray = [[STRemindManager shareRemindManager] allRemindModelWithUserId:STUserAccountHandler.userProfile.userId dateString:[calendar stringFromDate:date format:@"yyyy-MM-dd"]];
    
    return dataArray.count;
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    
    calendar.height = CGRectGetHeight(bounds);
    
    [self layoutIfNeeded];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [selectedDates addObject:[calendar stringFromDate:date format:@"yyyy/MM/dd"]];
        
    }];
    
    //选择完时间进行回调
    if (self.dateBlock) {
        
        self.dateBlock(date);
    }
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date {
    
    return [Common getChineseCalendarWithDate:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
//    NSLog(@"%s %@", __FUNCTION__, [calendar stringFromDate:calendar.currentPage]);
}


#pragma mark ---
#pragma mark --- FSCalendarDelegateAppearance

//- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
//    
//    if ([[Common weekdayStringFromDate:date] isEqualToString:@"周日"] || [[Common weekdayStringFromDate:date] isEqualToString:@"周六"]) {
//        
////        if ([[[Common dateFormatterWithFormatterString:@"hhhh-MM-dd"] stringFromDate:date] isEqualToString:[[Common dateFormatterWithFormatterString:@"hhhh-MM-dd"] stringFromDate:[NSDate date]]]) {
////            
////            return [UIColor whiteColor];
////        }
//        
//        return LOWBLUECOLOR;
//    }
//    return appearance.borderDefaultColor;
//}
//
///**
// * Asks the delegate for subtitle text color in unselected state for the specific date.
// */
//- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date {
//
//    if ([[Common weekdayStringFromDate:date] isEqualToString:@"周日"] || [[Common weekdayStringFromDate:date] isEqualToString:@"周六"]) {
//        
////        if ([[[Common dateFormatterWithFormatterString:@"hhhh-MM-dd"] stringFromDate:date] isEqualToString:[[Common dateFormatterWithFormatterString:@"hhhh-MM-dd"] stringFromDate:[NSDate date]]]) {
////            
////            return [UIColor whiteColor];
////        }
//        
//        return LOWBLUECOLOR;
//    }
//    return appearance.borderDefaultColor;
//}
//
- (FSCalendarCellShape)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance cellShapeForDate:(NSDate *)date {
    
    return FSCalendarCellShapeRectangle;
}
//
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date {
    
    return LOWBLUECOLOR;
}

@end
