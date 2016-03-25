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

@end

@interface CityModel : NSObject < NSCoding >

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSMutableArray *businessCircleList;

@end

@interface BusinessCircleModel : NSObject < NSCoding >

@property (nonatomic,copy) NSString *name;

@end