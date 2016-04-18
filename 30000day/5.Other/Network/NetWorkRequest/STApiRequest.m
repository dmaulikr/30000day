//
//  STApiRequest.m
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STApiRequest.h"

@implementation STApiRequest

+ (STApiRequest *)requestWithMethod:(STRequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(STNetError *error))failure {
    return [self requestWithMethod:requestMethod
                               url:requesturl
                        parameters:parameters
             constructingBodyBlock:nil
                          progress:nil
                           success:success
                           failure:failure];
}

+ (STApiRequest *)requestWithMethod:(STRequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
              constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
                           progress:(LORequestProgressBlock)progress
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(STNetError *error))failure {
    
    STApiRequest *request = [[STApiRequest alloc] init];
    
    //设置 baseurl
    request.baseUrl = ST_API_SERVER;
    
    request.requestMethod = requestMethod;
    
    request.requestUrl = requesturl;
    
    request.parameters = parameters;
    
    request.constructingBodyBlock = constructingBodyBlock;
    
    request.progressBlock = progress;
    
    request.successCompletionBlock = success;
    
    request.failureCompletionBlock = failure;
    
    return request;
}

@end
