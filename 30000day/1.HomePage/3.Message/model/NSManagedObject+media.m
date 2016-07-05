//
//  NSManagedObject+media.m
//  30000day
//
//  Created by GuoJia on 16/7/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NSManagedObject+media.h"

@implementation NSManagedObject (media)

+ (id)createNewObject {
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[CDMediaMessageManager shareCoreDataHandler].mainObjectContext];
}

+ (NSError *)save:(OperationResult)handler {
    
    return [[CDMediaMessageManager shareCoreDataHandler] save:handler];
}

+ (NSArray *)filter:(NSPredicate *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit {
    
    NSManagedObjectContext *ctx = [CDMediaMessageManager shareCoreDataHandler].mainObjectContext;
    
    NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:orders offset:offset limit:limit];
    NSError *error = nil;
    NSArray *results = [ctx executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"error: %@", error);
        return @[];
    }
    
    return results;
}

+ (NSFetchRequest *)makeRequest:(NSManagedObjectContext *)ctx predicate:(NSPredicate *)predicate orderby:(NSArray *)sortArray offset:(int)offset limit:(int)limit {
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:ctx]];
    
    if (predicate) {
        
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortArray) {
        
        [fetchRequest setSortDescriptors:sortArray];
    }
    
    if ( offset > 0 ) {
        
        [fetchRequest setFetchOffset:offset];
    }
    
    if (limit > 0) {
        
        [fetchRequest setFetchLimit:limit];
    }
    
    return fetchRequest;
}

+ (void)filter:(NSPredicate *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler {
    
    NSManagedObjectContext *ctx = [[CDMediaMessageManager shareCoreDataHandler] createPrivateObjectContext];
    
    [ctx performBlock:^{
        
        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:orders offset:offset limit:limit];
        NSError *error = nil;
        NSArray *results = [ctx executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            
            NSLog(@"error: %@", error);
            [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
                
                handler(@[], nil);
            }];
        }
        
        if ([results count] < 1) {
            
            [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
                
                handler(@[], nil);
            }];
        }
        
        NSMutableArray *result_ids = [[NSMutableArray alloc] init];
        for (NSManagedObject *item  in results) {
            
            [result_ids addObject:item.objectID];
        }
        
        [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
            
            NSMutableArray *final_results = [[NSMutableArray alloc] init];
            for (NSManagedObjectID *oid in result_ids) {
                [final_results addObject:[[CDMediaMessageManager shareCoreDataHandler].mainObjectContext objectWithID:oid]];
            }
            handler(final_results, nil);
            
        }];
    }];
}


+ (id)one:(NSPredicate *)predicate {
    
    NSManagedObjectContext *ctx = [CDMediaMessageManager shareCoreDataHandler].mainObjectContext;
    NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
    NSError* error = nil;
    
    NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
    
    if ([results count]!= 1) {
        
        raise(1);
    }
    
    return results[0];
}

+ (void)one:(NSPredicate *)predicate on:(ObjectResult)handler {
    
    NSManagedObjectContext *ctx = [[CDMediaMessageManager shareCoreDataHandler] createPrivateObjectContext];
    
    [ctx performBlock:^{
        
        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
        NSError *error = nil;
        NSArray *results = [ctx executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            
            NSLog(@"error: %@", error);
            [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
                
                handler(@[], nil);
                
            }];
        }
        
        if ([results count] < 1) {
            
            [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
                handler(@[], nil);
            }];
        }
        
        NSManagedObjectID *objId = ((NSManagedObject *)results[0]).objectID;
        [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
            
            handler([[CDMediaMessageManager shareCoreDataHandler].mainObjectContext objectWithID:objId], nil);
        }];
    }];
}


+ (void)deleteObject:(id)object {
    
    [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext deleteObject:object];
}

+ (void)async:(AsyncProcess)processBlock result:(ListResult)resultBlock {
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSManagedObjectContext *ctx = [[CDMediaMessageManager shareCoreDataHandler] createPrivateObjectContext];
    
    [ctx performBlock:^{
        
        id resultList = processBlock(ctx, className);
        
        if (resultList) {
            
            if ([resultList isKindOfClass:[NSError class]]) {
                
                [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
                    
                    resultBlock(nil, resultList);
                    
                }];
            }
            
            if ([resultList isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *idArray = [[NSMutableArray alloc] init];
                for (NSManagedObject *obj in resultList) {
                    
                    [idArray addObject:obj.objectID];
                }
                
                NSArray *objectIdArray = [idArray copy];
                [[CDMediaMessageManager shareCoreDataHandler].mainObjectContext performBlock:^{
                    
                    NSMutableArray *objArray = [[NSMutableArray alloc] init];
                    for (NSManagedObjectID *robjId in objectIdArray) {
                        
                        [objArray addObject:[[CDMediaMessageManager shareCoreDataHandler].mainObjectContext objectWithID:robjId]];
                    }
                    
                    if (resultBlock) {
                        
                        resultBlock([objArray copy], nil);
                    }
                }];
            }
            
        } else {
            
            resultBlock(nil, nil);
        }
    }];
}

@end
