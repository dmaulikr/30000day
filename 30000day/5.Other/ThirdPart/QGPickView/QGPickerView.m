//
//  QGPickerView.m
//  QGym
//
//  Created by win5 on 9/29/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import "QGPickerView.h"

@interface QGPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong)NSArray *dataArray_1;

@property (nonatomic,strong)NSArray *dataArray_2;

@property (nonatomic,strong)NSArray *dataArray_3;

@property (nonatomic,strong)UIView *maskView;

@property (nonatomic,strong)UIPickerView *pickerView_1;

@property (nonatomic,strong)UIPickerView *pickerView_2;

@property (nonatomic,strong)UIPickerView *pickerView_3;

@property(nonatomic,retain)UILabel *titelLabel;//中间标题的按钮

@property (nonatomic,assign) NSInteger num;//pickerView


@property (nonatomic,assign) BOOL isDatePicker;//YES表示是datePicker NO表示是pickView


@property (nonatomic,strong) UIDatePicker *datePicker;


@end

@implementation QGPickerView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
     
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 44)];
        
        topView.backgroundColor = RGBACOLOR(67,106,183, 1);
        
        [self addSubview:topView];
        
        self.backgroundColor = [UIColor whiteColor];
        
        //右边确定按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"确定" forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [topView addSubview:button];
        
        //中间标题Label
        UILabel *titelLabel = [[UILabel alloc] init];
        
        [titelLabel setTextColor:[UIColor whiteColor]];
        
        titelLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [topView addSubview:titelLabel];
        
        self.titelLabel = titelLabel;
        
        //标题label添加约束
        NSLayoutConstraint *labelContraint_x = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titelLabel attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
        
        [topView addConstraint:labelContraint_x];
        
        NSLayoutConstraint *labelContraint_y = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:titelLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        
        [topView addConstraint:labelContraint_y];
        
        //button添加约束
        NSLayoutConstraint *buttonContraint_y = [NSLayoutConstraint constraintWithItem:topView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        
        [topView addConstraint:buttonContraint_y];
        
        NSArray *buttonClickContraint_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(40)]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
        
        NSArray *buttonClickContraint_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
        
        [topView addConstraints:buttonClickContraint_h];
        
        [topView addConstraints:buttonClickContraint_v];
        
        //加点击取消的手势
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height)];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doCancel)];
        
        [maskView addGestureRecognizer:gesture];
        
        self.maskView = maskView;
        
        self.maskView.backgroundColor = RGBACOLOR(200,200,200, 0.3);

    }
    
    return self;
}

- (void)doCancel {
    
    [self hide];
}

//隐藏动画效果
- (void)hide {
    
    __block CGRect frame = self.frame;
    
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         
                         frame.origin.y += frame.size.height;
                         
                         self.frame = frame;
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self.maskView removeFromSuperview];
                         
                         [self removeFromSuperview];
                     }];
}

//确定按钮点击事件
- (void)buttonClick {
    
    if (self.isDatePicker == NO ) {//不是专门的日期选择器
        
        if (self.num == 1) {
            
            NSInteger row_1 = [self.pickerView_1 selectedRowInComponent:0];
            
            if (row_1 >= 0 ) {
                
                if (self.dataArray_1.count >= 1) {
                    
                    NSString *title_1 = [self.dataArray_1 objectAtIndex:row_1];
                    
                    if (self.delegate) {
                        
                        if ([self.delegate respondsToSelector:@selector(didSelectPickView:value:indexOfPickerView:indexOfValue:)]) {
                            
                            [self.delegate didSelectPickView:self value:title_1 indexOfPickerView:1 indexOfValue:row_1];
                            
                        }
                        
                    }
                    
                }
                
                [self hide];
                
            }
        } else if (self.num == 2) {
            
            NSInteger row_1 = [self.pickerView_1 selectedRowInComponent:0];
            
            NSInteger row_2 = [self.pickerView_2 selectedRowInComponent:0];
            
            if (row_1 >= 0 && (row_2 >= 0) ) {
                
                if ((self.dataArray_1.count >= 1) && (self.dataArray_2.count >= 1)) {
                    
                    NSString *title_1 = [self.dataArray_1 objectAtIndex:row_1];
                    
                    NSString *title_2 = [self.dataArray_2 objectAtIndex:row_2];
                    
                    if (self.delegate) {
                        
                        if ([self.delegate respondsToSelector:@selector(didSelectPickView:value:indexOfPickerView:indexOfValue:)]) {
                            
                            [self.delegate didSelectPickView:self value:title_1 indexOfPickerView:1 indexOfValue:row_1];
                            
                            [self.delegate didSelectPickView:self value:title_2 indexOfPickerView:2 indexOfValue:row_2];
                        }
                        
                        
                    }
                    
                }
                
            }
            
            [self hide];
            
        } else if (self.num == 3) {
            
            NSInteger row_1 = [self.pickerView_1 selectedRowInComponent:0];
            
            NSInteger row_2 = [self.pickerView_2 selectedRowInComponent:0];
            
            NSInteger row_3 = [self.pickerView_3 selectedRowInComponent:0];
            
            if ((row_1 >= 0) && (row_2 >= 0) &&  (row_3 >= 0)) {
                
                if ((self.dataArray_1.count >= 1) && (self.dataArray_2.count >= 1) && (self.dataArray_3.count >= 1)) {
                    
                    NSString *title_1 = [self.dataArray_1 objectAtIndex:row_1];
                    
                    NSString *title_2 = [self.dataArray_2 objectAtIndex:row_2];
                    
                    NSString *title_3 = [self.dataArray_3 objectAtIndex:row_3];
                    
                    if (self.delegate) {
                        
                        if ([self.delegate respondsToSelector:@selector(didSelectPickView:value:indexOfPickerView:indexOfValue:)]) {
                            
                            [self.delegate didSelectPickView:self value:title_1 indexOfPickerView:1 indexOfValue:row_1];
                            
                            [self.delegate didSelectPickView:self value:title_2 indexOfPickerView:2 indexOfValue:row_2];
                            
                            [self.delegate didSelectPickView:self value:title_3 indexOfPickerView:3 indexOfValue:row_3];
                        }
                        
                        
                    }
                }
                
                [self hide];
                
            }
        }
        
    } else {//是专门的日期选择器
        
         [self hide];
        
        if ([self.delegate respondsToSelector:@selector(didSelectPickView:selectDate:)]) {
            
            [self.delegate didSelectPickView:self selectDate:self.datePicker.date];
            
        }
        
    }
}

