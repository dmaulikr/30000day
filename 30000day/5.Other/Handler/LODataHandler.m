//
//  LODataHandler.m
//  30000day
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LODataHandler.h"
#import "LORequest.h"
#import "LOApiRequest.h"
#import "LONetworkAgent.h"
#import "STBaseViewController.h"

#import "AddressBookModel.h"
#import "ChineseString.h"
#import "WeatherInformationModel.h"
#import "UserInformationModel.h"
#import "UserLifeModel.h"
#import "GetFactorModel.h"
#import "UserInformationManager.h"
#import "MJExtension.h"
#import "ShopModel.h"
#import "SubwayModel.h"

#import "CommentModel.h"

#import "SearchConditionModel.h"


#import "SBJson.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"

//电话簿
#import <AddressBook/AddressBook.h>

//定位头文件
#import <CoreLocation/CoreLocation.h>

//聚合头文件
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "APIStoreSDK.h"


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

@interface LODataHandler () <CLLocationManagerDelegate>

@property (nonatomic ,copy) void (^(addressBookBlock))(NSMutableArray *,NSMutableArray *,NSMutableArray *);//获取电话簿的回调代码块

@property (nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic,copy) void (^(getLocationBlock))(NSString *,NSString *,CLLocationCoordinate2D);//获取地理位置和城市名称的回调代码块

@property (nonatomic,copy) void (^(getLocationErrorBlock))(NSError *);//获取地理位置和城市名称出错回调代码块

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

#pragma mark ---- 以下封装的是app所用到的所有接口

//***** 发送验证请求 *****/
- (void)getVerifyWithPhoneNumber:(NSString *)phoneNumber
                            type:(NSNumber *)type
                         success:(void (^)(NSString *responseObject))success
                         failure:(void (^)(NSString *error))failure {
    
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters addParameter:phoneNumber forKey:@"mobile"];
    
        [parameters addParameter:type forKey:@"type"];
    
        LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_SMS_CODE
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
                                                                    success(recvDic[@"value"]);
                                                                });
                                                                
                                                            } else if ([recvDic[@"code"] isEqualToNumber:@1100]){
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(recvDic[@"msg"]);
                                                                });
                                                                
                                                            }
                                                        
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(@"发生了未知错误");
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(@"发生了未知错误");
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

//*********** 核对短信验证码是否正确 ********/
- (void)postVerifySMSCodeWithPhoneNumber:(NSString *)phoneNumber
                             smsCode:(NSString *)smsCode
                             success:(void (^)(NSString *mobileToken))success
                             failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:phoneNumber forKey:@"mobile"];
    
    [parameters addParameter:smsCode forKey:@"code"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:VALIDATE_SMS_CODE
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(recvDic[@"value"]);
                                                                });
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError);
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

//************修改密码*****************//
- (void)sendUpdateUserPasswordWithMobile:(NSString *)mobile
                             mobileToken:(NSString *)mobileToken
                                password:(NSString *)password
                                 success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:mobile forKey:@"mobile"];
    
    [parameters addParameter:mobileToken forKey:@"mobileToken"];
    
    [parameters addParameter:password forKey:@"password"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:UPDATE_USER_PASSWORD_BYMOBILE
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(failureError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
  
}

//**************通过用户名获取userId通过用户名获取userId**********/
- (void)sendGetUserIdByUserName:(NSString *)userName
                        success:(void (^)(NSNumber *userId))success
                        failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:userName forKey:@"userName"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_USERID_BY_NAME
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(recvDic[@"value"]);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                            }
                                                            
                                                        } else {
                                                        
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

//***** 普通登录 *****/
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                  isPostNotification:(BOOL)isPostNotification
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *))failure {
    
     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:loginName forKey:@"userName"];
    
    [parameters addParameter:password forKey:@"password"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:LOGIN_WITH_PASSWORD
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDictionary = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDictionary[@"code"] isEqual:@0]) {
                                                                
                                                                NSDictionary *jsonDictionary = recvDictionary[@"value"];
                                                                
                                                                //设置个人信息
                                                                [self setUserInformationWithDictionary:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary] userName:loginName password:password postNotification:isPostNotification];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                   
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *error = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"账户无效"}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                            }
    
                                                        } else {
                                                            
                                                            NSError *error = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"账户无效"}];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(error);
                                                                
                                                            });
 
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    return [self startRequest:request];
}


