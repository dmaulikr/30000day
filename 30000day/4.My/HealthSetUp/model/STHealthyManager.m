//
//  STHealthyManager.m
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STHealthyManager.h"

@interface STHealthyManager ()

@property (nonatomic, strong) STDataHandler *dataHandler;

@end

@implementation STHealthyManager

+ (STHealthyManager *)shareManager {
    
    static STHealthyManager *manager;
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        manager = [[STHealthyManager alloc] init];
        
        manager.dataHandler = [[STDataHandler alloc] init];

    });
    
    return manager;
}

- (void)synchronizedHealthyDataFromServer {
    
    //获取所有的健康因子
    [self.dataHandler sendGetFactors:^(NSMutableArray *dataArray) {
        
        [self encodeDataObject:dataArray];
        
    } failure:^(STNetError *error) {
       
        //下载失败后继续下载
        [self synchronizedHealthyDataFromServer];
        
    }];
}

- (NSMutableArray *)healthyArray {

    if (!_healthyArray) {
        
       _healthyArray = [self decodeObject];
    }
    
    return  _healthyArray;
}

@end
