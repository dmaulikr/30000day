//
//  STNetError.h
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface STNetError : NSObject

@property (nonatomic, strong) id responseJSONObject;

@property (nonatomic, assign) BOOL lostConnection;

@property (nonatomic, assign) BOOL operationCancelled;

@property (nonatomic, assign) NSInteger statusCode;

/**** 内部状态码 ****/
@property (nonatomic, assign) NSInteger messageStatusCode;

@property (nonatomic, strong) NSString *messageContent;

@property (nonatomic, strong) AFHTTPRequestOperation *operation;

@property (nonatomic, strong) NSError *error;

+ (STNetError *)errorWithAFHTTPRequestOperation:(NSOperation *)operation NSError:(NSError *)error;

@end
