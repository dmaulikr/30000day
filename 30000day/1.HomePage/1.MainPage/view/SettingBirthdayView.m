//
//  SettingBirthdayView.m
//  30000day
//
//  Created by GuoJia on 16/5/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SettingBirthdayView.h"

@interface SettingBirthdayView () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView *gentView;//性别设置

@property (nonatomic,strong) UIDatePicker *birthdayView;//生日设置

@property (nonatomic,strong) UIButton *button;


@end

@implementation SettingBirthdayView {
    
    NSInteger _selectorRow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init {
    
    if (self = [super init]) {
        
        [self configUI];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configUI];
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    
    return self;
}

- (void)configUI {
    
    if (!self.birthdayView) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        datePicker.datePickerMode = UIDatePickerModeDate;
        
        datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-(200.00000 * 365.00000 * 24.000000 * 60.00000 * 60.00000)];
        
        datePicker.maximumDate = [NSDate date];
        
        datePicker.backgroundColor = [UIColor whiteColor];
        
        datePicker.frame = CGRectMake(0, 20 + 40, SCREEN_WIDTH,200);
        
        datePicker.date = [NSDate date];
        
        [self addSubview:datePicker];
        
        self.birthdayView = datePicker;
        
        //生日标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMinY(datePicker.frame) - 40, SCREEN_WIDTH, 40)];
        
        label.font = [UIFont systemFontOfSize:15.0f];
        
        label.text = @"设置生日";
        
        [self addSubview:label];
    }
    
    if (!self.gentView) {
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.birthdayView.frame) +  60,SCREEN_WIDTH,120)];
        
        pickerView.showsSelectionIndicator = YES;
        
        pickerView.dataSource = self;
        
        pickerView.delegate = self;
        
        pickerView.backgroundColor = [UIColor whiteColor];
        
        self.gentView = pickerView;
        
        [self addSubview:pickerView];
        
        //性别标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMinY(pickerView.frame) - 40, SCREEN_WIDTH, 40)];
        
        label.text = @"设置性别";
        
        label.font = [UIFont systemFontOfSize:15.0f];
        
        [self addSubview:label];
    }
    
    if (!self.button) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"开始体验" forState:UIControlStateNormal];
        
        button.frame = CGRectMake(0,SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
        
        button.backgroundColor = LOWBLUECOLOR;
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        self.button = button;
    }
    
    _selectorRow = 1;//初始化
}

- (void)saveButtonAction {
    
    if (self.saveBlock) {
        
        self.saveBlock(self.birthdayView.date,[NSNumber numberWithInteger:_selectorRow]);
        
    }
}

- (void)removeBirthdayView {
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        self.alpha = 1.0f;
        
        [self removeFromSuperview];
        
    }];
}

#pragma mark --- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (row == 0) {
        
        return @"男";
        
    } else {
        
        return @"女";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (row == 0) {
        
        _selectorRow = 1;
        
    } else {
        
        _selectorRow = 0;
    }
}

@end
