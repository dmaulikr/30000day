//
//  LORequest.m
//  30000day
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LORequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "STNetworkCache.h"

@implementation LORequest

#pragma mark - Basic Executative Methods

- (id)init {
    self = [super init];
    if (self) {
        _needParameterFilter = YES;
        _needHeaderAuthorization = YES;
        _requestTimeoutInterval = 10;
        _cacheSwitch = NO;
        _retryIntervalInSeconds = 5.0;
        _retryMaximumTimes = 0;
    }
    return self;
}

+ (LORequest *)requestWithMethod:(LORequestMethod)requestMethod
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

+ (LORequest *)requestWithMethod:(LORequestMethod)requestMethod
                             url:(NSString *)requesturl
                      parameters:(id)parameters
           constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
                        progress:(LORequestProgressBlock)progress
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(LONetError *error))failure
{
    LORequest *request = [[LORequest alloc] init];
    
    request.requestMethod = requestMethod;
    request.requestUrl = requesturl;
    request.parameters = parameters;
    request.constructingBodyBlock = constructingBodyBlock;
    request.progressBlock = progress;
    
    request.successCompletionBlock = success;
    request.failureCompletionBlock = failure;
    
    return request;
}

#pragma mark - Network Cache

- (void)startRequestCacheWithResponseObject:(id)responseObject {
    
    if (self.cacheSwitch) {
        
        [[STNetworkCache globalCache] setObject:responseObject forKey:[self cacheKey]];
        
    }
}

- (NSString *)cacheKey {
    
    NSMutableDictionary *parametersForCache = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary *)self.parameters];
    
    [parametersForCache removeObjectsForKeys:self.ignoredParametersForCache];
    
    NSString *requestInfo = [NSString stringWithFormat:@"Method:%ld Host:%@ Url:%@ Parameters:%@ AppVersion:%@",
                             (long)self.requestMethod, self.baseUrl, self.requestUrl, parametersForCache, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSString *cacheKeyStr = [self md5StringFromString:requestInfo];
    
    return cacheKeyStr;
}

#pragma mark - Utils

- (NSString *)md5StringFromString:(NSString *)string {
    
    if(string == nil || [string length] == 0)
        
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}


@end