//私有api设置个人信息
- (void)setUserInformationWithDictionary:(NSMutableDictionary *)jsonDictionary userName:(NSString *)userName password:(NSString *)password postNotification:(BOOL)isPostNotification {
    
    UserProfile *userProfile = [[UserProfile alloc] init];
    
    [userProfile setValuesForKeysWithDictionary:jsonDictionary];

    //保存用户的UID
    [Common saveAppDataForKey:KEY_SIGNIN_USER_UID withObject:userProfile.userId];
    
    [Common saveAppDataForKey:KEY_SIGNIN_USER_NAME withObject:userName];
    
    [Common saveAppDataForKey:KEY_SIGNIN_USER_PASSWORD withObject:password];
    
    NSMutableDictionary *userAccountDictionary = [NSMutableDictionary dictionary];
    
    //从磁盘中读取上次存储的数组
    NSMutableArray *userAccountArray = [NSMutableArray arrayWithArray:[Common readAppDataForKey:USER_ACCOUNT_ARRAY]];
    
    if (userAccountArray.count == 0 ) {
        
        [userAccountDictionary setObject:userName forKey:KEY_SIGNIN_USER_NAME];
        
        [userAccountDictionary setObject:password forKey:KEY_SIGNIN_USER_PASSWORD];
        
        [userAccountArray addObject:userAccountDictionary];
        
        [Common saveAppDataForKey:USER_ACCOUNT_ARRAY withObject:userAccountArray];
        
    } else {
        
        BOOL isExist = NO;//默认是不存在的
        
        for (NSInteger i = 0; i < userAccountArray.count; i++) {
            
            NSDictionary *oldDictionary = userAccountArray[i];
            
            if ([[oldDictionary objectForKey:KEY_SIGNIN_USER_NAME] isEqualToString:userName]) {
                
                isExist = YES;
                
                //进行覆盖操作
                [userAccountArray removeObjectAtIndex:i];
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                [dictionary setObject:userName forKey:KEY_SIGNIN_USER_NAME];
                
                [dictionary setObject:password forKey:KEY_SIGNIN_USER_PASSWORD];
                
                [userAccountArray insertObject:dictionary atIndex:i];
                
                [Common saveAppDataForKey:USER_ACCOUNT_ARRAY withObject:userAccountArray];
            }
        }
        if (isExist == NO) {//如果不存在，就要保存
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            
            [dictionary setValue:userName forKey:KEY_SIGNIN_USER_NAME];
            
            [dictionary setValue:password forKey:KEY_SIGNIN_USER_PASSWORD];
            
            [userAccountArray insertObject:dictionary atIndex:0];
            
            [Common saveAppDataForKey:USER_ACCOUNT_ARRAY withObject:userAccountArray];
            
        }
    }
    
  //设置用户信息
   STUserAccountHandler.userProfile = userProfile;
    
    if (isPostNotification) {
        
        //并发送通知
        [STNotificationCenter postNotificationName:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
        
    }
}

//********** 用户注册 ************/
- (void)postRegesiterWithPassword:(NSString *)password
                      phoneNumber:(NSString *)phoneNumber
                         nickName:(NSString *)nickName
                      mobileToken:(NSString *)mobileToken//校验后获取的验证码
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:phoneNumber forKey:@"mobile"];
    
    [parameters addParameter:mobileToken forKey:@"mobileToken"];
    
    [parameters addParameter:password forKey:@"password"];
    
    [parameters addParameter:nickName forKey:@"nickName"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:REGISTER
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDictionary = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDictionary[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary *jsonDictionary = recvDictionary[@"value"];
                                                                
                                                                //设置个人信息
                                                                [self setUserInformationWithDictionary:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary] userName:phoneNumber password:password postNotification:YES];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                                    success(YES);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                failure([[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}]);
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError);
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//**** 获取好友(dataArray存储的是UserInformationModel) *****/
- (void)getMyFriendsWithUserId:(NSString *)userId
                               success:(void (^)(NSMutableArray * dataArray))success
                               failure:(void (^)(NSError *))failure {

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:userId forKey:@"userId"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_MY_FRIENDS
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                //更新当前用户好友的数据库
                                                                
                                                                NSMutableArray *array = [UserInformationModel mj_objectArrayWithKeyValuesArray:recvDic[@"value"]];
                                                                
                                                                //赋值
                                                                [UserInformationManager shareUserInformationManager].userInformationArray = array;
                                                                
                                                                
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(array);
                                                                });
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError);
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//***** 更新个人信息 *****/
- (void)sendUpdateUserInformationWithUserId:(NSNumber *)userId
                                   nickName:(NSString *)nickName
                                     gender:(NSNumber *)gender
                                   birthday:(NSString *)birthday
                         headImageUrlString:(NSString *)headImageUrlString
                                    success:(void (^)(BOOL))success
                                    failure:(void (^)(LONetError *))failure {
    
    //内部测试接口
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:userId forKey:@"userId"];
    
    [parameters addParameter:nickName forKey:@"nickName"];

    [parameters addParameter:birthday forKey:@"birthday"];
    
    [parameters addParameter:headImageUrlString forKey:@"headImg"];
    
    [parameters addParameter:gender forKey:@"gender"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:SAVE_USER_INFORMATION
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                    STUserAccountHandler.userProfile.headImg = headImageUrlString;
                                                                    
                                                                    STUserAccountHandler.userProfile.gender = gender;
                                                                    
                                                                    STUserAccountHandler.userProfile.birthday = birthday;
                                                                    
                                                                    STUserAccountHandler.userProfile.nickName = nickName;
                                                                    
                                                                    //发出通知
                                                                    [STNotificationCenter postNotificationName:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
                                                                });
                                                                
                                                            } else {
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

//************获取通讯录好友************/
- (void)sendAddressBooklistRequestCompletionHandler:(void(^)(NSMutableArray *,NSMutableArray *,NSMutableArray *))handler {
    
    //保存回调代码块
    self.addressBookBlock = handler;
    
    dispatch_async(dispatch_queue_create("AddressBookModel", DISPATCH_QUEUE_SERIAL), ^{
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        NSMutableArray *addressBookArray = [NSMutableArray array];
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                
                [self copyAddressBook:addressBook addressBookArray:addressBookArray];
            });
            
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            
            [self copyAddressBook:addressBook addressBookArray:addressBookArray];
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                //[hud turnToError:@"没有获取通讯录权限"];
            });
        }
        
    });
}

