//
//  LODataHandler.m
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LODataHandler.h"
#import "LORequest.h"
#import "LOApiRequest.h"
#import "LONetworkAgent.h"
#import "STBaseViewController.h"

#ifdef TESTORG

static const NSString *client_id = @"4pNYCsh91eXjs3RefSpY5j";

static const NSString *client_secret = @"1vEPR1cZKoRyO2advV7yBD";

#elif defined TEST

static const NSString *client_id = @"2ERSJrrxJIjQRrJPnNKs9V";

static const NSString *client_secret = @"3s0G9oU54yH4ZEtUulKoZC";

#elif defined PRODUCT

static const NSString *client_id = @"3RtLsXq06WrEnsy2nBvEEU";

static const NSString *client_secret = @"7mepBXgu9BENP4tEuDevDs";

#endif

@interface NSMutableDictionary (Parameter)

- (void)addParameter:(id)param forKey:(NSString *)key;

@end

@implementation NSMutableDictionary (Parameter)

- (void)addParameter:(id)param forKey:(NSString *)key {
    
    if (param) {
        
        [self setObject:param forKey:key];
        
    }
}

@end

@implementation LODataHandler

- (id)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

// 开始一个请求，并将请求 Hash 值插入回 BaseViewController
- (NSString *)startRequest:(LORequest *)request {
    
    NSString *requestHash = [[LONetworkAgent sharedAgent] addRequest:request];
    
    if ([(STBaseViewController *)self.delegate respondsToSelector:@selector(requestRecord)]) {
        
        [[(STBaseViewController *)self.delegate requestRecord] addObject:requestHash];
        
    }
    
    return requestHash;
}

// 试图将错误交回给 BaseViewController 预处理
- (void)preHandleLONetError:(LONetError *)error failureBlock:(void (^)(LONetError *))failure {
    
    if ([(STBaseViewController *)self.delegate respondsToSelector:@selector(handleLONetError:)]) {
        
        [(STBaseViewController *)self.delegate handleLONetError:error];
    }
    
    if (failure) {
        
        failure(error);
        
    }
}

//- (NSString *)postLoginVerifyCode:(NSString *)code
//                      phoneNumber:(NSString *)phonenumber
//                      picCode:(NSString *)piccode
//                          success:(void (^)(id responseObject))success
//                          failure:(void (^)(LONetError *))failure {
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters addParameter:phonenumber forKey:@"mobile_phone_no"];
//    [parameters addParameter:piccode forKey:@"pic_verify_code"];
//    [parameters addParameter:code forKey:@"verify_code"];
//    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
//                                                        url:POST_LOGIN_VERIFYCODE
//                                                 parameters:parameters
//                                                    success:^(id responseObject) {
//                                                        
//                                                        success(responseObject);
//                                                        
//                                                    } failure:^(LONetError *error) {
//                                                        failure(error);
//                                                    }];
//    request.needHeaderAuthorization = YES;
//    request.requestSerializerType = LORequestSerializerTypeJSON;
//    return [self startRequest:request];
//}
//
//- (NSString *)postLoginWithPassword:(NSString *)password
//                        phoneNumber:(NSString *)phonenumber
//                            success:(void (^)(id responseObject))success
//                            failure:(void (^)(LONetError *))failure {
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters addParameter:phonenumber forKey:@"mobile_phone_no"];
//    [parameters addParameter:password forKey:@"password"];
//    
//    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
//                                                        url:LOGIN_WITH_PASSWORD
//                                                 parameters:parameters
//                                                    success:^(id responseObject) {
//                                                        
//                                                        success(responseObject);
//                                                        
//                                                    } failure:^(LONetError *error) {
//                                                        failure(error);
//                                                    }];
//    request.needHeaderAuthorization = YES;
//    request.requestSerializerType = LORequestSerializerTypeJSON;
//    return [self startRequest:request];
//
//}
//
//- (NSString *)postRegesiterWithPassword:(NSString *)password
//                            phoneNumber:(NSString *)phonenumber
//                                picCode:(NSString *)piccode
//                             verifyCode:(NSString *)verifycode
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(LONetError *))failure {
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters addParameter:phonenumber forKey:@"mobile_phone_no"];
//    [parameters addParameter:password forKey:@"password"];
//    [parameters addParameter:piccode forKey:@"pic_verify_code"];
//    [parameters addParameter:verifycode forKey:@"verify_code"];
//    
//    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
//                                                        url:REGESITER_PATH
//                                                 parameters:parameters
//                                                    success:^(id responseObject) {
//                                                        
//                                                        success(responseObject);
//                                                        
//                                                    } failure:^(LONetError *error) {
//                                                        failure(error);
//                                                    }];
//    request.needHeaderAuthorization = YES;
//    request.requestSerializerType = LORequestSerializerTypeJSON;
//    return [self startRequest:request];
//
//}
//
//- (NSString *)postChangePasswordWithPassword:(NSString *)newpassword
//                                 phoneNumber:(NSString *)phonenumber
//                                  verifyCode:(NSString *)verifycode
//                                     success:(void (^)(id responseObject))success
//                                     failure:(void (^)(LONetError *))failure {
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    [parameters addParameter:phonenumber forKey:@"mobile_phone_no"];
//    [parameters addParameter:newpassword forKey:@"new_password"];
//    [parameters addParameter:verifycode forKey:@"verify_code"];
//    
//    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
//                                                        url:CHANGE_PASSWORD_PATH
//                                                 parameters:parameters
//                                                    success:^(id responseObject) {
//                                                        
//                                                        success(responseObject);
//                                                        
//                                                    } failure:^(LONetError *error) {
//                                                        failure(error);
//                                                    }];
//    request.needHeaderAuthorization = YES;
//    request.requestSerializerType = LORequestSerializerTypeJSON;
//    return [self startRequest:request];
//
//}
//
//- (NSString *)getRecordCountIfSuccess:(void (^)(id responseObject))success
//                              failure:(void (^)(LONetError *))failure {
//    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
//                                                        url:GET_RECORD_COUNT
//                                                 parameters:nil
//                                                    success:^(id responseObject) {
//                                                        
//                                                        success(responseObject);
//                                                        
//                                                    } failure:^(LONetError *error) {
//                                                        failure(error);
//                                                    }];
//    request.needHeaderAuthorization = YES;
//    request.requestSerializerType = LORequestSerializerTypeJSON;
//    return [self startRequest:request];
//}

@end
