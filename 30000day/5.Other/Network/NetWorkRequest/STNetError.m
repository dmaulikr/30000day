//
//  STNetError.m
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STNetError.h"

@implementation STNetError

+ (STNetError *)errorWithAFHTTPRequestOperation:(AFHTTPRequestOperation *)operation NSError:(NSError *)error {
    
    STNetError *netError = [STNetError new];
    
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
