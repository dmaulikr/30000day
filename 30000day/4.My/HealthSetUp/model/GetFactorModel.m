//
//  GetFactorModel.m
//  30000day
//
//  Created by GuoJia on 16/2/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "GetFactorModel.h"

@implementation GetFactorModel

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.factorId = [aDecoder decodeObjectForKey:@"factorId"];
        
        self.title = [aDecoder decodeObjectForKey:@"title"];
        
        self.subFactorArray = [aDecoder decodeObjectForKey:@"subFactorArray"];
        
        self.userSubFactorModel = [aDecoder decodeObjectForKey:@"userSubFactorModel"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.factorId forKey:@"factorId"];
    
    [aCoder encodeObject:self.title forKey:@"title"];
    
    [aCoder encodeObject:self.subFactorArray forKey:@"subFactorArray"];
    
    [aCoder encodeObject:self.userSubFactorModel forKey:@"userSubFactorModel"];
}

- (id)init {
    
    if (self = [super init]) {
        
        _subFactorArray = [NSMutableArray array];
        
        _userSubFactorModel = [[SubFactorModel alloc] init];
    }
    
    return self;
}

//用一个data 来取得subFactorArray里面模型里面的一个string
+ (NSString *)titleStringWithDataNumber:(NSNumber *)subFactorId subFactorArray:(NSMutableArray *)subFactorArray {
    
    for (int i = 0; i < subFactorArray.count ; i++) {
        
        SubFactorModel *subFactorModel = subFactorArray[i];
        
        if ([subFactorModel.subFactorId isEqual:subFactorId]) {
            
            return subFactorModel.title;
            
        }
    }
    
    return @"";
}

+ (NSNumber *)subFactorIdWithTitleString:(NSString *)string subFactorArray:(NSMutableArray *)subFactorArray {
    
    for (int i = 0; i < subFactorArray.count ; i++) {
        
        SubFactorModel *subFactorModel = subFactorArray[i];
        
        if ([subFactorModel.title isEqualToString:string]) {
            
            return subFactorModel.subFactorId;
            
        }
    }
    
    return @0;
}


@end

@implementation SubFactorModel

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.subFactorId = [aDecoder decodeObjectForKey:@"subFactorId"];
        
        self.factorId = [aDecoder decodeObjectForKey:@"factorId"];
        
        self.title = [aDecoder decodeObjectForKey:@"title"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.subFactorId forKey:@"subFactorId"];
    
    [aCoder encodeObject:self.factorId forKey:@"factorId"];
    
    [aCoder encodeObject:self.title forKey:@"title"];
}

@end