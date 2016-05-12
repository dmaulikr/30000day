//
//  WeatherInformationModel.h
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInformationModel : NSObject

@property (nonatomic,copy) NSString *cityName;//城市名字

@property (nonatomic,copy) NSString *temperatureString;//温度

@property (nonatomic,copy) NSString *pm25Quality;//空气质量

@property (nonatomic,copy) NSString *weatherShowImageString;//显示天气的图片名字

@property (nonatomic,copy) NSString *sport;

@end
