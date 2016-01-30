//
//  totalLifeDay.m
//  30000天
//
//  Created by wei on 16/1/6.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "totalLifeDay.h"

static totalLifeDay *instance;

@implementation totalLifeDay

+(totalLifeDay *)shareControl
{
    @synchronized(self){
        if (!instance) {
            instance=[[totalLifeDay alloc]init];
        }
    }
    return instance;
}

@end
