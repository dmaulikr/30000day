//
//  ShopDetailModel.m
//  30000day
//
//  Created by wei on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailModel.h"

@implementation ShopDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"id"]) {
    
        self.shopDetailId = value;
        
    }
    
}

@end
