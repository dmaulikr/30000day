//
//  ProvinceModel.m
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel

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
        
        self.businessCircleArray = [aDecoder decodeObjectForKey:@"businessCircleArray"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.businessCircleArray forKey:@"businessCircleArray"];
}

@end

@implementation LocationModel

#pragma mark ---- 将对象转化为NSData的方法

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end

