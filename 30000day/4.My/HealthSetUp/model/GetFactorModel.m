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
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        
        if (i == 0) {
            
            GetFactorModel *model = [[GetFactorModel alloc] init];
            
            model.factor = @"身高(单位cm)";
            
            model.level = @"1";
            
            model.subFactorArray = [[NSMutableArray alloc] init];
            
            model.userSubFactorModel = [[SubFactorModel alloc] init];
            
            for (int i = 1; i <= 260; i++) {
                
                SubFactorModel *subModel = [[SubFactorModel alloc] init];
                
                subModel.factor = [NSString stringWithFormat:@"%d",i];
                
                [model.subFactorArray addObject:subModel];
            }
            
            [dataArray addObject:model];
            
        } else if (i == 1) {
            
            GetFactorModel *model = [[GetFactorModel alloc] init];
            
            model.factor = @"体重(单位kg)";
            
            model.level = @"1";
            
            model.subFactorArray = [[NSMutableArray alloc] init];
            
            model.userSubFactorModel = [[SubFactorModel alloc] init];
            
            for (int i = 1; i <= 500; i++) {
                
                SubFactorModel *subModel = [[SubFactorModel alloc] init];
                
                subModel.factor = [NSString stringWithFormat:@"%d",i];
                
                [model.subFactorArray addObject:subModel];
            }
            
            [dataArray addObject:model];
            
        } else if (i == 2) {
            
            GetFactorModel *model = [[GetFactorModel alloc] init];
            
            model.factor = @"平均每日被动吸烟支数";
            
            model.level = @"1";
            
            model.userSubFactorModel = [[SubFactorModel alloc] init];
            
            model.subFactorArray = [[NSMutableArray alloc] init];
            
            for (int i = 0; i <= 101; i++) {
                
                if (i == 101) {
                    
                    SubFactorModel *subModel = [[SubFactorModel alloc] init];
                    
                    subModel.factor = @"100以上";
                    
                    [model.subFactorArray addObject:subModel];
                    
                } else {
                    
                    SubFactorModel *subModel = [[SubFactorModel alloc] init];
                    
                    subModel.factor = [NSString stringWithFormat:@"%d",i];
                    
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
            
            for (int i = 0; i <= 100; i++) {
                
                SubFactorModel *subModel = [[SubFactorModel alloc] init];
                
                subModel.factor = [NSString stringWithFormat:@"%d",i];
                
                [model.subFactorArray addObject:subModel];
            }
            
            [dataArray addObject:model];
        }
    }
    
    return dataArray;
}

@end

@implementation SubFactorModel

@end