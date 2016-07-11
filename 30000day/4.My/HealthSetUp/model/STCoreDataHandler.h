//
//  STCoreDataHandler.h
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OperationResult)(NSError *error);

@interface STCoreDataHandler : NSObject

@property (readonly, strong, nonatomic) NSOperationQueue *queue;

@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;

+ (STCoreDataHandler *)shareCoreDataHandler;

- (void)configModel:(NSString *)model DbFile:(NSString *)filename;

- (NSManagedObjectContext *)createPrivateObjectContext;

- (NSError *)save:(OperationResult)handler;

//获取所有的健康因子,并同步到服务器
- (void)synchronizedHealthyDataFromServer:(void (^)(BOOL isSuccess))isSuccess;

@end