//私有Api
- (void)copyAddressBook:(ABAddressBookRef)addressBook addressBookArray:(NSMutableArray *)addressBookArray {

    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for ( int i = 0; i < numberOfPeople; i++) {
        
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        for (int k = 0; k < ABMultiValueGetCount(phone); k++ ) {
            
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            
            if ([personPhoneLabel isEqualToString:@"住宅"] || [personPhoneLabel isEqualToString:@"手机"]) {
                //获取該Label下的电话值
                NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
                
                NSString *name;
                
                AddressBookModel *bookModel = [[AddressBookModel alloc] init];
                
                if (firstName!= nil && lastName != nil) {
                    
                    name = [lastName stringByAppendingString:firstName];
                }
                
                if (firstName!= nil && lastName == nil) {
                    
                    name = firstName;
                }
                
                if (firstName == nil && lastName != nil) {
                    
                    name = lastName;
                }
                
                bookModel.name = name;
                
                bookModel.mobilePhone = personPhone;
                
                [addressBookArray addObject:bookModel];
                
                break;
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *array =  [ChineseString LetterSortArray:addressBookArray];
        
        NSMutableArray *sortArray = [ChineseString SortArray:addressBookArray];
        
        NSMutableArray *indexArray = [ChineseString IndexArray:addressBookArray];
        
        self.addressBookBlock(array,sortArray,indexArray);
    
    });
}

//*************搜索某一个用户（里面装的SearchUserInformationModel）**********************/
- (void)sendSearchUserRequestWithNickName:(NSString *)nickName
                                   currentUserId:(NSString *)curUserId
                                  success:(void(^)(NSMutableArray *))success
                                  failure:(void (^)(NSError *))failure {
    //内部测试接口
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:nickName forKey:@"nickName"];
    
    [parameters addParameter:curUserId forKey:@"curUserId"];
    
    //异步执行
    dispatch_async(dispatch_queue_create("searchUser", DISPATCH_QUEUE_SERIAL), ^{
        
        NSError *error;
        
        NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:[Common urlStringWithDictionary:parameters withString:SEARCH_USER]] encoding:NSUTF8StringEncoding error:&error];
        
        if (error == nil  && ![Common isObjectNull:jsonStr]) {
            
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            
            NSError *firstError;
            
            NSDictionary * dictionary = [jsonParser objectWithString:jsonStr error:&firstError];
            
            if (firstError == nil && ![Common isObjectNull:dictionary]) {
                
               
                if ([dictionary[@"code"] isEqualToNumber:@0]) {
                    
                    //字典数组创建一个模型数组
                    NSMutableArray *array = [UserInformationModel mj_objectArrayWithKeyValuesArray:dictionary[@"value"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        success(array);
                        
                    });
                    
                }
              
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:dictionary[@"msg"]}];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(failureError);
                    
                });
            }
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(error);
                
            });
        }
        
    });;
 
}

//************添加一个好友(currentUserId:当前用户的userId,nickName:待添加的userId,nickName:待添加的昵称)*************/
- (void)sendAddUserRequestWithcurrentUserId:(NSString *)currentUserId
                                     userId:(NSString *)userId
                                    success:(void(^)(BOOL success))success
                                    failure:(void (^)(NSError *error))failure {
    //内部测试接口
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:currentUserId forKey:@"curUserId"];
    
    [parameters addParameter:userId forKey:@"fUserId"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:ADD_USER
                                                 parameters:parameters
                                            success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    if ([recvDic[@"value"] isEqual:@1]) {
                                                                        
                                                                         success(YES);
                                                                        
                                                                        //发出通知
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:STUserAddFriendsSuccessPostNotification object:nil];
                                                                        
                                                                    }
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError);
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}


