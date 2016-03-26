//
//  ProvinceModel.h
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject < NSCoding >

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *cityList;

@property (nonatomic,strong) NSNumber *provinceId;

@end

@interface CityModel : NSObject < NSCoding >

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *countyList;

@property (nonatomic,strong) NSNumber *cityId;

@end

@interface RegionalModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *businessCircleList;

@property (nonatomic,strong) NSNumber *regionalId;

@end

@interface BusinessCircleModel : NSObject < NSCoding >

@property (nonatomic,copy) NSString *name;

@end