//
//  SearchTableVersion.m
//  30000day
//
//  Created by wei on 16/3/30.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SearchTableVersion.h"

@implementation SearchTableVersion

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.searchTableVersionId = value;
    }
}


@end
