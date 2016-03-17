//
//  ProvinceModel.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic,strong) NSNumber *averageLife;

@property (nonatomic,strong) NSNumber *code;

@property (nonatomic,strong) NSNumber *fraction;

@property (nonatomic,strong) NSNumber *provinceId;

@property (nonatomic,copy) NSMutableArray *cityArray;

@end

