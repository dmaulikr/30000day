//
//  SubwayModel.m
//  30000day
//
//  Created by GuoJia on 16/3/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubwayModel.h"

@implementation SubwayModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.subWayId = value;
    }
}

@end

@implementation platformModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.platformId = value;
    }
}


@end