//***************开始定位操作********************/
- (void)startFindLocationSucess:(void (^)(NSString *,NSString *,CLLocationCoordinate2D))sucess
                        failure:(void (^)(NSError *))failure {
    
    self.getLocationBlock = sucess;
    
    self.getLocationErrorBlock = failure;
    
    self.locationManager = [[CLLocationManager alloc] init] ;
    
    self.locationManager.delegate = self;
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.distanceFilter = 100;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [_locationManager requestWhenInUseAuthorization];
        
    }
    //开始定位
    [_locationManager startUpdatingLocation];
}

#pragma ---
#pragma mark --- CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
        {
            
             self.getLocationErrorBlock([[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}]);

        }
            break;
            
        default:
            
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    
    //如果调用已经一次，不再执行
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error){
        
        if (array.count > 0){
            
            CLPlacemark *placemark = [array objectAtIndex:0];
 
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (![Common isObjectNull:placemark.locality] && ![Common isObjectNull:placemark.administrativeArea]) {
                    
                    self.getLocationBlock(placemark.locality,placemark.administrativeArea,currentLocation.coordinate);//回调
                    
                    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
                    [manager stopUpdatingLocation];
                }
            });
            
        } else if (error == nil && [array count] == 0) {
            
           NSError *newError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}];
            
            self.getLocationErrorBlock(newError);
            
        } else if (error != nil) {
        
            self.getLocationErrorBlock(error);
        }

    }];
    
}

//*****************获取天气情况(代码块返回的是天气模型)***********/
- (void)getWeatherInformation:(NSString *)cityName
                       sucess:(void (^)(WeatherInformationModel *))sucess
                      failure:(void (^)(NSError *))failure {
    
    if (cityName != nil) {
        
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:cityName forKey:@"city"];
        
        NSString *method = @"post";
        
        APISCallBack* callBack = [APISCallBack alloc];
        
        callBack.onSuccess = ^(long status, NSString* responseString) {
            NSLog(@"onSuccess");
            if(responseString != nil) {
                
                NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
                
                NSArray *sumArray = dictionary[@"HeWeather data service 3.0"];
                NSDictionary *sumDictionary = sumArray[0];
                
                NSDictionary *now = sumDictionary[@"now"];
                NSDictionary *aqi = sumDictionary[@"aqi"][@"city"];
                
//              NSDictionary *basic = sumDictionary[@"basic"];
//              NSDictionary *suggestion = sumDictionary[@"suggestion"];
//              NSDictionary *hourly_forecast = sumDictionary[@"hourly_forecast"];
//              NSDictionary *status = sumDictionary[@"status"];
//              NSDictionary *daily_forecast = sumDictionary[@"daily_forecast"];
                
//              NSString *pm25 = aqi[@"pm25"];
                NSString *code = now[@"cond"][@"code"];
                NSString *tmp = now[@"tmp"];
                NSString *qlty = aqi[@"qlty"];
                
                WeatherInformationModel *informationModel = [[WeatherInformationModel alloc] init];

                informationModel.cityName = cityName;

                informationModel.temperatureString = [NSString stringWithFormat:@"%@℃",tmp];

                informationModel.pm25Quality = qlty;

                informationModel.weatherShowImageString = [NSString stringWithFormat:@"%@.png",code];
                        
                dispatch_async(dispatch_get_main_queue(), ^{
                            
                            sucess(informationModel);
                            
                        });
                
                    }
                };

        callBack.onError = ^(long status, NSString* responseString) {
            NSLog(@"onError");
            NSLog(@"%@",responseString);
        };
    
        callBack.onComplete = ^() {
            NSLog(@"onComplete");
        };
        
        //请求API
        [ApiStoreSDK executeWithURL:HfPath method:method apikey:HfKey parameter:parameter callBack:callBack];
        
    }
}

