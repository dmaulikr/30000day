//
//  AppointmentCollectionView.h
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  封装的本app显示订单可预约订单，已出售，我的预定等表格视图

#import <UIKit/UIKit.h>
#import "AppointmentCollectionViewCell.h"
#import "TitleCollectionViewCell.h"

@class AppointmentCollectionView;

//协议
@protocol AppointmentCollectionViewDelegate <NSObject>

@optional

- (NSString *)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView didSelectionAppointmentIndexPath:(NSIndexPath *)indexPath;

- (AppointmentColorType)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView typeForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface AppointmentCollectionView : UIView

@property (nonatomic,strong) NSMutableArray *time_dataArray;//左边时间数据源数组

@property (nonatomic,strong) NSMutableArray *dataArray;//上面标题数据源数组

@property (nonatomic,assign) id <AppointmentCollectionViewDelegate> delegate;

@end
