//
//  STRequest.h
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "STNetError.h"

typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);
typedef void (^LORequestProgressBlock)(long long totalBytesWritten, long long totalBytesExpectedToWrite);


typedef NS_ENUM(NSInteger , STRequestMethod) {
    STRequestMethodGet = 0,
    STRequestMethodHead,
    STRequestMethodPost,
    STRequestMethodPut,
    STRequestMethodDelete,
    STRequestMethodPatch
};

typedef NS_ENUM(NSInteger , STRequestSerializerType) {
    STRequestSerializerTypeHTTP = 0,
    STRequestSerializerTypeJSON,
};

typedef NS_ENUM(NSInteger , STResponseSerializerType) {
    STResponseTypeHTTP = 0,
    STResponseTypeJSON,
    STResponseTypeXMLParser,
    STResponseTypePropertyList,
    STResponseTypeImage,
};

@class STRequest;

@protocol STRequestProtocal <NSObject>

- (void)requestFinished:(STRequest *)request;
- (void)requestFailed:(STRequest *)request;

@end

@interface STRequest : NSObject

// 公共信息
@property (nonatomic) NSInteger tag;
@property (nonatomic, strong) AFHTTPRequestOperation *operation;

// Http请求的方法
@property (nonatomic, assign) STRequestMethod requestMethod;

// 请求的SerializerType
@property (nonatomic, assign) STRequestSerializerType requestSerializerType;

// 返回的SerializerType
@property (nonatomic, assign) STResponseSerializerType responseSerializerType;

// 自定义的 BaseURL，不设置时交给 LONetworkAgent 的时候使用 Agent 的配置值
@property (nonatomic, strong) NSString *baseUrl;

// 请求的 URL 及参数，URL 为相对路径时自动加上 BaseURL，绝对路径时不加 BaseURL
@property (nonatomic, strong) NSString *requestUrl;

// 请求参数
@property (nonatomic, strong) id parameters;

// 忽略掉的请求参数
@property (nonatomic, strong) NSArray *ignoredParametersForCache;


// 非 LORequestSerializerTypeJSON 时，需要对 Parameter 统一 filter，默认值是 YES
@property (nonatomic, assign) BOOL needParameterFilter;

// 需要添加 Http HeadeAuthroization 验证头，默认值是 YES
@property (nonatomic, assign) BOOL needHeaderAuthorization;

// 是否是 OAuth 请求
@property (nonatomic, assign) BOOL isOAuth;

// 请求的连接超时时间，默认为 10 秒
@property (nonatomic, assign) NSTimeInterval requestTimeoutInterval;

// 请求重发之间的间隔时间，默认为 5 秒
@property (nonatomic, assign) double retryIntervalInSeconds;

// 请求重发的次数，默认为 0 次
@property (nonatomic, assign) int retryMaximumTimes;


// 在HTTP报头添加的自定义参数
@property (nonatomic, strong) NSDictionary *requestHeaderFieldValueDictionary;


// 用于 POST 请求构造表单
@property (atomic, copy) AFConstructingBlock constructingBodyBlock;

// 用户 POST 自定义 Body 数据类型
@property (nonatomic, strong) NSData *bodyData;

// 表单上传时的进度回调
@property (atomic, copy) LORequestProgressBlock progressBlock;


// 用于代理模式进行回调
@property (nonatomic, weak) id<STRequestProtocal> delegate;


// 用户 block 模式进行回调
@property (atomic, copy) void (^successCompletionBlock)(id responseObject);
@property (atomic, copy) void (^failureCompletionBlock)(STNetError *error);


// response object
@property (nonatomic, readonly) NSInteger responseStatusCode;
@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;
@property (nonatomic, strong, readonly) id responseJSONObject;


+ (STRequest *)requestWithMethod:(STRequestMethod)requestMethod
                             url:(NSString *)requesturl
                      parameters:(id)parameters
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(STNetError *error))failure;


+ (STRequest *)requestWithMethod:(STRequestMethod)requestMethod
                             url:(NSString *)requesturl
                      parameters:(id)parameters
           constructingBodyBlock:(AFConstructingBlock)constructingBodyBlock
                        progress:(LORequestProgressBlock)progress
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(STNetError *error))failure;

// 以下是 网络请求数据缓存 相关方法 / 属性

// 数据来源是否为cache
@property (nonatomic, assign) BOOL cacheSwitch;

// 获取当前请求对应的cache key
- (NSString *)cacheKey;

// 将返回数据缓存
- (void)startRequestCacheWithResponseObject:(id)responseObject;

@end