//**********获取用户的天龄(dataArray装的是UserLifeModel模型)**********************/
- (void)sendUserLifeListWithCurrentUserId:(NSNumber *)currentUserId
                                   endDay:(NSString *)endDay//2016-02-19这种模式
                                dayNumber:(NSString *)dayNumber
                                  success:(void (^)(NSMutableArray *dataArray))success
                                  failure:(void (^)(LONetError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:currentUserId forKey:@"userId"];
    
    [parameters addParameter:endDay forKey:@"endDay"];
    
    [parameters addParameter:dayNumber forKey:@"day"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_USER_LIFE_LIST
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSMutableArray *array = [UserLifeModel mj_objectArrayWithKeyValuesArray:recvDic[@"value"]];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(array);
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                             failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//***********获取健康因子(里面装的是GetFacotorModel数组)***************/
- (void)sendGetFactors:(void (^)(NSMutableArray *dataArray))success
                  failure:(void (^)(LONetError *error))failure {
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_FACTORS
                                                 parameters:nil
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSMutableArray *oldArray = [NSMutableArray arrayWithArray:recvDic[@"value"]];
                                                                
                                                                NSMutableArray *newArray = [NSMutableArray array];
                                                                
                                                                for (int i = 0; i < oldArray.count ; i++) {
                                                                    
                                                                    NSDictionary *dictionary = oldArray[i];
                                                                    
                                                                    GetFactorModel *model = [[GetFactorModel alloc] init];
                                                                    
                                                                    model.title = dictionary[@"title"];
                                                                    
                                                                    model.factorId = dictionary[@"id"];
                                                                    
                                                                    [newArray addObject:model];
                                                                }
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(newArray);
                                                                    
                                                                });
                                                                
                                                                //下载子因素模型
                                                                [self sendGetSubFactorsWithFactorsModel:newArray success:^(NSMutableArray *dataArray) {
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                       
                                                                        success(dataArray);
                                                                        
                                                                    });
                                                                    
                                                                    //获取某人健康因素模型
                                                                    [self sendGetUserFactorsWithUserId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] factorsModelArray:dataArray success:^(NSMutableArray *dataArray) {
                                                                        
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            
                                                                            success(dataArray);
                                                                            
                                                                        });
                                                                        
                                                                    } failure:^(LONetError *error) {
                                                                        
                                                                        NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"加载个人健康因失败"}];
                                                                        
                                                                        LONetError *newError = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                        
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            
                                                                            failure(newError);
                                                                            
                                                                        });;
                                                                        
                                                                    }];
                                                                    
                                                                } failure:^(LONetError *error) {
                                                                    
                                                                    NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"加载健康因子选项失败"}];
                                                                    
                                                                    LONetError *newError = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        
                                                                        failure(newError);
                                                                        
                                                                    });
                                                                    
                                                                }];
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"加载健康因子失败"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"加载健康因子失败"}];
                                                            
                                                            LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(error);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"加载健康因子失败"}];
                                                        
                                                        LONetError *newError = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(newError);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//***********私有API:获取每个健康模型的子模型(param:factorsArray装的是GetFactorModel,return:dataArray装GetFactorModel数组)***************/
- (void)sendGetSubFactorsWithFactorsModel:(NSMutableArray *)factorsArray
                                  success:(void (^)(NSMutableArray *dataArray))success
                                  failure:(void (^)(LONetError *error))failure {
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_SUBFACTORS
                                                 parameters:nil
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSMutableArray *oldArray = [NSMutableArray arrayWithArray:recvDic[@"value"]];
                                                                
                                                                for (int i = 0; i < oldArray.count ; i++) {
                                                                    
                                                                    NSDictionary *dictionary = oldArray[i];
                                                                    
                                                                    int j = [dictionary[@"fid"] intValue] - 1;
                                                                    
                                                                    if ( j >= 0 ) {
                                                                        
                                                                        GetFactorModel *factorModel = factorsArray[j];
                                                                        
                                                                        SubFactorModel *subModel = [[SubFactorModel alloc] init];
                                                                        
                                                                        subModel.title = dictionary[@"title"];
                                                                        
                                                                        subModel.subFactorId = dictionary[@"id"];
                                                                        
                                                                        subModel.factorId = dictionary[@"fid"];
                                                                        
                                                                        [factorModel.subFactorArray addObject:subModel];
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(factorsArray);
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//***********获取某人的健康因子(里面装的是GetFacotorModel数组)***************/
- (void)sendGetUserFactorsWithUserId:(NSNumber *)userId
                   factorsModelArray:(NSMutableArray *)factorsModelArray
                             success:(void (^)(NSMutableArray *dataArray))success
                             failure:(void (^)(LONetError *error))failure {
    //异步执行
    dispatch_async(dispatch_queue_create("saveUserFactores", DISPATCH_QUEUE_SERIAL), ^{
        
        NSString *url = [NSString stringWithFormat:@"http://192.168.1.101:8081/stapi/factor/getUserFactor?userId=%@",userId];
        
        NSMutableString *mUrl = [[NSMutableString alloc] initWithString:url] ;
        
        NSError *error;
        
        NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:mUrl] encoding:NSUTF8StringEncoding error:&error];
        
        if (error == nil  && ![Common isObjectNull:jsonStr]) {
            
            SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
            
            NSError *firstError;
            
            NSDictionary * dictionary = [jsonParser objectWithString:jsonStr error:&firstError];
            
            if (firstError == nil && ![Common isObjectNull:dictionary]) {
                
                NSString *valueString = dictionary[@"value"];
                
                NSError *secondError;
                
                NSArray *valueArray = [jsonParser objectWithString:valueString error:&secondError];
                
                if (secondError == nil && ![Common isObjectNull:valueArray]) {
                    
                    if ([dictionary[@"code"] isEqualToNumber:@0]) {
                        
                        NSMutableArray *oldArray = [NSMutableArray arrayWithArray:valueArray];
                        
                        for (int i = 0; i < oldArray.count ; i++) {
                            
                            NSDictionary *dictionary = oldArray[i];
                            
                            NSNumber *subFactorId = dictionary[@"id"];
                            
                            NSNumber *keyNumber = dictionary[@"k"];
                            
                            GetFactorModel *factorModel = factorsModelArray[[keyNumber intValue] - 1];
                            
                            factorModel.userSubFactorModel.subFactorId = subFactorId;
                            
                            factorModel.userSubFactorModel.factorId = [NSNumber numberWithInt:i + 1];
                            
                            factorModel.userSubFactorModel.title = [GetFactorModel titleStringWithDataNumber:subFactorId subFactorArray:factorModel.subFactorArray];
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success(factorsModelArray);
                            
                        });
                        
                    } else {
                        
                        NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"请设置健康因素"}];
                        
                        LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            failure(error);
                            
                        });
                    }
                    
                } else {
                    
                    NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"请设置健康因素"}];
                    
                    LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        failure(error);
                        
                    });
                    
                }
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"请设置健康因素"}];
                
                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(error);
                    
                });
            }
            
        } else {
            
            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"获取个人健康因子失败"}];
            
            LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(error);
                
            });
        }
        
    });;
   
}

