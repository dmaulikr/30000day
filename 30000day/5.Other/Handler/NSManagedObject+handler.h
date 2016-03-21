//
//  NSManagedObject+handler.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "STCoreDataHandler.h"

typedef void(^ListResult)(NSArray* result, NSError *error);

typedef void(^ObjectResult)(id result, NSError *error);

typedef id(^AsyncProcess)(NSManagedObjectContext *ctx, NSString *className);

@interface NSManagedObject (handler)

+ (id)createNew;

+ (NSError *)save:(OperationResult)handler;

+ (NSArray *)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit;

+ (void)filter:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler;

+ (id)one:(NSString *)predicate;

+ (void)one:(NSString*)predicate on:(ObjectResult)handler;

+ (void)delobject:(id)object;

+ (void)async:(AsyncProcess)processBlock result:(ListResult)resultBlock;

@end
