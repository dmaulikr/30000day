//
//  STMediumSiftCoreDataStorage.m
//  30000day
//
//  Created by GuoJia on 16/10/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumSiftCoreDataStorage.h"

static STMediumSiftCoreDataStorage *storage;

@implementation STMediumSiftCoreDataStorage

+ (STMediumSiftCoreDataStorage *)shareStorage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        storage = [[STMediumSiftCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
        
    });
    return storage;
}


@end
