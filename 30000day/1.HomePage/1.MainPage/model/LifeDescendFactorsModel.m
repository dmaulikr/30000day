//
//  LifeDescendFactorsModel.m
//  30000day
//
//  Created by wei on 16/5/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "LifeDescendFactorsModel.h"

@implementation LifeDescendFactorsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.lifeId =(NSInteger)value;
    }
}


@end
