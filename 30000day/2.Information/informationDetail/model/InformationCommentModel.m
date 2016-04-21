//
//  InformationCommentModel.m
//  30000day
//
//  Created by wei on 16/4/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationCommentModel.h"

@implementation InformationCommentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.commentId = value;
    }
}

- (id)init {
    
    if (self = [super init]) {

        self.selected = NO;
    }
    return self;
}

@end
