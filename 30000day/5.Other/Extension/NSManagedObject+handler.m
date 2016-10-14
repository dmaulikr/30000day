//
//  NSManagedObject+handler.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NSManagedObject+handler.h"

@implementation NSManagedObject (handler)

+ (id)createObjectWithMainContext:(NSManagedObjectContext *)mainContext {
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    return [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:mainContext];
}

+ (NSArray *)filterWithContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit {
    
    NSFetchRequest *fetchRequest = [self makeRequest:context predicate:predicate orderby:orders offset:offset limit:limit];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"error: %@", error);
        return @[];
    }
    
    return results;
}

+ (NSArray *)_filterWithContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit {
    NSFetchRequest *fetchRequest = [self _makeRequest:context predicate:predicate orderby:orders offset:offset limit:limit];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return @[];
    }
    return results;
}

+ (NSFetchRequest *)_makeRequest:(NSManagedObjectContext *)ctx predicate:(NSPredicate *)predicate orderby:(NSArray *)sortArray offset:(int)offset limit:(int)limit {
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:ctx]];
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    if (sortArray) {
        [fetchRequest setSortDescriptors:sortArray];
    }
    if ( offset >= 0 ) {
        [fetchRequest setFetchOffset:offset];
    }
    if (limit > 0) {
        [fetchRequest setFetchLimit:limit];
    }
    return fetchRequest;
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

+ (void)filterWithMainContext:(NSManagedObjectContext *)mainContext withPrivateContext:(NSManagedObjectContext *)privateContext predicate:(NSPredicate *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit on:(ListResult)handler {
    
    [privateContext performBlock:^{
        
        NSFetchRequest *fetchRequest = [self makeRequest:privateContext predicate:predicate orderby:orders offset:offset limit:limit];
        NSError *error = nil;
        NSArray *results = [privateContext executeFetchRequest:fetchRequest error:&error];
        
        if (error) {
            
            NSLog(@"error: %@", error);
            [mainContext performBlock:^{
                handler(@[], nil);
            }];
        }
        
        if ([results count] < 1) {
            
            [mainContext performBlock:^{
                handler(@[], nil);
            }];
        }
        
        NSMutableArray *result_ids = [[NSMutableArray alloc] init];
        for (NSManagedObject *item  in results) {
            [result_ids addObject:item.objectID];
        }
        
        [mainContext performBlock:^{
            
            NSMutableArray *final_results = [[NSMutableArray alloc] init];
            for (NSManagedObjectID *oid in result_ids) {
                [final_results addObject:[mainContext objectWithID:oid]];
            }
        }];
    }];
}


//+ (id)one:(NSPredicate *)predicate {
//    
//    NSManagedObjectContext *ctx = [STCoreDataHandler shareCoreDataHandler].mainObjectContext;
//    
//    NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
//    
//    NSError* error = nil;
//    
//    NSArray* results = [ctx executeFetchRequest:fetchRequest error:&error];
//    
//    if ([results count]!= 1) {
//        
//        raise(1);
//    }
//    
//    return results[0];
//}
//
//+ (void)one:(NSPredicate *)predicate on:(ObjectResult)handler {
//    
//    NSManagedObjectContext *ctx = [[STCoreDataHandler shareCoreDataHandler] createPrivateObjectContext];
//    
//    [ctx performBlock:^{
//        
//        NSFetchRequest *fetchRequest = [self makeRequest:ctx predicate:predicate orderby:nil offset:0 limit:1];
//        
//        NSError *error = nil;
//        
//        NSArray *results = [ctx executeFetchRequest:fetchRequest error:&error];
//        
//        if (error) {
//            
//            NSLog(@"error: %@", error);
//            
//            [[STCoreDataHandler shareCoreDataHandler].mainObjectContext performBlock:^{
//                
//                handler(@[], nil);
//                
//            }];
//        }
//        
//        if ([results count] < 1) {
//            
//            [[STCoreDataHandler shareCoreDataHandler].mainObjectContext performBlock:^{
//                handler(@[], nil);
//            }];
//        }
//        
//        NSManagedObjectID *objId = ((NSManagedObject *)results[0]).objectID;
//        
//        [[STCoreDataHandler shareCoreDataHandler].mainObjectContext performBlock:^{
//            
//            handler([[STCoreDataHandler shareCoreDataHandler].mainObjectContext objectWithID:objId], nil);
//        }];
//    }];
//}


+ (void)deleteObjectWithMainContext:(NSManagedObjectContext *)mainContext object:(id)object {
    
    [mainContext deleteObject:object];
}

//+ (void)async:(AsyncProcess)processBlock result:(ListResult)resultBlock {
//    
//    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
//    
//    NSManagedObjectContext *ctx = [[STCoreDataHandler shareCoreDataHandler] createPrivateObjectContext];
//    
//    [ctx performBlock:^{
//        
//        id resultList = processBlock(ctx, className);
//        
//        if (resultList) {
//            
//            if ([resultList isKindOfClass:[NSError class]]) {
//                
//                [[STCoreDataHandler shareCoreDataHandler].mainObjectContext performBlock:^{
//                    
//                    resultBlock(nil, resultList);
//                    
//                }];
//            }
//            
//            if ([resultList isKindOfClass:[NSArray class]]) {
//                
//                NSMutableArray *idArray = [[NSMutableArray alloc] init];
//                
//                for (NSManagedObject *obj in resultList) {
//                    
//                    [idArray addObject:obj.objectID];
//                }
//                
//                NSArray *objectIdArray = [idArray copy];
//                
//                [[STCoreDataHandler shareCoreDataHandler].mainObjectContext performBlock:^{
//                    
//                    NSMutableArray *objArray = [[NSMutableArray alloc] init];
//                    
//                    for (NSManagedObjectID *robjId in objectIdArray) {
//                        
//                        [objArray addObject:[[STCoreDataHandler shareCoreDataHandler].mainObjectContext objectWithID:robjId]];
//                    }
//                    
//                    if (resultBlock) {
//                        
//                        resultBlock([objArray copy], nil);
//                    }
//                }];
//            }
//            
//        } else {
//            
//            resultBlock(nil, nil);
//        }
//    }];
//}

@end
