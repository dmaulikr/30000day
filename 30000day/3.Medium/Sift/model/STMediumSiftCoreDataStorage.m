//
//  STMediumSiftCoreDataStorage.m
//  30000day
//
//  Created by GuoJia on 16/10/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STMediumSiftCoreDataStorage.h"
#import "STCoreDataStorageProtected.h"

static STMediumSiftCoreDataStorage *instance;

@implementation STMediumSiftCoreDataStorage

+ (STMediumSiftCoreDataStorage *)shareStorage {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[STMediumSiftCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
        
    });
    return instance;
}

- (void)commonInit {
    [super commonInit];
    
    // This method is invoked by all public init methods of the superclass
    //    autoRemovePreviousDatabaseFile = NO;
    //    autoRecreateDatabaseFile = YES;
}

- (void)dealloc {
#if !OS_OBJECT_USE_OBJC
    if (parentQueue)
        dispatch_release(parentQueue);
#endif
}

@end