//********保存某人健康因子到服务器(factorsModelArray存储的是GetFactorModel模型)*********************/
- (void)sendSaveUserFactorsWithUserId:(NSNumber *)userId
                    factorsModelArray:(NSMutableArray *)factorsModelArray
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(LONetError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"userId"] = userId;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0; i < factorsModelArray.count; i++) {
        
        GetFactorModel *factorModel = factorsModelArray[i];
        
        if (factorModel.userSubFactorModel.subFactorId) {
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            
            dictionary[@"id"] = factorModel.userSubFactorModel.subFactorId;
            
            dictionary[@"k"] = [NSNumber numberWithInt:i + 1];
            
            [dataArray addObject:dictionary];
            
        }
    }
    
    NSString *dataString = [dataArray mj_JSONString];
    
    params[@"data"] = dataString;
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:SAVE_USER_FACTORS
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    //当用户成功保存健康因子的时候会发出通知
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:STUserAccountHandlerUseProfileDidChangeNotification
                                                                                                                        object:nil];
                                                                    
                                                                      success(YES);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

- (void)sendUpdateUserHeadPortrait:(NSNumber *)userId
                        headImage:(UIImage *)image
                          success:(void (^)(NSString *imageUrl))success
                          failure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setHTTPShouldHandleCookies:NO];
    
    [request setTimeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    [request setURL:[NSURL URLWithString:@"http://192.168.1.101:8081/stapi/upload/uploadFile"]];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"V2ymHFg03ehbqgZCaKO6jy"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"userId"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",userId] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"type"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",@1] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    if (imageData) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:imageData];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                failure(connectionError);
                
            });
            
        } else {
            
            
            NSError *localError = nil;
            
            NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError];
            
            if (localError != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(localError);
                    
                });
                
            } else {
                
                if (![Common isObjectNull:parsedObject[@"value"]]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        success(parsedObject[@"value"]);
                        
                    });
                }
            }
            
        }
        
    }];
}


-(void)sendGetSecurityQuestion:(NSNumber *)userId
                       success:(void (^)(NSDictionary *dic))success
                       failure:(void (^)(LONetError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"userId"] = userId;
    
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_SECURITY_QUESTION
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary *oldArray = recvDic[@"value"];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(oldArray);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}


- (void)sendGetSecurityQuestionSum:(void (^)(NSArray *array))sucess
                           failure:(void (^)(LONetError *error))failure{

    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_SECURITY_QUESTION_SUM
                                                 parameters:nil
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSArray *oldArray = recvDic[@"value"];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    sucess(oldArray);
                                                                
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}


-(void)sendSecurityQuestionvalidate:(NSNumber *)userId
                            answer:(NSArray *)answerArr
                            success:(void (^)(NSString *successToken))success
                            failure:(void (^)(LONetError *error))failure{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userId forKey:@"userId"];
    
    for (int i=0; i<answerArr.count; i++) {
        
        [params setObject:answerArr[i] forKey:[NSString stringWithFormat:@"a%d",i+1]];
    }
    
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_SECURITY_QUESTION_VERIFICATION
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                             
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(recvDic[@"value"]);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];

}

