//
//  LOApiRequest.m
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/11.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LOApiRequest.h"

@implementation LOApiRequest

+ (LOApiRequest *)requestWithMethod:(LORequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(LONetError *error))failure
{
    return [self requestWithMethod:requestMethod
                               url:requesturl
                        parameters:parameters
             constructingBodyBlock:nil
                          progress:nil
                           success:success
                           failure:failure];
}

+ (LOApiRequest *)requestWithMethod:(LORequestMethod)requestMethod
                                url:(NSString *)requesturl
                         parameters:(id)parameters
              constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
                           progress:(LORequestProgressBlock)progress
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(LONetError *error))failure
{
    LOApiRequest *request = [[LOApiRequest alloc] init];
    
    //设置 baseurl
    request.baseUrl = LO_API_SERVER;
    
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
