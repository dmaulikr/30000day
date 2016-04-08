//
//  InformationDetailModel.m
//  30000day
//
//  Created by wei on 16/4/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationDetailModel.h"

@implementation InformationDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.InformationDetailId = value;
    }
}

@end
