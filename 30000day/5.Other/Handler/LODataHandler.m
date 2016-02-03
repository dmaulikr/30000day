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

- (NSString *)postSignInWithPassword:(NSString *)password
                        phoneNumber:(NSString *)phonenumber
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(LONetError *))failure {
    
     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:phonenumber forKey:@"LoginName"];
    
    [parameters addParameter:password forKey:@"LoginPassword"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodPost
                                                        url:LOGIN_WITH_PASSWORD
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        success(responseObject);
                                                        
                                                    } failure:^(LONetError *error) {
                                                        failure(error);
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    return [self startRequest:request];
}

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

- (NSString *)getMyFriendsWithPassword:(NSString *)password
                           phoneNumber:(NSString *)phonenumber
                               success:(void (^)(id responseObject))success
                               failure:(void (^)(LONetError *))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:phonenumber forKey:@"LoginName"];
    
    [parameters addParameter:password forKey:@"LoginPassword"];
    
        LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                            url:GET_MY_FRIENDS
                                                     parameters:parameters
                                                        success:^(id responseObject) {
    
                                                            success(responseObject);
    
                                                        } failure:^(LONetError *error) {
                                                            failure(error);
                                                        }];
        request.needHeaderAuthorization = NO;
    
        request.requestSerializerType = LORequestSerializerTypeJSON;
    
        return [self startRequest:request];
    
}

- (void)postUpdateProfileWithUserID:(NSString *)userID
                                 Password:(NSString *)password
                              PhoneNumber:(NSString *)phonenumber
                                 NickName:(NSString *)nickName
                                   Gender:(NSString *)gender
                                 Birthday:(NSString *)birthday
                                  success:(void (^)(BOOL))success
                                  failure:(void (^)(NSError *))failure {
    
        NSString *URLString= @"http://116.254.206.7:12580/M/API/UpdateProfile?";
    
        NSURL * URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
    
        NSString *param=[NSString stringWithFormat:@"UserID=%@&LoginName=%@&LoginPassword=%@&NickName=%@&Gender=%d&Birthday=%@",userID,phonenumber,password,nickName,[gender intValue],birthday];
    
        NSData * postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
        [request setHTTPMethod:@"post"];
    
        [request setURL:URL];
    
        [request setHTTPBody:postData];
    
        NSURLResponse * response;
    
        NSError * error;
    
        NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                failure(error);
                
            });
            
        } else {
            
            if ([[[NSString alloc] initWithData:backData encoding:NSUTF8StringEncoding] intValue]==1) {
                
                success(YES);
                
            } else {
                
                failure(error);
            }
        }
    
}


@end
