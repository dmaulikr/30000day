//
//  AppointmentCollectionView.h
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppointmentCollectionView;

//协议
@protocol AppointmentCollectionViewDelegate <NSObject>

@optional

- (void)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView didSelectionAppointmentIndexPath:(NSIndexPath *)indexPath;

@end

@interface AppointmentCollectionView : UIView

@property (nonatomic,strong) NSMutableArray *time_dataArray;//左边时间数据源数组

@property (nonatomic,strong) NSMutableArray *dataArray;//上面标题数据源数组

@property (nonatomic,assign) id <AppointmentCollectionViewDelegate> delegate;

@end
