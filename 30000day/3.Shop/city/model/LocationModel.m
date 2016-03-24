//
//  LocationModel.m
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

#pragma mark ---- 将对象转化为NSData的方法

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.provinceArray forKey:@"provinceArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        //解压过程
        self.name= [aDecoder decodeObjectForKey:@"name"];
        
        self.provinceArray = [aDecoder decodeObjectForKey:@"provinceArray"];
       
    }
    return self;
}

@end


@implementation provinceModel

#pragma mark --- NSCoding的协议

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        self.cityArray = [aDecoder decodeObjectForKey:@"cityArray"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.cityArray forKey:@"cityArray"];
    
}

@end

@implementation CityModel

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        
        self.businessArray = [aDecoder decodeObjectForKey:@"businessArray"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.businessArray forKey:@"businessArray"];
}

@end