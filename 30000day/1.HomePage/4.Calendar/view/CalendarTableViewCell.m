//
//  CalendarTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CalendarTableViewCell.h"


@interface CalendarTableViewCell () <FSCalendarDataSource, FSCalendarDelegate ,FSCalendarDelegateAppearance >

@property (strong, nonatomic) NSCalendar *lunarCalendar;

@property (strong, nonatomic) NSArray *lunarChars;

@property (strong, nonatomic) NSDictionary *selectionColors;

@property (strong, nonatomic) NSDictionary *borderDefaultColors;

@property (strong, nonatomic) NSDictionary *borderSelectionColors;

@property (strong, nonatomic) NSArray *datesWithEvent;

@property (strong, nonatomic) NSArray *datesWithMultipleEvents;

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
    
    self.selectionColors = @{@"2016/3/29":[UIColor greenColor],
                             @"2016/3/30":[UIColor purpleColor],
                             @"2016/3/31":[UIColor grayColor],
                             @"2016/4/1":[UIColor cyanColor],
                             @"2016/4/2":[UIColor greenColor],
                             @"2016/4/3":[UIColor purpleColor],
                             @"2016/4/4":[UIColor grayColor],
                             @"2016/4/5":[UIColor cyanColor],
                             @"2016/4/6":[UIColor greenColor],
                             @"2016/4/7":[UIColor purpleColor],
                             @"2016/4/8":[UIColor grayColor],
                             @"2016/4/9":[UIColor cyanColor]};
    
    self.borderDefaultColors = @{@"2016/3/29":[UIColor brownColor],
                                 @"2016/3/30":[UIColor magentaColor],
                                 @"2016/3/31":FSCalendarStandardSelectionColor,
                                 @"2016/4/1":[UIColor blackColor],
                                 @"2016/4/2":[UIColor brownColor],
                                 @"2016/4/3":[UIColor magentaColor],
                                 @"2016/4/4":FSCalendarStandardSelectionColor,
                                 @"2016/4/5":[UIColor blackColor],
                                 @"2016/4/6":[UIColor brownColor],
                                 @"2016/4/7":[UIColor magentaColor],
                                 @"2016/4/8":FSCalendarStandardSelectionColor,
                                 @"2016/4/9":[UIColor blackColor]};
    
    self.borderSelectionColors = @{@"2016/3/29":[UIColor redColor],
                                   @"2016/3/30":[UIColor purpleColor],
                                   @"22016/3/31":FSCalendarStandardSelectionColor,
                                   @"2016/4/1":FSCalendarStandardTodayColor,
                                   @"2016/4/2":[UIColor redColor],
                                   @"2016/4/3":[UIColor purpleColor],
                                   @"2016/4/4":FSCalendarStandardSelectionColor,
                                   @"2016/4/5":FSCalendarStandardTodayColor,
                                   @"2016/4/6":[UIColor redColor],
                                   @"2016/4/7":[UIColor purpleColor],
                                   @"2016/4/8":FSCalendarStandardSelectionColor,
                                   @"2016/4/9":FSCalendarStandardTodayColor};
    
    
    self.datesWithEvent = @[@"2016-03-29",
                            @"2016-03-30",
                            @"2015-03-31",
                            @"2015-03-28"];
    
    self.datesWithMultipleEvents = @[@"2016-03-08",
                                     @"2016-03-16",
                                     @"2016-03-20",
                                     @"2016-03-28"];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(1,0, SCREEN_WIDTH - 1, 350)];
    
    calendar.dataSource = self;
    
    calendar.delegate = self;
    
    calendar.layer.cornerRadius = 5;
    
    calendar.layer.masksToBounds = YES;

    calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    
    calendar.appearance.subtitleVerticalOffset = 3;
    
    calendar.appearance.subtitleFont = [UIFont systemFontOfSize:10.0f];
    
    calendar.appearance.titleFont = [UIFont fontWithName:@"ArialMT" size:18.0f];
    
    calendar.appearance.weekdayTextColor = RGBACOLOR(0, 111, 225, 1);
    
    calendar.appearance.headerTitleColor = RGBACOLOR(0, 111, 225, 1);
    
    calendar.appearance.weekdayFont = [UIFont fontWithName:@"ArialMT" size:18.0f];
    
    calendar.appearance.headerTitleFont = [UIFont fontWithName:@"ArialMT" size:18.0f];
    
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
    
    [todayButton addTarget:self action:@selector(todayButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.todayButton = todayButton;
    
    [self addSubview:todayButton];
    
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
    
    //创建背景线条
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,40, SCREEN_WIDTH, 0.5f)];
    
    view.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    
    [self addSubview:view];
    
    _lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    _lunarCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    
    _lunarChars = @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二一",@"二二",@"二三",@"二四",@"二五",@"二六",@"二七",@"二八",@"二九",@"三十"];
}

