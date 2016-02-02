//
//  security.m
//  30000天
//
//  Created by wei on 16/1/18.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "security.h"

static security *instance;

@implementation security

+(security *)shareControl
{
    @synchronized(self){
        if (!instance) {
            instance=[[security alloc]init];
        }
    }
    return instance;
}
@end
