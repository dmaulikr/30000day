//
//  ProductTypeModel.m
//  30000day
//
//  Created by wei on 16/3/31.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ProductTypeModel.h"

@implementation ProductTypeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.productTypeId = value;
        
    }
    
}

@end
