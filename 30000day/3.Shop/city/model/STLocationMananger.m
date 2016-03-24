//
//  STLocationMananger.m
//  30000day
//
//  Created by GuoJia on 16/3/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  写入文件的本地缓存

#import "STLocationMananger.h"

@implementation STLocationMananger

+ (STLocationMananger *)shareManager {
    
    static STLocationMananger *manager;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
       
        manager = [[STLocationMananger alloc] init];
        
    });
    
    return manager;
}


- (void)cacheDataWithLocationModel:(LocationModel *)model {
    
    
    
    
    
}



@end
