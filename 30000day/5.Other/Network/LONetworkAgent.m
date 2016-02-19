//
//  LONetworkAgent.m
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/11.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LONetworkAgent.h"
#import "LONetworkCache.h"
#import "LORequest.h"

@implementation LONetworkAgent {
    
    AFHTTPRequestOperationManager *_manager;
    
    NSMutableDictionary *_requestsRecord;
}

+ (LONetworkAgent *)sharedAgent {
    
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

- (LONetworkReachabilityStatus)networkReachabilityStatus {
    
    LONetworkReachabilityStatus status = LONetworkReachabilityStatusUnknown;
    
    switch ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus]) {
            
        case AFNetworkReachabilityStatusNotReachable:
            
            status = LONetworkReachabilityStatusNotReachable;
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            
            status = LONetworkReachabilityStatus3G;
            
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            
            status = LONetworkReachabilityStatusWiFi;
            
            break;
            
        default:
            
            break;
    }
    
    return status;
}


#pragma mark -
#pragma mark Request Handler

- (NSString *)addRequest:(LORequest *)request {
    
    if (request.requestSerializerType == LORequestSerializerTypeHTTP) {
        
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
    } else if (request.requestSerializerType == LORequestSerializerTypeJSON) {
        
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
    }
    
    if (request.responseSerializerType == LOResponseTypeImage) {
        
        _manager.responseSerializer = [AFImageResponseSerializer serializer];
        
    } else if (request.responseSerializerType == LOResponseTypeJSON) {
        
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
            
        case LORequestMethodGet:
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
            
        case LORequestMethodPost:
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
        case LORequestMethodHead:
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
        case LORequestMethodPut:
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
        case LORequestMethodDelete:
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
        case LORequestMethodPatch:
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
        
        LORequest *request = copyRecord[key];
        
        request.delegate = nil;
        
        [request.operation cancel];
        
        [self removeRequestRecord:request];
    }
}


#pragma mark -
#pragma mark Private Method

- (NSString *)buildRequestUrl:(LORequest *)request {
    
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

- (id)buildRequestParam:(LORequest *)request {
    
    id param = request.parameters;
    
    if ([param isKindOfClass:[NSDictionary class]] && [request needParameterFilter]) {
        
        param = [[NSMutableDictionary alloc] initWithDictionary:param];
        
        [param addEntriesFromDictionary:_urlFilters];
    }
    
    return param;
}

- (void)buildRequestHeader:(LORequest *)request {
    
    if (request.needHeaderAuthorization) { //&& [LOSession sharedSession].accessToken) {
//        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [LOSession sharedSession].accessToken] forHTTPHeaderField:@"Authorization"];
//        [_manager.requestSerializer setValue:CLIENT_SECRET forHTTPHeaderField:@"Lianjia-App-Secret"];
//        [_manager.requestSerializer setValue:CLIENT_ID forHTTPHeaderField:@"Lianjia-App-Id"];
//        [_manager.requestSerializer setValue:[LOSession sharedSession].UDID forHTTPHeaderField:@"Lianjia-Device-Id"];
//        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [LOSession sharedSession].accessToken] forHTTPHeaderField:@"Authorization"];
    }
    
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
    LORequest *request = [_requestsRecord objectForKey:key];
    if (request && request.successCompletionBlock) {
        [request startRequestCacheWithResponseObject:responseObject];
        request.successCompletionBlock(responseObject);
    }
    [self removeRequestRecord:request];
}


- (void)handleRequestFailureResult:(AFHTTPRequestOperation *)operation netError:(NSError *)error{
    NSString *key = [self requestHashKey:operation];
    LORequest *request = [_requestsRecord objectForKey:key];
    [self removeRequestRecord:request];
    if (request.retryMaximumTimes > 0) {
        [self delayNetworkFailureRetryWithRequest:request];
    } else {
        if (request && request.failureCompletionBlock) {
            LONetError *netError = [LONetError errorWithAFHTTPRequestOperation:operation NSError:error];
            if (request.cacheSwitch) {
                netError.responseJSONObject = [[LONetworkCache globalCache] objectForKey:[request cacheKey]];
            }
            request.failureCompletionBlock(netError);
        }
    }
}

- (void)delayNetworkFailureRetryWithRequest:(LORequest *)request {
    
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

- (void)addRequestRecord:(LORequest *)request {
    if (request.operation != nil) {
        NSString *key = [self requestHashKey:request.operation];
        @synchronized(self) {
            _requestsRecord[key] = request;
        }
    }
}

- (void)removeRequestRecord:(LORequest *)request {
    NSString *key = [self requestHashKey:request.operation];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
}

- (void)cancelRequestWithHash:(NSString *)requestHash {
    @synchronized(self) {
        LORequest *request = [_requestsRecord objectForKey:requestHash];
        request.delegate = nil;
        [request.operation cancel];
        
        [self removeRequestRecord:request];
    }
}

@end