-(void)sendSecurityQuestionUptUserPwdBySecu:(NSNumber *)userId
                                      token:(NSString *)token
                                   password:(NSString *)password
                                    success:(void (^)(BOOL success))success
                                    failure:(void (^)(LONetError *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:token forKey:@"token"];
    [params setObject:userId forKey:@"userId"];
    [params setObject:password forKey:@"password"];
    
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_SECURITY_QUESTION_UPTUSERPWDBYSECU
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(recvDic[@"value"]);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//***********************************修改密码*********************/
- (void)sendChangePasswordWithUserId:(NSNumber *)userId
                         oldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:oldPassword forKey:@"oldPwd"];
    
    [params setObject:newPassword forKey:@"newPwd"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:CHANGE_PASSWORD
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

- (void)sendChangeSecurityWithUserId:(NSNumber *)userId
                            qidArray:(NSArray *)qidArray
                         answerArray:(NSArray *)answerArray
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    for (int i = 0; i < answerArray.count; i++) {
        
        [params setObject:qidArray[i] forKey:[NSString stringWithFormat:@"q%d",i+1]];
        
        [params setObject:answerArray[i] forKey:[NSString stringWithFormat:@"a%d",i+1]];
    }
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:UPDATE_USER_SECURITY
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

- (void)sendStatUserLifeWithUserId:(NSNumber *)userId
                        dataString:(NSString *)data
                           success:(void (^)(BOOL success))success
                           failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:data forKey:@"data"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:UPDATE_STAT_USERLLFE
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

-(void)sendUploadUserSendEmailWithUserId:(NSNumber *)userId
                             emailString:(NSString *)email
                                 success:(void (^)(BOOL))success
                                 failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:email forKey:@"email"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:UPDATE_USER_SENDEMAIL
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];

}


-(void)sendVerificationUserEmailWithUserId:(NSNumber *)userId
                                   success:(void (^)(NSDictionary *verificationDictionary))success
                                   failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:UPDATE_USER_VERIFICATION_EMAIL
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    

                                                                    success(recvDic[@"value"]);
                                        
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

