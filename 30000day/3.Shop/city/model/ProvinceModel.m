//
//  ProvinceModel.m
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"cityList" : [CityModel class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"provinceId":@"id"};
}

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.regionName = [aDecoder decodeObjectForKey:@"regionName"];
        
        self.cityList = [aDecoder decodeObjectForKey:@"cityList"];
        
        self.provinceId = [aDecoder decodeObjectForKey:@"provinceId"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.regionName forKey:@"regionName"];
    
    [aCoder encodeObject:self.cityList forKey:@"cityList"];
    
    [aCoder encodeObject:self.provinceId forKey:@"provinceId"];
}

@end



@implementation CityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"countyList" : [RegionalModel class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"cityId":@"id"};
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.regionName = [aDecoder decodeObjectForKey:@"regionName"];
        
        self.countyList = [aDecoder decodeObjectForKey:@"countyList"];
        
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        
        self.isHotCity = [aDecoder decodeObjectForKey:@"isHotCity"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.regionName forKey:@"regionName"];
    
    [aCoder encodeObject:self.countyList forKey:@"countyList"];
    
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    
    [aCoder encodeObject:self.isHotCity forKey:@"isHotCity"];
}

@end




@implementation RegionalModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{ @"businessCircleList" : [BusinessCircleModel class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"regionalId":@"id"};
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.regionName = [aDecoder decodeObjectForKey:@"regionName"];
        
        self.businessCircleList = [aDecoder decodeObjectForKey:@"businessCircleList"];
        
        self.regionalId = [aDecoder decodeObjectForKey:@"regionalId"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.regionName forKey:@"regionName"];
    
    [aCoder encodeObject:self.businessCircleList forKey:@"businessCircleList"];
    
    [aCoder encodeObject:self.regionalId forKey:@"regionalId"];
}

@end



@implementation BusinessCircleModel

#pragma mark ---- 将对象转化为NSData的方法

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"regionName":@"name"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.regionName forKey:@"regionName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.regionName = [aDecoder decodeObjectForKey:@"regionName"];
    }
    return self;
}

@end


@implementation HotCityModel


@end


