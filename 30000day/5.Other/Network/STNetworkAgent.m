//
//  STNetworkAgent.m
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STNetworkAgent.h"
#import "STNetworkCache.h"
#import "STRequest.h"

@implementation STNetworkAgent {
    
    AFHTTPRequestOperationManager *_manager;
    
    NSMutableDictionary *_requestsRecord;
}

+ (STNetworkAgent *)sharedAgent {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _manager = [AFHTTPRequestOperationManager manager];
        
        _manager.operationQueue.maxConcurrentOperationCount = 4;
        
        _urlFilters = [[NSMutableDictionary alloc] init];
        
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark -
#pragma mark Reachability

- (BOOL)isReachable {
    
    return [[AFNetworkReachabilityManager sharedManager] isReachable];
    
}

- (STNetworkReachabilityStatus)networkReachabilityStatus {
    
    STNetworkReachabilityStatus status = STNetworkReachabilityStatusUnknown;
    
    switch ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]) {
            
        case AFNetworkReachabilityStatusNotReachable:
            
            status = STNetworkReachabilityStatusNotReachable;
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            
            status = STNetworkReachabilityStatus3G;
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            
            status = STNetworkReachabilityStatusWiFi;
            
            break;
            
        default:
            
            break;
    }
    
    return status;
}


#pragma mark -
#pragma mark Request Handler

- (NSString *)addRequest:(STRequest *)request {
    
    if (request.requestSerializerType == STRequestSerializerTypeHTTP) {
        
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    } else if (request.requestSerializerType == STRequestSerializerTypeJSON) {
        
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
    }
    
    if (request.responseSerializerType == STResponseTypeImage) {
        
        _manager.responseSerializer = [AFImageResponseSerializer serializer];
        
    } else if (request.responseSerializerType == STResponseTypeJSON) {
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    else {
        
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
    }
    
    _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
    
    [self buildRequestHeader:request];
    
    NSString *url = [self buildRequestUrl:request];
    
    id param = [self buildRequestParam:request];
    
    __weak typeof (self) weakSelf = self;
    
    __weak typeof (request) weakRequest = request;
    
    switch ([request requestMethod]) {
            
        case STRequestMethodGet:
        {
            request.operation = [_manager GET:url
                                   parameters:param
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          [weakSelf handleRequestSuccessResult:operation responseObject:responseObject];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [weakSelf handleRequestFailureResult:operation netError:error];
                                      }
                                 ];
        }
            break;
            
        case STRequestMethodPost:
        {
            AFConstructingBlock constructingBlock = [request constructingBodyBlock];
            
            if (constructingBlock != nil) {
                
                request.operation = [_manager POST:url
                                        parameters:param
                         constructingBodyWithBlock:constructingBlock
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               [weakSelf handleRequestSuccessResult:operation responseObject:responseObject];
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               [weakSelf handleRequestFailureResult:operation netError:error];
                                           }
                                     ];
                
                [request.operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                    
                    weakRequest.progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
                    
                }];
                
            } else {
                
                request.operation = [_manager POST:url
                                        parameters:param
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               [weakSelf handleRequestSuccessResult:operation responseObject:responseObject];
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               [weakSelf handleRequestFailureResult:operation netError:error];
                                           }
                                     ];
            }
        }
            break;
        case STRequestMethodHead:
        {
            request.operation = [_manager HEAD:url
                                    parameters:param
                                       success:^(AFHTTPRequestOperation *operation) {
                                           [weakSelf handleRequestSuccessResult:operation responseObject:nil];
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [weakSelf handleRequestFailureResult:operation netError:error];
                                       }
                                 ];
        }
            break;
        case STRequestMethodPut:
        {
            request.operation = [_manager PUT:url
                                   parameters:param
                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          [weakSelf handleRequestSuccessResult:operation responseObject:responseObject];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [weakSelf handleRequestFailureResult:operation netError:error];
                                      }
                                 ];
        }
            break;
        case STRequestMethodDelete:
        {
            request.operation = [_manager DELETE:url
                                      parameters:param
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             [weakSelf handleRequestSuccessResult:operation responseObject:responseObject];
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             [weakSelf handleRequestFailureResult:operation netError:error];
                                         }
                                 ];
        }
            break;
        case STRequestMethodPatch:
        {
            request.operation = [_manager PATCH:url
                                     parameters:param
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                            [weakSelf handleRequestSuccessResult:operation responseObject:responseObject];
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                            [weakSelf handleRequestFailureResult:operation netError:error];
                                        }
                                 ];
        }
            break;
        default:
            NSLog(@"Error, unsupport method type");
            break;
    }
    
    
    [self addRequestRecord:request];
    
    return [self requestHashKey:request.operation];
}


- (void)cancelRequestsWithHashArray:(NSArray *)requestHashArray {
    
    for (NSString *hash in requestHashArray) {
        
        [self cancelRequestWithHash:hash];
    }
}

