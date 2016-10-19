
//
//  InformationModel.m
//  30000day
//
//  Created by wei on 16/4/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.informationId = value;
    }
}

@end
