//
//  UpdateLogPwd.m
//  30000天
//
//  Created by wei on 15/9/22.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "UpdateLogPwd.h"

static UpdateLogPwd *class = nil;

@implementation UpdateLogPwd

+ (UpdateLogPwd *)sharedLogPwd {
    
    @synchronized(self) {
        
        if (!class) {
            
            class = [[UpdateLogPwd alloc] init];
        }
        
        return class;
    }
    
}

@end
