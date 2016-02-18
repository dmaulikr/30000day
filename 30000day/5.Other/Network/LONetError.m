//
//  LONetError.m
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LONetError.h"

@implementation LONetError

+ (LONetError *)errorWithAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation NSError:(NSError *)error {
    
    LONetError *netError = [LONetError new];
    
    netError.error = error;
    
    netError.lostConnection = (error.code == NSURLErrorNotConnectedToInternet);
    
    netError.operationCancelled = (error.code == NSURLErrorCancelled);
    
    netError.operation = operation;
    
    netError.statusCode = operation.response.statusCode;
    
//    netError.messageStatusCode = [[operation.responseObject objectForKey:@"statusCode"] intValue];
//    
//    netError.messageContent = [operation.responseObject objectForKey:@"message"];
    
    return netError;
}

@end
