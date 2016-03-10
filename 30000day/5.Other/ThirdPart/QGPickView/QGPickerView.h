//
//  QGPickerView.h
//  QGym
//
//  Created by win5 on 9/29/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QGPickerViewDelegate;

@interface QGPickerView : UIView

@property(nonatomic,copy)NSString *titleText;

@property (nonatomic,weak)id <QGPickerViewDelegate> delegate;

/**
 * 配置QGPickerView 并初始化数据源
 * num   最多只能三个pickerView 并且num要和后面array配套 num是几 后面要写几个数据源
 * dataArray_1   第一pickerView 的数据源
 * dataArray_2   第二pickerView 的数据源
 * dataArray_3   第三pickerView 的数据源
 * selectedTitle_1    第一pickerView初始化选中的title
 * selectedTitle_2    第二pickerView初始化选中的title
 * selectedTitle_3    第三pickerView初始化选中的title
 */
- (void)showPickView:(UIView *)superView withPickerViewNum:(NSInteger)num withArray:(NSArray *)dataArray_1 withArray:(NSArray *)dataArray_2 withArray:(NSArray *)dataArray_3 selectedTitle:(NSString *)selectedTitle_1 selectedTitle:(NSString *)selectedTitle_2 selectedTitle:(NSString *)selectedTitle_3;

- (void)showDataPickView:(UIView *)superView WithDate:(NSDate *)willShowDate datePickerMode:(UIDatePickerMode)datePickerMode minimumDate:(NSDate *)minimumDate maximumDate:(NSDate *)maximumDate;

@end

@protocol QGPickerViewDelegate <NSObject>

@optional

/**
 * QGPicerkview代理回调方法
 * @param pickView 本视图
 * @param value 表示选中的title值
 * @param index 表示第几个UIPickerView[不是QGPickerView]
 * @param valueIndex value处在之前初始化的数组中的位置[这个数组是之前一一对应的]
 */
- (void)didSelectPickView:(QGPickerView *)pickView  value:(NSString *)value indexOfPickerView:(NSInteger)index indexOfValue:(NSInteger)valueIndex;

- (void)didSelectPickView:(QGPickerView *)pickView selectDate:(NSDate *)selectorDate;

@end