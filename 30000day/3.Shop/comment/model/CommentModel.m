//
//  CommentModel.m
//  30000day
//
//  Created by wei on 16/3/22.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    if ([key isEqualToString:@"id"]) {
        
        self.commentId = value;
    }
}

@end