- (void)showDataPickView:(UIView *)superView WithDate:(NSDate *)willShowDate datePickerMode:(UIDatePickerMode)datePickerMode minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate {
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    datePicker.datePickerMode = datePickerMode;
    
    datePicker.minimumDate = minimumDate;
    
    datePicker.maximumDate = maximumDate;
    
//  [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GTM+8"]];
    
    datePicker.backgroundColor = [UIColor whiteColor];
    
    datePicker.frame = CGRectMake(0, 44, (float)self.bounds.size.width, self.bounds.size.height-44);
    
    datePicker.date = willShowDate;
    
    [superView addSubview:self.maskView];
    
    [superView addSubview:self];
    
    [self addSubview:datePicker];
    
    self.isDatePicker = YES;
    
    self.datePicker = datePicker;
    
    __block CGRect frame = self.frame;
    
    frame.origin.y = superView.bounds.size.height;
    
    self.frame = frame;
    
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         
                         frame.origin.y -= frame.size.height;
                         
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


- (void)showPickView:(UIView *)superView withPickerViewNum:(NSInteger)num withArray:(NSArray *)dataArray_1 withArray:(NSArray *)dataArray_2 withArray:(NSArray *)dataArray_3 selectedTitle:(NSString *)selectedTitle_1 selectedTitle:(NSString *)selectedTitle_2 selectedTitle:(NSString *)selectedTitle_3 {
    
    self.dataArray_1 = dataArray_1 ? dataArray_1 : [NSMutableArray array];
    
    self.dataArray_2 = dataArray_2 ? dataArray_2 : [NSMutableArray array];
    
    self.dataArray_3 = dataArray_3 ? dataArray_3 : [NSMutableArray array];
    
    self.num = num;
    
    [superView addSubview:self.maskView];
    
    [superView addSubview:self];
    
    self.isDatePicker = NO;

    
    //循环创建pickerView
    for (int i = 0; i < num; i++) {
        
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 + i * (float)self.bounds.size.width/num, 44, self.bounds.size.width/num, self.bounds.size.height-44)];
        
        pickerView.showsSelectionIndicator = YES;
        
        [self addSubview:pickerView];
        
        if (i == 0) {
            
            self.pickerView_1 = pickerView;
            
            self.pickerView_1.dataSource = self;
            
            self.pickerView_1.delegate = self;
            
            NSUInteger index = [self.dataArray_1 indexOfObject:selectedTitle_1];
            
            if (index < dataArray_1.count) {
                
                [self.pickerView_1 selectRow:index inComponent:0 animated:NO];
                
            }
            
        } else if (i == 1) {
            
            self.pickerView_2 = pickerView;
            
            self.pickerView_2.dataSource = self;
            
            self.pickerView_2.delegate = self;
            
            NSUInteger index = [self.dataArray_2 indexOfObject:selectedTitle_2];
            
            if (index < dataArray_2.count) {
                
                [self.pickerView_2 selectRow:index inComponent:0 animated:NO];
                
            }
            
        } else if (i == 2) {
            
            self.pickerView_3 = pickerView;
            
            self.pickerView_3.dataSource = self;
            
            self.pickerView_3.delegate = self;
            
            NSUInteger index = [self.dataArray_3 indexOfObject:selectedTitle_3];
            
            if (index < dataArray_3.count) {
                
                [self.pickerView_3 selectRow:index inComponent:0 animated:NO];
                
            }
        }
    }
    
    __block CGRect frame = self.frame;
    
    frame.origin.y = superView.bounds.size.height;
    
    self.frame = frame;
    
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^{
                         
                         frame.origin.y -= frame.size.height;
                         
                         self.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

//重写setter方法
- (void)setTitleText:(NSString *)titleText {
    
    _titleText = titleText;
    
    [self setNeedsDisplay];
}

//重新描绘
- (void)drawRect:(CGRect)rect {
    
    self.titelLabel.text = self.titleText;
}

#pragma mark --- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == self.pickerView_1) {
        
        return self.dataArray_1.count;
        
    } else if (pickerView == self.pickerView_2) {
        
        return self.dataArray_2.count;
        
    } else if (pickerView == self.pickerView_3) {
        
        return self.dataArray_3.count;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == self.pickerView_1) {
        
        NSString *title = [self.dataArray_1 objectAtIndex:row];
        
        return title;
        
    } else if (pickerView == self.pickerView_2) {
        
        NSString *title = [self.dataArray_2 objectAtIndex:row];
        
        return title;
    } else if (pickerView == self.pickerView_3) {
        
        NSString *title = [self.dataArray_3 objectAtIndex:row];
        return title;
    }
    return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}


@end
