//
//  ProblemTypesModel.m
//  30000day
//
//  Created by wei on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ProblemTypesModel.h"

@implementation ProblemTypesModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"description"]) {
        
        self.problemTypesDescription = value;
    }
    
    if ([key isEqualToString:@"id"]) {
        
        self.problemTypesID = value;
    }
}

@end