- (void)sendCompanyDetailsWithProductId:(NSString *)productId
                                    Success:(void (^)(ShopDetailModel *model))success
                                    failure:(void (^)(NSError *error))failure{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:productId forKey:@"productId"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_COMPANYDETAILS
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary * dataDictionary = recvDic[@"value"];
                                                                
                                                                ShopDetailModel *model = [[ShopDetailModel alloc] init];
                                                                
                                                                [model setValuesForKeysWithDictionary:dataDictionary];
                                                                

                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(model);
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*********************************获取城市地铁数据*******************/
- (void)sendCitySubWayWithCityId:(NSString *)cityId
                         Success:(void (^)(NSMutableArray *))success
                         failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (![Common isObjectNull:cityId]) {
        
        [params setObject:cityId forKey:@"citySign"];
    }

    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_LINE_LIST
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                                                                
                                                                NSArray *array = recvDic[@"value"];
                                                                
                                                                for (int i = 0; i < array.count; i++) {
                                                                    
                                                                    NSDictionary *dictionary = array[i];
                                                                    
                                                                    NSArray *subArray = dictionary[@"list"];
                                                                    
                                                                    SubwayModel *subwayModel = [[SubwayModel alloc] init];
                                                                    
                                                                    subwayModel.subWayId = dictionary[@"id"];
                                                                    
                                                                    subwayModel.lineCode = dictionary[@"lineCode"];
                                                                    
                                                                    subwayModel.lineName = dictionary[@"lineName"];
                                                                    
                                                                    subwayModel.list = [[NSMutableArray alloc] init];
                                                                    
                                                                    for (int i = 0; i < subArray.count; i++) {
                                                                        
                                                                        platformModel *model = [[platformModel alloc] init];
                                                                        
                                                                        NSDictionary *dictionary = subArray[i];
                                                                        
                                                                        [model setValuesForKeysWithDictionary:dictionary];

                                                                        [subwayModel.list addObject:model];
                                                                    }
                                                                    
                                                                    [dataArray addObject:subwayModel];
                                                                }
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(dataArray);

                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

//*********************************获取根据筛选条件来获取所有的商品列表*******************/
- (void)sendShopListWithSearchConditionModel:(SearchConditionModel *)conditionModel
                                    isSearch:(BOOL)isSearch
                                  pageNumber:(NSInteger)pageNumber
                                     Success:(void (^)(NSMutableArray *))success
                                     failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (![conditionModel.sequence isEqualToNumber:@0] && ![Common isObjectNull:conditionModel.sequence]) {
        if ([conditionModel.sequence isEqualToNumber:@2]) {
            [params addParameter:conditionModel.latitude forKey:@"latitude"];
            [params addParameter:conditionModel.longitude forKey:@"longitude"];
        }
        [params addParameter:conditionModel.sequence forKey:@"sequence"];
    }
    
    //分页
    [params addParameter:[NSNumber numberWithInteger:pageNumber] forKey:@"currentPage"];
    
    if (![Common isObjectNull:conditionModel.subwayStation]) {//表示是点击地铁的
        
        [params addParameter:conditionModel.subwayStation forKey:@"subwayStation"];
        
    } else if (![Common isObjectNull:conditionModel.businessCircle] && ![Common isObjectNull:conditionModel.regional]) {//表示是点击商圈的
        
        if (![conditionModel.businessCircle isEqualToString:@"全部商区"]) {
            
            [params addParameter:conditionModel.businessCircle forKey:@"businessCircle"];
            
            [params addParameter:conditionModel.regional forKey:@"regional"];
        }
    }
    
    if (![Common isObjectNull:conditionModel.sift] && ![conditionModel.sift isEqualToNumber:@0]) {
        
        [params addParameter:conditionModel.sift forKey:@"sift"];
    }
    
    if (isSearch) {//给搜索内容赋值
        
        [params addParameter:conditionModel.searchContent forKey:@"productName"];
    }
    
    //两个必填
    [params addParameter:[Common deletedStringWithParentString:conditionModel.provinceName] forKey:@"addrProvince"];
    
    [params addParameter:[Common deletedStringWithParentString:conditionModel.cityName] forKey:@"addrCity"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:isSearch?GET_SEARCH_LIST:GET_SHOP_LIST
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                                                                
                                                                NSArray *array = recvDic[@"value"];
                                                                
                                                                for (int i = 0; i < array.count; i++) {
                                                                    
                                                                    NSDictionary *dictionary = array[i];
                                                                    
                                                                    ShopModel *model = [[ShopModel alloc] init];
                                                                    
                                                                    [model setValuesForKeysWithDictionary:dictionary];
                                                                    
                                                                    [dataArray addObject:model];
                                                                    
                                                                }
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(dataArray);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}


//*********************************获取评论列表*******************/
- (void)sendfindCommentListWithProductId:(NSInteger)productId
                                    type:(NSInteger)type
                                     pId:(NSInteger)pId
                                  userId:(NSInteger)userId
                                 Success:(void (^)(NSMutableArray *success))success
                                 failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (productId != -1) {
        
        [params setObject:@(productId) forKey:@"productId"];
        
    }
    
    if (type != -1) {
        
        [params setObject:@(type) forKey:@"type"];
        
    }
    
    if (pId != -1) {
        
        [params setObject:@(pId) forKey:@"pId"];
        
    }
    
    if (userId != -1) {
        
        [params setObject:@(userId) forKey:@"userId"];
        
    }
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:GET_FINDCOMMENTLIST
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                                                                
                                                                NSArray *array = recvDic[@"value"];
                                                                
                                                                for (int i = 0; i < array.count; i++) {
                                                                    
                                                                    NSDictionary *dictionary = array[i];
                                                                    
                                                                    CommentModel *commentModel = [[CommentModel alloc] init];
                                                                    
                                                                    if ([dictionary[@"pId"] integerValue]== 0) {
                                                                        
                                                                        commentModel.level = 1;
                                                                        
                                                                    }
                                                                    
                                                                    [commentModel setValuesForKeysWithDictionary:dictionary];
                                                                    
                                                                    [dataArray addObject:commentModel];

                                                                }
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(dataArray);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*********************************获取评论列表*******************/
- (void)sendsaveCommentWithProductId:(NSString *)productId
                                type:(NSInteger)type
                              userId:(NSString *)userId
                              remark:(NSString *)remark
                          numberStar:(NSInteger)numberStar
                              picUrl:(NSString *)picUrl
                                 pId:(NSString *)pId
                             Success:(void (^)(BOOL))success
                             failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (productId != nil) {
        
        [params setObject:productId forKey:@"productId"];
        
    }
    
    if (type != -1) {
        
        [params setObject:@(type) forKey:@"type"];
        
    }
    
    if (userId != nil) {
        
        [params setObject:userId forKey:@"userId"];
        
    }
    
    if (remark != nil) {
        
        [params setObject:remark forKey:@"remark"];
        
    }
    
    if (numberStar != -1) {
        
        [params setObject:@(numberStar) forKey:@"numberStar"];
        
    }
    
    if (picUrl != nil) {
        
        [params setObject:picUrl forKey:@"picUrl"];
        
    }
    
    if (pId != nil) {
        
        [params setObject:pId forKey:@"pId"];
        
    }
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:SAVE_COMMENT
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                });
                                        
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(NO);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
    

}

//*********************************点赞*************************/
- (void)sendPointPraiseOrCancelWithCommentId:(NSString *)commentId
                                 isClickLike:(BOOL)isClickLike
                                     Success:(void (^)(BOOL))success
                                     failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (commentId != nil) {
        
        [params setObject:commentId forKey:@"commentId"];
        
    }
    
    [params setObject:@(isClickLike) forKey:@"isClickLike"];
    
    LOApiRequest *request = [LOApiRequest requestWithMethod:LORequestMethodGet
                                                        url:SAVE_POINTPRAISEORCANCEL
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(NO);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    [self startRequest:request];
    
    
}

@end
