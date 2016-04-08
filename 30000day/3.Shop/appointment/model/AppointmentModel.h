//
//  AppointmentModel.h
//  30000day
//
//  Created by GuoJia on 16/4/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  可预约模型

#import <Foundation/Foundation.h>

@interface AppointmentModel : NSObject

@property (nonatomic,strong) NSMutableArray *timeRangeList;

@property (nonatomic,strong) NSNumber *courtId;//场地id

@property (nonatomic,copy)   NSString *courtKey;

@property (nonatomic,copy)   NSString *name;

@property (nonatomic,copy)   NSString *date;

@end

@interface AppointmentTimeModel : NSObject

@property (nonatomic,copy) NSString *status;//状态

@property (nonatomic,copy) NSString *timeRange;//09：00 ~ 10:00

@property (nonatomic,copy) NSString *uniqueKey;

@property (nonatomic,copy) NSString *price;//价格

@property (nonatomic,copy) NSString *isMine;//是否是我的预定

@property (nonatomic,copy) NSString *reserverName;//guojia

@property (nonatomic,copy) NSString *reserverContactNo;//18121241905

@property (nonatomic,copy) NSString *courtName;//1号场

@property (nonatomic,copy) NSString *memo;//remark

@end


