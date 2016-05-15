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


@end

@implementation PhysicalExaminationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.physicalExaminationLastTimePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    self.physicalExaminationLastTimePicker.datePickerMode = UIDatePickerModeDate;
    
    self.physicalExaminationLastTimePicker.maximumDate = [NSDate date];
    
    self.physicalExaminationLastTimePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-(100.00000 * 365.00000 * 24.000000 * 60.00000 * 60.00000)];
    
    self.physicalExaminationLastTimePicker.maximumDate = [NSDate date];
    
    self.physicalExaminationLastTimePicker.backgroundColor = [UIColor whiteColor];

    self.physicalExaminationLastTimePicker.date = [NSDate date];
    
    
    self.physicalExaminationIntervalPicker.showsSelectionIndicator = YES;
    
    self.physicalExaminationIntervalPicker.dataSource = self;
    
    self.physicalExaminationIntervalPicker.delegate = self;
    
    self.physicalExaminationIntervalPicker.backgroundColor = [UIColor whiteColor];
    
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
    
    if (row == 0) {
    
        
    
    } else if (row == 1) {
    
        
    
    }
    
}

- (void)commitData {

    NSLog(@"%@",self.physicalExaminationLastTimePicker.date);
    
}



@end