//选择日期
- (void)buttonClick:(UIButton *)button {
    
    if (self.chooseDateBlock) {
        
        self.chooseDateBlock(button.tag);
    }
}

//选择今天
- (void)todayButtonClick {
    
    [_calendar selectDate:[NSDate date]];
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    
    NSString *dateString = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
    
    if ([_datesWithEvent containsObject:dateString]) {
        
        return 1;
    }
    
    if ([_datesWithMultipleEvents containsObject:dateString]) {
        
        return 3;
    }
    
    return 0;
}

//- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
//    
//    calendar.height = CGRectGetHeight(bounds);
//    
//    [self layoutIfNeeded];
//}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    
    NSLog(@"did select date %@",[calendar stringFromDate:date format:@"yyyy/MM/dd"]);
    
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
    
//    NSInteger day = [_lunarCalendar components:NSCalendarUnitDay fromDate:date].day;
//    
//    return _lunarChars[day-1];
    
    return [Common getChineseCalendarWithDate:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    
    NSLog(@"%s %@", __FUNCTION__, [calendar stringFromDate:calendar.currentPage]);
}

#pragma mark - <FSCalendarDelegateAppearance>

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date {
//    
//    NSString *dateString = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
//    
//    if ([_datesWithEvent containsObject:dateString]) {
//        
//        return [UIColor purpleColor];
//    }
//    return nil;
//}
//
//- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorsForDate:(NSDate *)date {
//    
//    NSString *dateString = [calendar stringFromDate:date format:@"yyyy-MM-dd"];
//    if ([_datesWithMultipleEvents containsObject:dateString]) {
//        return @[[UIColor magentaColor],appearance.eventColor,[UIColor blackColor]];
//    }
//    return nil;
//}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date {
//    
//    NSString *key = [_calendar stringFromDate:date format:@"yyyy/MM/dd"];
//    
//    if ([_selectionColors.allKeys containsObject:key]) {
//        
//        return _selectionColors[key];
//    }
//    
//    return appearance.selectionColor;
//}
//
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date {
//    
//    NSString *key = [_calendar stringFromDate:date format:@"yyyy/MM/dd"];
//    
//    if ([_borderDefaultColors.allKeys containsObject:key]) {
//        
//        return _borderDefaultColors[key];
//    }
//    
//    return appearance.borderDefaultColor;
//}

//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date {
//    
//    NSString *key = [_calendar stringFromDate:date format:@"yyyy/MM/dd"];
//    
//    if ([_borderSelectionColors.allKeys containsObject:key]) {
//        
//        return _borderSelectionColors[key];
//        
//    }
//    
//    return appearance.borderSelectionColor;
//}

#pragma mark ---
#pragma mark --- FSCalendarDelegateAppearance

- (FSCalendarCellShape)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance cellShapeForDate:(NSDate *)date {
    
    if ([@[@8,@17,@21,@25] containsObject:@([_calendar dayOfDate:date])]) {
        
        return FSCalendarCellShapeRectangle;
        
    }
    
    return FSCalendarCellShapeCircle;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date {
    
    if ([_calendar dayOfDate:date] % 2 == 0) {
        
        return appearance.selectionColor;
    }
    
    return [UIColor purpleColor];
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date {
    
    if ([@[@17,@18,@19] containsObject:@([calendar dayOfDate:date])]) {
        
        return [UIColor magentaColor];
    }
    return appearance.borderDefaultColor;
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    
//    if ([@[@17,@18,@19] containsObject:@([calendar dayOfDate:date])]) {
//        
//        return RGBACOLOR(0, 111, 225, 1);
//    }
    
    if ([[Common weekdayStringFromDate:date] isEqualToString:@"周日"] || [[Common weekdayStringFromDate:date] isEqualToString:@"周六"]) {
        
        return RGBACOLOR(0, 111, 225, 1);
    }
    return appearance.borderDefaultColor;
}

/**
 * Asks the delegate for subtitle text color in unselected state for the specific date.
 */
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date {
    
//    if ([@[@17,@18,@19] containsObject:@([calendar dayOfDate:date])]) {
//        
//        return RGBACOLOR(0, 111, 225, 1);
//    }
//    return appearance.borderDefaultColor;

    if ([[Common weekdayStringFromDate:date] isEqualToString:@"周日"] || [[Common weekdayStringFromDate:date] isEqualToString:@"周六"]) {
        
        return RGBACOLOR(0, 111, 225, 1);
    }
    return appearance.borderDefaultColor;
}

@end
