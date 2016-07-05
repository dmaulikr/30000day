//
//  CDMediaMessageManager.h
//  30000day
//
//  Created by GuoJia on 16/7/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OperationResult)(NSError *error);
@interface CDMediaMessageManager : NSObject

@property (readonly, strong, nonatomic) NSOperationQueue *queue;
@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

+ (CDMediaMessageManager *)shareCoreDataHandler;
- (NSError *)save:(OperationResult)handler;
- (NSManagedObjectContext *)createPrivateObjectContext;

@end