- (void)cancelAllRequests {
    
    NSDictionary *copyRecord = [_requestsRecord copy];
    
    for (NSString *key in copyRecord) {
        
        STRequest *request = copyRecord[key];
        
        request.delegate = nil;
        
        [request.operation cancel];
        
        [self removeRequestRecord:request];
    }
}


#pragma mark -
#pragma mark Private Method

- (NSString *)buildRequestUrl:(STRequest *)request {
    
    NSString *detailUrl = [request requestUrl];
    
    if ([detailUrl hasPrefix:@"http"]) {
        
        return detailUrl;
    }
    
    NSString *baseUrl;
    
    if ([request baseUrl].length > 0) {
        
        baseUrl = [request baseUrl];
        
    } else {
        
        baseUrl = nil;
    }
    
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (id)buildRequestParam:(STRequest *)request {
    
    id param = request.parameters;
    
    if ([param isKindOfClass:[NSDictionary class]] && [request needParameterFilter]) {
        
        param = [[NSMutableDictionary alloc] initWithDictionary:param];
        
        [param addEntriesFromDictionary:_urlFilters];
    }
    
    return param;
}

- (void)buildRequestHeader:(STRequest *)request {
    
    //    if (request.needHeaderAuthorization) { //&& [LOSession sharedSession].accessToken) {
    //        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [LOSession sharedSession].accessToken] forHTTPHeaderField:@"Authorization"];
    //        [_manager.requestSerializer setValue:CLIENT_SECRET forHTTPHeaderField:@"Lianjia-App-Secret"];
    //        [_manager.requestSerializer setValue:CLIENT_ID forHTTPHeaderField:@"Lianjia-App-Id"];
    //        [_manager.requestSerializer setValue:[LOSession sharedSession].UDID forHTTPHeaderField:@"Lianjia-Device-Id"];
    //        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [LOSession sharedSession].accessToken] forHTTPHeaderField:@"Authorization"];
    //    }
    
    //    if ([LOSession sharedSession].currentUser) {
    //        [_manager.requestSerializer setValue:[LOSession sharedSession].currentUser.access_token forHTTPHeaderField:@"Lianjia-Access-Token"];
    //        //[_manager.requestSerializer setValue:[LOSession sharedSession].currentUser.access_timestamp forHTTPHeaderField:@"Lianjia-Timestamp"];
    //    }
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    
    if (headerFieldValueDictionary != nil) {
        
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            
            id value = headerFieldValueDictionary[httpHeaderField];
            
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
                
            } else {
                
                NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
}

- (void)handleRequestSuccessResult:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject {
    
    NSString *key = [self requestHashKey:operation];
    
    STRequest *request = [_requestsRecord objectForKey:key];
    
    if (request && request.successCompletionBlock) {
        
        [request startRequestCacheWithResponseObject:responseObject];
        
        request.successCompletionBlock(responseObject);
    }
    
    [self removeRequestRecord:request];
}


- (void)handleRequestFailureResult:(AFHTTPRequestOperation *)operation netError:(NSError *)error {
    
    NSString *key = [self requestHashKey:operation];
    
    STRequest *request = [_requestsRecord objectForKey:key];
    
    [self removeRequestRecord:request];
    
    if (request.retryMaximumTimes > 0) {
        
        [self delayNetworkFailureRetryWithRequest:request];
        
    } else {
        
        if (request && request.failureCompletionBlock) {
            
            STNetError *netError = [STNetError errorWithAFHTTPRequestOperation:operation NSError:error];
            
            if (request.cacheSwitch) {
                
                netError.responseJSONObject = [[STNetworkCache globalCache] objectForKey:[request cacheKey]];
            }
            
            request.failureCompletionBlock(netError);
        }
    }
}

//延迟重新请求数据
- (void)delayNetworkFailureRetryWithRequest:(STRequest *)request {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(request.retryIntervalInSeconds * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        
        request.retryMaximumTimes --;
        
        [self addRequest:request];
        
    });
}

- (NSString *)requestHashKey:(AFHTTPRequestOperation *)operation {
    
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    
    return key;
}

- (void)addRequestRecord:(STRequest *)request {
    
    if (request.operation != nil) {
        
        NSString *key = [self requestHashKey:request.operation];
        
        @synchronized(self) {
            
            _requestsRecord[key] = request;
            
        }
    }
}

- (void)removeRequestRecord:(STRequest *)request {
    
    NSString *key = [self requestHashKey:request.operation];
    
    @synchronized(self) {
        
        [_requestsRecord removeObjectForKey:key];
    }
}

- (void)cancelRequestWithHash:(NSString *)requestHash {
    
    @synchronized(self) {
        
        STRequest *request = [_requestsRecord objectForKey:requestHash];
        
        request.delegate = nil;
        
        [request.operation cancel];
        
        [self removeRequestRecord:request];
    }
}

@end
