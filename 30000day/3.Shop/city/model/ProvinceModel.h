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

@property (nonatomic,assign) BOOL isSpecial;//YES:表示直辖市  NO:表示普通的省

@property (nonatomic,copy) NSString *code;

@end

@interface CityModel : NSObject < NSCoding >

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *countyList;

@property (nonatomic,copy) NSString *code;

@end

@interface RegionalModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *countyList;

@property (nonatomic,copy) NSString *code;

@end

@interface BusinessCircleModel : NSObject < NSCoding >

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *code;

@end