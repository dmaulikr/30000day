//
//  AppointmentCollectionView.h
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppointmentCollectionView;

typedef NS_ENUM (NSInteger,AppointmentColorType) {
    
    AppointmentColorCanUse = 0,//可用状态
    
    AppointmentColorMyUse,//我的预定
    
    AppointmentColorSellOut,//已经售完
    
    AppointmentColorNoneUse,//不可用
};

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
