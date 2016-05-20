//
//  GetFactorModel.m
//  30000day
//
//  Created by GuoJia on 16/2/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "GetFactorModel.h"

@implementation GetFactorModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{@"factorId":@"id"};
}

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.factorId = [aDecoder decodeObjectForKey:@"factorId"];
        
        self.factor = [aDecoder decodeObjectForKey:@"factor"];
        
        self.subFactorArray = [aDecoder decodeObjectForKey:@"subFactorArray"];
        
        self.userSubFactorModel = [aDecoder decodeObjectForKey:@"userSubFactorModel"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.factorId forKey:@"factorId"];
    
    [aCoder encodeObject:self.factor forKey:@"factor"];
    
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
+ (NSString *)titleStringWithDataNumber:(NSNumber *)factorId subFactorArray:(NSMutableArray *)subFactorArray {
    
    for (int i = 0; i < subFactorArray.count ; i++) {
        
        SubFactorModel *subFactorModel = subFactorArray[i];
        
        if ([subFactorModel.factorId isEqual:factorId]) {
            
            return subFactorModel.factor;
        }
    }
    
    return @"";
}

+ (NSNumber *)subFactorIdWithTitleString:(NSString *)string subFactorArray:(NSMutableArray *)subFactorArray {
    
    for (int i = 0; i < subFactorArray.count ; i++) {
        
        SubFactorModel *subFactorModel = subFactorArray[i];
        
        if ([subFactorModel.factor isEqualToString:string]) {
            
            return subFactorModel.factorId;
            
        }
    }
    
    return @0;
}

//获取一组数据,身高，体重，平均每日被动吸烟支数，被动吸烟年数
+ (NSMutableArray *)configFactorModelArray {
    
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:@[@"身高",@"体重",@"平均每日被动吸烟支数",@"被动吸烟年数"]];
    
    for (int i = 0; i < 4; i++) {
        
        if (i == 0) {
            
            GetFactorModel *model = [[GetFactorModel alloc] init];
            
            model.factor = @"身高";
            
            model.level = @"1";
            
            model.subFactorArray = [[NSMutableArray alloc] init];
            
            model.userSubFactorModel = [[SubFactorModel alloc] init];
            
            for (int i = 1; i <= 260; i++) {
                
                SubFactorModel *subModel = [[SubFactorModel alloc] init];
                
                subModel.factor = [NSString stringWithFormat:@"%dcm",i];
                
                [model.subFactorArray addObject:subModel];
            }
            
            [dataArray addObject:model];
            
        } else if (i == 1) {
            
            GetFactorModel *model = [[GetFactorModel alloc] init];
            
            model.factor = @"体重";
            
            model.level = @"1";
            
            model.subFactorArray = [[NSMutableArray alloc] init];
            
            model.userSubFactorModel = [[SubFactorModel alloc] init];
            
            for (int i = 1; i <= 500; i++) {
                
                SubFactorModel *subModel = [[SubFactorModel alloc] init];
                
                subModel.factor = [NSString stringWithFormat:@"%dkg",i];
                
                [model.subFactorArray addObject:subModel];
            }
            
            [dataArray addObject:model];
            
        } else if (i == 2) {
            
            GetFactorModel *model = [[GetFactorModel alloc] init];
            
            model.factor = @"平均每日被动吸烟支数";
            
            model.level = @"1";
            
            model.userSubFactorModel = [[SubFactorModel alloc] init];
            
            model.subFactorArray = [[NSMutableArray alloc] init];
            
            for (int i = 1; i <= 101; i++) {
                
                if (i == 101) {
                    
                    SubFactorModel *subModel = [[SubFactorModel alloc] init];
                    
                    subModel.factor = @"100根以上";
                    
                    [model.subFactorArray addObject:subModel];
                    
                } else {
                    
                    SubFactorModel *subModel = [[SubFactorModel alloc] init];
                    
                    subModel.factor = [NSString stringWithFormat:@"%d根",i];
                    
                    [model.subFactorArray addObject:subModel];
                }
            }
            
            [dataArray addObject:model];
            
        } else if (i == 3) {
            
            GetFactorModel *model = [[GetFactorModel alloc] init];
            
            model.factor = @"被动吸烟年数";
            
            model.level = @"1";
            
            model.subFactorArray = [[NSMutableArray alloc] init];
            
            model.userSubFactorModel = [[SubFactorModel alloc] init];
            
            for (int i = 1; i <= 100; i++) {
                
                SubFactorModel *subModel = [[SubFactorModel alloc] init];
                
                subModel.factor = [NSString stringWithFormat:@"%d年",i];
                
                [model.subFactorArray addObject:subModel];
                
                [dataArray addObject:model];
            }
        }
    }
    
    return dataArray;
}

@end

@implementation SubFactorModel

#pragma mark --- NSCoding的协议
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if ([self init]) {
        
        self.factorId = [aDecoder decodeObjectForKey:@"factorId"];
        
        self.factor = [aDecoder decodeObjectForKey:@"factor"];
        
        self.pid = [aDecoder decodeObjectForKey:@"pid"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.factorId forKey:@"factorId"];
    
    [aCoder encodeObject:self.factor forKey:@"factor"];
    
    [aCoder encodeObject:self.pid forKey:@"pid"];
}

@end