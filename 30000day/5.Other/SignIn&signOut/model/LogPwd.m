//
//  LogPwd.m
//  30000天
//
//  Created by wei on 15/9/17.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import "LogPwd.h"

static LogPwd* class=nil;
@implementation LogPwd
+(LogPwd*)sharedLogPwd{
    @synchronized(self){
        if (!class) {
            class=[[LogPwd alloc]init];
        }
        return class;
    }
    
}
@end
