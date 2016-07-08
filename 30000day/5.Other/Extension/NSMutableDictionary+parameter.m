//
//  NSMutableDictionary+parameter.m
//  30000day
//
//  Created by GuoJia on 16/5/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NSMutableDictionary+parameter.h"

@implementation NSMutableDictionary (parameter)

- (void)addParameter:(id)param forKey:(NSString *)key {
    
    if (param) {
        
        [self setObject:param forKey:key];
    }
}

@end
