//
//  PhysicalExaminationViewController.m
//  30000day
//
//  Created by wei on 16/5/13.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PhysicalExaminationViewController.h"

@interface PhysicalExaminationViewController () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIDatePicker *physicalExaminationLastTimePicker;

@property (weak, nonatomic) IBOutlet UIPickerView *physicalExaminationIntervalPicker;

@property (weak, nonatomic) IBOutlet UIButton *completeButton;

@property (nonatomic,assign) NSInteger selectRow;


@end

@implementation PhysicalExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.physicalExaminationLastTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    self.physicalExaminationLastTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    self.physicalExaminationLastTimePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:(10 * 365.00000 * 24.000000 * 60.00000 * 60.00000)];
    
    self.physicalExaminationLastTimePicker.minimumDate = [NSDate date];
    
    self.physicalExaminationLastTimePicker.backgroundColor = [UIColor whiteColor];

    if ([Common isObjectNull:[Common readAppDataForKey:CHECK_DATE]]) {//表示之前没存储过时间
        
        self.physicalExaminationLastTimePicker.date = [NSDate date];
        
    } else {//已经有存储了时间
        
        if ([[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] dateFromString:[Common readAppDataForKey:CHECK_DATE]] compare:[NSDate date]] == NSOrderedAscending) {//表示已经过时了
            
            self.physicalExaminationLastTimePicker.date = [NSDate date];
            
        } else {
            
            self.physicalExaminationLastTimePicker.date = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] dateFromString:[Common readAppDataForKey:CHECK_DATE]];
        }
    }
    
    self.physicalExaminationIntervalPicker.showsSelectionIndicator = YES;
    
    self.physicalExaminationIntervalPicker.dataSource = self;
    
    self.physicalExaminationIntervalPicker.delegate = self;
    
    self.physicalExaminationIntervalPicker.backgroundColor = [UIColor whiteColor];
    
    if ([Common isObjectNull:[Common readAppDataForKey:CHECK_REPEAT]]) {
        
        [self.physicalExaminationIntervalPicker selectRow:0 inComponent:0 animated:NO];
        
    } else {
        
        if ([[Common readAppDataForKey:CHECK_REPEAT] isEqualToNumber:@0]) {
            
        } else {
            
            [self.physicalExaminationIntervalPicker selectRow:1 inComponent:0 animated:NO];
        }
    }
    
    [self.completeButton addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        return @"半年";
        
    } else {
        
        return @"一年";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectRow = row;
    
}

- (void)commitData {

    [Common saveAppDataForKey:CHECK_REPEAT withObject:@(self.selectRow)];
    
    [Common saveAppDataForKey:CHECK_DATE withObject:[[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate:self.physicalExaminationLastTimePicker.date]];
    
    if (self.setSuccessBlock) {
        
        self.setSuccessBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
