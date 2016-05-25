 //
//  LODataHandler.m
//  30000day
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "STDataHandler.h"
#import "STRequest.h"
#import "STApiRequest.h"
#import "STNetworkAgent.h"
#import "STBaseViewController.h"

#import "AddressBookModel.h"
#import "ChineseString.h"
#import "WeatherInformationModel.h"
#import "UserInformationModel.h"
#import "UserLifeModel.h"
#import "GetFactorModel.h"
#import "MJExtension.h"

#import "ShopModel.h"
#import "SubwayModel.h"
#import "CompanyModel.h"
#import "CommentModel.h"
#import "SearchConditionModel.h"
#import "AppointmentModel.h"
#import "MyOrderModel.h"
#import "MyOrderDetailModel.h"
#import "InformationModel.h"
#import "InformationWriterModel.h"
#import "PriceModel.h"
#import "QuestionAnswerModel.h"
#import "NewFriendModel.h"
#import "MailListManager.h"
#import "GetFactorObject.h"

#import "SBJson.h"
#import "AFNetworking.h"
#import "NSString+URLEncoding.h"
#import "YYModel.h"
//电话簿
#import <AddressBook/AddressBook.h>

//定位头文件
#import <CoreLocation/CoreLocation.h>

//聚合头文件
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "APIStoreSDK.h"

//极光推送
#import "JPUSHService.h"

#import "NSArray+Chinese.h"
#import "NSString+Chinese.h"

@interface STDataHandler () <CLLocationManagerDelegate>

@property (nonatomic,strong)CLLocationManager *locationManager;

@property (nonatomic,copy) void (^(getLocationBlock))(NSString *,NSString *,CLLocationCoordinate2D);//获取地理位置和城市名称的回调代码块

@property (nonatomic,copy) void (^(getLocationErrorBlock))(NSError *);//获取地理位置和城市名称出错回调代码块

@end


@implementation STDataHandler

+ (STDataHandler *)sharedHandler {
    
    static id handler = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        handler = [[self alloc] init];
        
    });
    
    return handler;
}

// 开始一个请求，并将请求 Hash 值插入回 BaseViewController
- (NSString *)startRequest:(STRequest *)request {
    
    NSString *requestHash = [[STNetworkAgent sharedAgent] addRequest:request];
    
    return requestHash;
}

+ (NSString *)startRequest:(STRequest *)request {
    
    NSString *requestHash = [[STNetworkAgent sharedAgent] addRequest:request];
    
    return requestHash;
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
    
        STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                            } else {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(recvDic[@"msg"]);
                                                                });
                                                                
                                                            }
                                                        
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError.userInfo[NSLocalizedDescriptionKey]);
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error.userInfo[NSLocalizedDescriptionKey]);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
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
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                            } else {
                                                            
                                                                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:recvDic[@"msg"]                                                                     forKey:NSLocalizedDescriptionKey];

                                                               localError = [NSError errorWithDomain:@"com.sms.validate" code:[recvDic[@"code"] integerValue] userInfo:userInfo];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError);
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

//************修改密码*****************//
+ (void)sendUpdateUserPasswordWithMobile:(NSString *)mobile
                             mobileToken:(NSString *)mobileToken
                                password:(NSString *)password
                                 success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:mobile forKey:@"mobile"];
    
    [parameters addParameter:mobileToken forKey:@"mobileToken"];
    
    [parameters addParameter:password forKey:@"password"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendUpdateUserPassword",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,UPDATE_USER_PASSWORD_BYMOBILE] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                success(YES);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
  
}

//**************通过用户名获取userId通过用户名获取userId**********/
+ (void)sendGetUserIdByUserName:(NSString *)userName
                        success:(void (^)(NSNumber *userId))success
                        failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:userName forKey:@"userName"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendGetUserId",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_USERID_BY_NAME] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                success(recvDic[@"value"]);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}

//***** 普通登录 *****/
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                  isPostNotification:(BOOL)isPostNotification
                    isFromThirdParty:(BOOL)isFromThirdParty
                                type:(NSString *)type
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *))failure {

//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    
//    [parameters addParameter:loginName forKey:@"userName"];
//    
//    [parameters addParameter:@(isFromThirdParty) forKey:@"isFromThirdParty"];
//
//    [parameters addParameter:password forKey:@"password"];
//    
//    [parameters addParameter:type forKey:@"type"];
//    
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.completionQueue = dispatch_queue_create("postSignInWithPassword",DISPATCH_QUEUE_PRIORITY_DEFAULT);
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,LOGIN_WITH_PASSWORD] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSError *localError = nil;
//        
//        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
//        if (localError == nil) {
//            
//            NSDictionary *recvDic = (NSDictionary *)parsedObject;
//            
//            if ([recvDic[@"code"] isEqualToNumber:@0]) {
//                
//                NSDictionary *jsonDictionary = recvDic[@"value"];
//                
//                //设置个人信息
//                [self setUserInformationWithDictionary:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary] userName:loginName password:password isFromThirdParty:isFromThirdParty postNotification:isPostNotification];
//                
//                success(YES);
//                
//            } else {
//                
//                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
//                
//                failure(failureError);
//            }
//            
//        } else {
//            
//            failure(localError);
//        }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        
//        failure(error);
//    }];


     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:loginName forKey:@"userName"];
    
    [parameters addParameter:@(isFromThirdParty) forKey:@"isFromThirdParty"];
    
    if (password != nil) {
        
        [parameters addParameter:password forKey:@"password"];
    }
    
    if (type != nil) {
        
        [parameters addParameter:type forKey:@"type"];
    }
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                [self setUserInformationWithDictionary:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary] userName:loginName password:password isFromThirdParty:isFromThirdParty postNotification:isPostNotification];
                                                                
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
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    return [self startRequest:request];
}


//私有api设置个人信息
- (void)setUserInformationWithDictionary:(NSMutableDictionary *)jsonDictionary userName:(NSString *)userName password:(NSString *)password isFromThirdParty:(BOOL)isFromThirdParty postNotification:(BOOL)isPostNotification {
    
    UserProfile *userProfile = [[UserProfile alloc] init];
    
    [userProfile setValuesForKeysWithDictionary:jsonDictionary];

    //保存用户的UID
    [Common saveAppDataForKey:KEY_SIGNIN_USER_UID withObject:userProfile.userId];
    
    [Common saveAppDataForKey:KEY_SIGNIN_USER_NAME withObject:userName];
    
    if (password != nil) [Common saveAppDataForKey:KEY_SIGNIN_USER_PASSWORD withObject:password];
    
    NSMutableDictionary *userAccountDictionary = [NSMutableDictionary dictionary];
    
    if (!isFromThirdParty) {
        
        //从磁盘中读取上次存储的数组
        NSMutableArray *userAccountArray = [NSMutableArray arrayWithArray:[Common readAppDataForKey:USER_ACCOUNT_ARRAY]];
        
        if (userAccountArray.count == 0 ) {
            
            [userAccountDictionary setObject:userName forKey:KEY_SIGNIN_USER_NAME];
            
            if (password != nil) [userAccountDictionary setObject:password forKey:KEY_SIGNIN_USER_PASSWORD];
            
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
                    
                    if (password != nil) [dictionary setObject:password forKey:KEY_SIGNIN_USER_PASSWORD];
                    
                    [userAccountArray insertObject:dictionary atIndex:i];
                    
                    [Common saveAppDataForKey:USER_ACCOUNT_ARRAY withObject:userAccountArray];
                }
            }
            if (isExist == NO) {//如果不存在，就要保存
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                [dictionary setValue:userName forKey:KEY_SIGNIN_USER_NAME];
                
                if (password != nil) [dictionary setValue:password forKey:KEY_SIGNIN_USER_PASSWORD];
                
                [userAccountArray insertObject:dictionary atIndex:0];
                
                [Common saveAppDataForKey:USER_ACCOUNT_ARRAY withObject:userAccountArray];
                
            }
        }
        
    }

  //设置用户信息
   STUserAccountHandler.userProfile = userProfile;
    
    if (isPostNotification) {
        
        //并发送通知
        [STNotificationCenter postNotificationName:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
        
    }
    
    //设置推送别名
    [JPUSHService setTags:nil alias:[NSString stringWithFormat:@"%@",userProfile.userId] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        
        NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        
    }];
    
    //初始化通讯录
    [[MailListManager shareManager] synchronizedMailList];
}

//********** 用户注册************/
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("setUserInformationWithDictionary",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,REGISTER] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                NSDictionary *jsonDictionary = recvDic[@"value"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    //设置个人信息
                    [self setUserInformationWithDictionary:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary] userName:phoneNumber password:password  isFromThirdParty:NO postNotification:YES];
                
                });

                success(YES);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}

//**** 获取好友(dataArray存储的是UserInformationModel) *****/
+ (void)getMyFriendsWithUserId:(NSString *)userId
                               success:(void (^)(NSMutableArray * dataArray))success
                               failure:(void (^)(NSError *))failure {

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:userId forKey:@"userId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("getMyFriendsWithUserId",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_MY_FRIENDS] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                NSMutableArray *array = [UserInformationModel mj_objectArrayWithKeyValuesArray:recvDic[@"value"]];
                
                success(array);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}

//************************ 删除好友 **********/
+ (void)sendDeleteFriendWithUserId:(NSNumber *)userId
                      friendUserId:(NSNumber *)friendId
                           success:(void (^)(BOOL  success))success
                           failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:userId forKey:@"curUserId"];
    
    [parameters addParameter:friendId forKey:@"fUserId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendDeleteFriendWithUserId",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,DELETE_FRIEND] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                success(YES);
                
                [STNotificationCenter postNotificationName:STUseDidSuccessDeleteFriendSendNotification object:nil];
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
}


//***** 更新个人信息 *****/
- (void)sendUpdateUserInformationWithUserId:(NSNumber *)userId
                                   nickName:(NSString *)nickName
                                     gender:(NSNumber *)gender
                                   birthday:(NSString *)birthday
                         headImageUrlString:(NSString *)headImageUrlString
                                       memo:(NSString *)memo
                                    success:(void (^)(BOOL success))success
                                    failure:(void (^)(NSError *))failure {

    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:userId forKey:@"userId"];
    
    [parameters addParameter:nickName forKey:@"nickName"];//昵称

    [parameters addParameter:birthday forKey:@"birthday"];//生日
    
    [parameters addParameter:headImageUrlString forKey:@"headImg"];//头像
    
    [parameters addParameter:gender forKey:@"gender"];//性别
    
    [parameters addParameter:memo forKey:@"memo"];//个人简介
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:SAVE_USER_INFORMATION
                                                 parameters:parameters
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                if (![Common isObjectNull:headImageUrlString]) {
                                                                    
                                                                    STUserAccountHandler.userProfile.headImg = headImageUrlString;
                                                                }
                                                                
                                                                if (![Common isObjectNull:gender]) {
                                                                    
                                                                    STUserAccountHandler.userProfile.gender = gender;
                                                                }
                                                                
                                                                if (![Common isObjectNull:birthday]) {
                                                                    
                                                                    STUserAccountHandler.userProfile.birthday = birthday;
                                                                }
                                                                
                                                                if (![Common isObjectNull:nickName]) {
                                                                    
                                                                    STUserAccountHandler.userProfile.nickName = nickName;
                                                                }
                                                                
                                                                if (![Common isObjectNull:memo]) {
                                                                    
                                                                    STUserAccountHandler.userProfile.memo = memo;
                                                                }

                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                    //发出通知
                                                                    [STNotificationCenter postNotificationName:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
                                                                });
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:recvDic[@"msg"]}];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(failureError);
                                                                    
                                                                });
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//************获取通讯录好友************/
+ (void)sendAddressBooklistRequestCompletionHandler:(void(^)(NSMutableArray *,NSMutableArray *,NSMutableArray *))handler {
    
    dispatch_async(dispatch_queue_create("AddressBookModel", DISPATCH_QUEUE_SERIAL), ^{
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        NSMutableArray *addressBookArray = [NSMutableArray array];
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                
                [STDataHandler copyAddressBook:addressBook addressBookArray:addressBookArray completionHandler:handler];
            });
            
        } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            
            [STDataHandler copyAddressBook:addressBook addressBookArray:addressBookArray completionHandler:handler];
            
        } else {
            
            //没有获取通讯录权限
        }
        
    });
}

//私有Api
+ (void)copyAddressBook:(ABAddressBookRef)addressBook addressBookArray:(NSMutableArray *)addressBookArray completionHandler:(void(^)(NSMutableArray *,NSMutableArray *,NSMutableArray *))handler {

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
            
            if ([personPhoneLabel isEqualToString:@"住宅"] || [personPhoneLabel isEqualToString:@"手机"] || [personPhoneLabel isEqualToString:@"工作"] || [personPhoneLabel isEqualToString:@"iPhone"] || [personPhoneLabel isEqualToString:@"电话"]) {
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
    
    NSMutableArray *arrayAll =  [ChineseString LetterSortArray:addressBookArray];
    
    NSMutableArray *sortArray = [ChineseString SortArray:addressBookArray];
    
    NSMutableArray *indexArray = [ChineseString IndexArray:addressBookArray];
    
   
    NSMutableArray *newArray = [NSMutableArray array];
    
    for (int a = 0; a < arrayAll.count; a++) {
        
        NSMutableArray *nextArray = arrayAll[a];
        
        NSMutableArray *fistNameArray = [NSMutableArray array];
        
        NSMutableArray *newNameArray = [NSMutableArray array];
        
        NSMutableArray *result = [NSMutableArray arrayWithArray:[nextArray sortedWithChineseKey:@"string"]];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        }];
        
        for (int i = 0; i < result.count; i++) {
            
            ChineseString *model = result[i];
            
            NSString *nameString = [model.string substringToIndex:1];
            
            if (![fistNameArray containsObject:nameString]) {
                
                [fistNameArray addObject:nameString];
            }
        }
        
        
        for (int i = 0; i < fistNameArray.count; i++) {
            
            for (int j = 0; j < result.count; j++) {
                
                ChineseString *model = result[j];
                
                NSString *nameString = [model.string substringToIndex:1];
                
                if ([nameString isEqualToString:fistNameArray[i]]) {
                    
                    [newNameArray addObject:result[j]];
                }
                
            }
            
        }
        
        [newArray addObject:newNameArray];
        
    }


    handler(newArray,sortArray,indexArray);
}

//私有api
//得到汉字py
- (NSString *)charactor:(NSString *)aString{
    NSMutableString *str = [NSMutableString stringWithString:aString];

    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);

    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);

    NSString *pinYin = [str capitalizedString];

    return pinYin;
}

//*************搜索某一个用户（里面装的SearchUserInformationModel）**********************/
+ (void)sendSearchUserRequestWithNickName:(NSString *)nickName
                                   currentUserId:(NSString *)curUserId
                                  success:(void(^)(NSMutableArray *))success
                                  failure:(void (^)(NSError *))failure {
    //内部测试接口
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:nickName forKey:@"keyWord"];
    
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
                    
                } else {
                    
                    NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:dictionary[@"msg"]}];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        failure(failureError);
                        
                    });
                }
              
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(firstError);
                    
                });
            }
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(error);
                
            });
        }
    });;
}

//************添加一个好友(currentUserId:当前用户的userId,userId:待添加的userId,messageType:消息类型 @1请求;@2接受;@3拒绝*************/
+ (void)sendPushMessageWithCurrentUserId:(NSNumber *)currentUserId
                                     userId:(NSNumber *)userId
                                messageType:(NSNumber *)messageType
                                    success:(void(^)(BOOL success))success
                                    failure:(void (^)(NSError *error))failure {
    
    //内部测试接口
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:currentUserId forKey:@"mobileOwnerId"];
    
    [parameters addParameter:userId forKey:@"friendOwnerId"];
    
    [parameters addParameter:messageType forKey:@"messageType"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendPushMessageWithCurrentUserId",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,ADD_USER] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                if ([recvDic[@"value"] isEqual:@1]) {
                    
                    success(YES);
                    
                }
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
    
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                self.getLocationErrorBlock(newError);
                
            });
        } else if (error != nil) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.getLocationErrorBlock(error);
                
            });
        }

    }];
    
}

//*****************获取天气情况(代码块返回的是天气模型)***********/
+ (void)getWeatherInformation:(NSString *)cityName
                       sucess:(void (^)(WeatherInformationModel *))sucess
                      failure:(void (^)(NSError *))failure {
    
    if (cityName != nil) {
        
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:cityName forKey:@"city"];
        
        NSString *method = @"post";
        
        APISCallBack *callBack = [APISCallBack alloc];
        
        callBack.onSuccess = ^(long status, NSString* responseString) {

            if(responseString != nil) {
                
                NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:nil];
                
                NSArray *sumArray = dictionary[@"HeWeather data service 3.0"];
                NSDictionary *sumDictionary = sumArray[0];
                
                NSDictionary *now = sumDictionary[@"now"];
                NSDictionary *aqi = sumDictionary[@"aqi"][@"city"];
                NSDictionary *suggestion = sumDictionary[@"suggestion"];
                
//              NSDictionary *basic = sumDictionary[@"basic"];
//              NSDictionary *suggestion = sumDictionary[@"suggestion"];
//              NSDictionary *hourly_forecast = sumDictionary[@"hourly_forecast"];
//              NSDictionary *status = sumDictionary[@"status"];
//              NSDictionary *daily_forecast = sumDictionary[@"daily_forecast"];
                
//              NSString *pm25 = aqi[@"pm25"];
                NSString *code = now[@"cond"][@"code"];
                NSString *tmp = now[@"tmp"];
                NSString *qlty = aqi[@"qlty"];
                NSString *sport = suggestion[@"sport"][@"txt"];
                
                
                WeatherInformationModel *informationModel = [[WeatherInformationModel alloc] init];

                informationModel.cityName = cityName;

                informationModel.temperatureString = [NSString stringWithFormat:@"%@℃",tmp];

                informationModel.pm25Quality = qlty;

                informationModel.weatherShowImageString = [NSString stringWithFormat:@"%@.png",code];
                
                informationModel.sport = sport;
                        
                dispatch_async(dispatch_get_main_queue(), ^{
                            
                            sucess(informationModel);
                            
                        });
                
                    }
                };

        callBack.onError = ^(long status, NSString *responseString) {
            
            
             NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:responseString}];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(failureError);
                
            });
            
        };
    
        callBack.onComplete = ^() {
        
        };
        
        //请求API
        [ApiStoreSDK executeWithURL:HfPath method:method apikey:HfKey parameter:parameter callBack:callBack];
        
    }
}

//**********获取用户的天龄(dataArray装的是UserLifeModel模型)**********************/
+ (void)sendUserLifeListWithCurrentUserId:(NSNumber *)currentUserId
                                   endDay:(NSString *)endDay//2016-02-19这种模式
                                dayNumber:(NSString *)dayNumber
                                  success:(void (^)(NSMutableArray *dataArray))success
                                  failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:currentUserId forKey:@"userId"];
    
    [parameters addParameter:endDay forKey:@"endDay"];
    
    [parameters addParameter:dayNumber forKey:@"day"];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendUserLifeList",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_USER_LIFE_LIST] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                NSMutableArray *array = [UserLifeModel mj_objectArrayWithKeyValuesArray:recvDic[@"value"]];
                
                success(array);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];

//   NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?userId=%@&endDay=%@day=%@",ST_API_SERVER,GET_USER_LIFE_LIST,currentUserId,endDay,dayNumber]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15];
//    
//   request.HTTPMethod = @"GET";
//    
//    NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
//    
//    [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        float q = 1.0f - (idx * 0.1f);
//        [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
//        *stop = q <= 0.5f;
//    }];
//    
//   [request setValue:[acceptLanguagesComponents componentsJoinedByString:@", "] forHTTPHeaderField:@"Accept-Language"];
//    
//   [request setValue:[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]] forHTTPHeaderField:@"User-Agent"];
//    
//   NSURLSession *sessin =  [NSURLSession sharedSession];
//    
//   NSURLSessionDataTask *task  = [sessin dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//       
//        NSThread *thread = [NSThread currentThread];
//        
//        NSLog(@"---%@--",thread.description);
//       
//        NSError *localError = nil;
//       
//       id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&localError];
//       if (localError == nil) {
//
//           NSDictionary *recvDic = (NSDictionary *)parsedObject;
//
//           if ([recvDic[@"code"] isEqualToNumber:@0]) {
//
//               NSMutableArray *array = [UserLifeModel mj_objectArrayWithKeyValuesArray:recvDic[@"value"]];
//
//               success(array);
//
//           } else {
//
//               NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
//
//               failure(failureError);
//           }
//           
//       } else {
//           
//           failure(localError);
//       }
//       
//    }];
//    
//    [task resume];
}

//***********获取健康因子(里面装的是GetFacotorModel数组)***************/
+ (void)sendGetFactors:(void (^)(NSMutableArray *dataArray))success
                  failure:(void (^)(NSError *error))failure {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_FACTORS] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                    
                NSArray *oldArray = recvDic[@"value"];
                
                NSMutableArray *newArray = [NSMutableArray array];
                
                for (int i = 0; i < oldArray.count ; i++) {
                    
                    NSDictionary *dictionary = oldArray[i];
                    
                    GetFactorModel *model = [GetFactorModel yy_modelWithDictionary:dictionary];
                    
                    [newArray addObject:model];
                }
                
                success(newArray);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:recvDic[@"msg"]}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

//***********获取某人的健康因子(里面装的是GetFacotorModel数组)***************/
+ (void)sendGetUserFactorsWithUserId:(NSNumber *)userId
                   factorsModelArray:(NSMutableArray *)factorsModelArray
                             success:(void (^)(NSMutableArray *dataArray))success
                             failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters addParameter:userId forKey:@"userId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendUserLifeList",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_USER_FACTORS] parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
                NSError *firstError;
    
                NSDictionary *dictionary_second = [jsonParser objectWithString:recvDic[@"value"] error:&firstError];
                
                if ([Common isObjectNull:firstError] && ![Common isObjectNull:dictionary_second]) {
                    
                    NSArray *oldArray = dictionary_second[@"idPid"];
                    
                    if (![Common isObjectNull:dictionary_second[@"passiveSmokeCount"]] && ![Common isObjectNull:dictionary_second[@"passiveSmokeYears"]]) {//被动吸烟数和年数要同时存在
                        
                        GetFactorModel *numberModel = factorsModelArray[factorsModelArray.count - 2];//被动吸烟根数
                        
                        GetFactorModel *yearModel = factorsModelArray[factorsModelArray.count - 1];//被动吸烟年数
                        
                        if ([dictionary_second[@"passiveSmokeCount"] isEqualToString:@"150"]) {
                            
                            numberModel.userSubFactorModel.factor = @"100以上";
                            
                        } else {
                            
                            numberModel.userSubFactorModel.factor = dictionary_second[@"passiveSmokeCount"];
                        }
                        
                        yearModel.userSubFactorModel.factor = dictionary_second[@"passiveSmokeYears"];
                    }
                    
                    if (![Common isObjectNull:dictionary_second[@"height"]] && ![Common isObjectNull:dictionary_second[@"weight"]]) {//身高和体重要同时存在
                        
                        GetFactorModel *heightModel = factorsModelArray[factorsModelArray.count - 4];//身高
                        
                        GetFactorModel *weightModel = factorsModelArray[factorsModelArray.count - 3];//体重
                        
                        heightModel.userSubFactorModel.factor = dictionary_second[@"height"];
                        
                        weightModel.userSubFactorModel.factor = dictionary_second[@"weight"];
                    }
                    
                    for (int i = 0; i < oldArray.count ; i++) {
                        
                        NSDictionary *_dictionary = oldArray[i];
                        
                        NSNumber *factorId = _dictionary[@"id"];
                        
                        NSNumber *keyNumber = _dictionary[@"pid"];
                        
                        GetFactorModel *model = [STDataHandler _factorModelWithFactorId:keyNumber FromfactorsModelArray:factorsModelArray];
                        
                        model.userSubFactorModel.factorId = factorId;
                        
                        model.userSubFactorModel.factor = [GetFactorModel titleStringWithDataNumber:factorId subFactorArray:model.subFactorArray];
                        
                        model.userSubFactorModel.pid = model.factorId;
                    }
                    
                    success(factorsModelArray);
                    
                } else {
                    
                    NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                    
                    failure(failureError);
                }
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:recvDic[@"msg"]}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}

+ (GetFactorModel *)_factorModelWithFactorId:(NSNumber *)factorId FromfactorsModelArray:(NSMutableArray *)factorsModelArray {
    
    if (!factorId || !factorsModelArray) {
        
        return nil;
    }
    
    for (GetFactorModel *model in factorsModelArray) {
        
        if ([model.factorId isEqualToNumber:factorId]) {
            
            return model;
        }
    }
    return nil;
}

//********保存某人健康因子到服务器(factorsModelArray存储的是GetFactorModel模型)*********************/
+ (void)sendSaveUserFactorsWithUserId:(NSNumber *)userId
                    factorsModelArray:(NSMutableArray *)factorsModelArray
                              success:(void (^)(NSString *dataString))success
                              failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [dataDictionary addParameter:STUserAccountHandler.userProfile.gender forKey:@"gender"];
    
    for (int i = 0; i < factorsModelArray.count - 3; i++) {
        
        GetFactorModel *factorModel = factorsModelArray[i];
        
        if (factorModel.userSubFactorModel.factorId) {
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            
            dictionary[@"id"] = factorModel.userSubFactorModel.factorId;
            
            dictionary[@"pid"] = factorModel.factorId;
            
            [dataArray addObject:dictionary];
        }
    }
#pragma mark --- 设置体重和身高
    GetFactorModel *heightModel = factorsModelArray[factorsModelArray.count - 4];//身高
    
    GetFactorModel *weightModel = factorsModelArray[factorsModelArray.count - 3];//体重
    
    GetFactorModel *numberModel = factorsModelArray[factorsModelArray.count - 2];//被动吸烟根数
    
    GetFactorModel *yearModel = factorsModelArray[factorsModelArray.count - 1];//被动吸烟年数
    
    if (![Common isObjectNull:heightModel.userSubFactorModel.factor] && ![Common isObjectNull:weightModel.userSubFactorModel.factor]) {
        
        [dataDictionary addParameter:heightModel.userSubFactorModel.factor forKey:@"height"];
        
        [dataDictionary addParameter:weightModel.userSubFactorModel.factor forKey:@"weight"];
    }
    
    if (![Common isObjectNull:numberModel.userSubFactorModel.factor] && ![Common isObjectNull:yearModel.userSubFactorModel.factor]) {
        
        if ([numberModel.userSubFactorModel.factor isEqualToString:@"100以上"]) {//特殊处理
            
            [dataDictionary addParameter:@"150" forKey:@"passiveSmokeCount"];
            
        } else {
            
            [dataDictionary addParameter:numberModel.userSubFactorModel.factor forKey:@"passiveSmokeYears"];
        }
        
        [dataDictionary addParameter:yearModel.userSubFactorModel.factor forKey:@"passiveSmokeYears"];
    }
    
    [dataDictionary addParameter:dataArray forKey:@"idPid"];
    
    NSString *dataString = [dataDictionary mj_JSONString];
    
    [params addParameter:dataString forKey:@"data"];
    
    [params addParameter:userId forKey:@"userId"];
    
    [Common urlStringWithDictionary:params withString:SAVE_USER_FACTORS];

    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:SAVE_USER_FACTORS
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                //当用户成功保存健康因子的时候会发出通知
                                                                [STNotificationCenter postNotificationName:STUserAccountHandlerUseProfileDidChangeNotification
                                                                                                                    object:nil];
                                                                
                                                                success(recvDic[@"value"][@"chgDays"]);
                                                                
                                                            } else {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:recvDic[@"msg"]}];
                                                                
                                                                failure(failureError);
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                           failure(localError);
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        failure(error.error);
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//***********************************更新用户头像*********************/
+ (void)sendUpdateUserHeadPortrait:(NSNumber *)userId
                        headImage:(UIImage *)image
                          success:(void (^)(NSString *imageUrl))success
                          failure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setHTTPShouldHandleCookies:NO];
    
    [request setTimeoutInterval:30];
    
    [request setHTTPMethod:@"POST"];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/stapi/upload/uploadFile",ST_API_SERVER]]];
    
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

//***********************************获取个人密保问题*********************/
+ (void)sendGetSecurityQuestion:(NSNumber *)userId
                       success:(void (^)(NSDictionary *dic))success
                       failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendGetSecurityQuestion",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_SECURITY_QUESTION] parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                NSDictionary *oldArray = recvDic[@"value"];
                
                success(oldArray);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}

//***********************************获取所有密保问题*********************/
+ (void)sendGetSecurityQuestionSum:(void (^)(NSArray *array))sucess
                           failure:(void (^)(NSError *error))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendUserLifeList",DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_SECURITY_QUESTION_SUM] parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSError *localError = nil;
        
        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
        if (localError == nil) {
            
            NSDictionary *recvDic = (NSDictionary *)parsedObject;
            
            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
                NSArray *oldArray = recvDic[@"value"];
                
                sucess(oldArray);
                
            } else {
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                
                failure(failureError);
            }
            
        } else {
            
            failure(localError);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        failure(error);
    }];
}


-(void)sendSecurityQuestionvalidate:(NSNumber *)userId
                            answer:(NSArray *)answerArr
                            success:(void (^)(NSString *successToken))success
                            failure:(void (^)(STNetError *error))failure{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    for (int i=0; i<answerArr.count; i++) {
        
        [params addParameter:answerArr[i] forKey:[NSString stringWithFormat:@"a%d",i+1]];
    }
    
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                                STNetError *error = [STNetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            STNetError *error = [STNetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(error);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

-(void)sendSecurityQuestionUptUserPwdBySecu:(NSNumber *)userId
                                      token:(NSString *)token
                                   password:(NSString *)password
                                    success:(void (^)(BOOL success))success
                                    failure:(void (^)(STNetError *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:token forKey:@"token"];
    [params addParameter:userId forKey:@"userId"];
    [params addParameter:password forKey:@"password"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_SECURITY_QUESTION_UPTUSERPWDBYSECU
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
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知原因"}];
                                                                
                                                                STNetError *error = [STNetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            STNetError *error = [STNetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                failure(error);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//***********************************修改密码*********************/
- (void)sendChangePasswordWithUserId:(NSNumber *)userId
                         oldPassword:(NSString *)oldPassword
                         newPassword:(NSString *)newPassword
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    [params addParameter:oldPassword forKey:@"oldPwd"];
    
    [params addParameter:newPassword forKey:@"newPwd"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

- (void)sendChangeSecurityWithUserId:(NSNumber *)userId
                 questionAnswerArray:(NSMutableArray *)modelArray
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    for (int i = 0; i < modelArray.count; i++) {
        
        QuestionAnswerModel *model = modelArray[i];
        
        [params addParameter:model.questionId forKey:[NSString stringWithFormat:@"q%d",i+1]];
        
        [params addParameter:model.answerString forKey:[NSString stringWithFormat:@"a%d",i+1]];
    }
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

- (void)sendStatUserLifeWithUserId:(NSNumber *)userId
                        dataString:(NSString *)data
                           success:(void (^)(BOOL success))success
                           failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    [params addParameter:data forKey:@"data"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
    
}

-(void)sendUploadUserSendEmailWithUserId:(NSNumber *)userId
                             emailString:(NSString *)email
                                 success:(void (^)(BOOL))success
                                 failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    [params addParameter:email forKey:@"email"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}


-(void)sendVerificationUserEmailWithUserId:(NSNumber *)userId
                                   success:(void (^)(NSDictionary *verificationDictionary))success
                                   failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*********************************获取商家详细的数据*******************/
- (void)sendCompanyDetailsWithProductId:(NSString *)productId
                                    Success:(void (^)(ShopDetailModel *model))success
                                    failure:(void (^)(NSError *error))failure{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params addParameter:productId forKey:@"productId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_COMPANYDETAILS
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary * dataDictionary = recvDic[@"value"];
                                                                
                                                                ShopDetailModel *model = [ShopDetailModel yy_modelWithDictionary:dataDictionary];

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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*********************************获取城市地铁数据*******************/
- (void)sendCitySubWayWithCityId:(NSString *)cityId
                         Success:(void (^)(NSMutableArray *))success
                         failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
    [params addParameter:cityId forKey:@"citySign"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
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
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                    
                                                                    ShopModel *model = [ShopModel yy_modelWithDictionary:dictionary];
                                                                    
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
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
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
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });

                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
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
    
    [params addParameter:productId forKey:@"productId"];
    
    if (type != -1) {
        
        [params setObject:@(type) forKey:@"type"];
        
    }

    [params addParameter:userId forKey:@"userId"];

    [params addParameter:remark forKey:@"remark"];
    
    if (numberStar != -1) {
        
        [params setObject:@(numberStar) forKey:@"numberStar"];
        
    }
    
    [params addParameter:picUrl forKey:@"picUrl"];

    [params addParameter:pId forKey:@"pId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
    
    

}

//*********************************点赞*************************/
- (void)sendPointPraiseOrCancelWithCommentId:(NSString *)commentId
                                 isClickLike:(BOOL)isClickLike
                                     Success:(void (^)(BOOL))success
                                     failure:(void (^)(NSError *))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:commentId forKey:@"commentId"];
    
    [params setObject:@(isClickLike) forKey:@"isClickLike"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
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
                                                                    
                                                                    failure(localError);
                                                                    
                                                                });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
    
    
}

//*********************************商品详情评论*************************/
- (void)sendDefaultCommentWithBusiId:(NSNumber *)busiId
                             Success:(void (^)(NSMutableArray *success))success
                             failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
    [params setObject:busiId forKey:@"busiId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:SAVE_FINDDEFAUITCOMMWNT_COUNT
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
                                                                    
                                                                    InformationCommentModel *commentModel = [[InformationCommentModel alloc] init];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*********************************店长推荐*************************/
- (void)sendShopOwnerRecommendWithCompanyId:(NSString *)companyId
                                      count:(NSInteger)count
                                    Success:(void (^)(NSMutableArray *success))success
                                    failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:companyId forKey:@"companyId"];
    
    [params setObject:@(count) forKey:@"count"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_SHOPOWNERRECOMMEND
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
                                                                    
                                                                    ShopModel *commentModel = [ShopModel yy_modelWithDictionary:dictionary];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//*********************************平台推荐*************************/
- (void)sendPlatformRecommendWithProductTypeId:(NSString *)ProductTypeId
                                         count:(NSInteger)count
                                       Success:(void (^)(NSMutableArray *success))success
                                       failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:ProductTypeId forKey:@"productTypeId"];
    
    [params setObject:@(count) forKey:@"count"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_PLATFORMRECOMMEND
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
                                                                    
                                                                    ShopModel *commentModel = [ShopModel yy_modelWithDictionary:dictionary];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];


}

- (void)sendfindCompanyInfoByIdWithCompanyId:(NSString *)companyId
                                     Success:(void (^)(CompanyModel *success))success
                                     failure:(void (^)(NSError *error))failure {

    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:companyId forKey:@"companyId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_FINDCOMOANYINFO
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary * dataDictionary = recvDic[@"value"];
                                                                
                                                                CompanyModel *companyModel = [[CompanyModel alloc] init];
                                                                
                                                                [companyModel setValuesForKeysWithDictionary:dataDictionary];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(companyModel);
                                                                    
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
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//*********************************商店下的商品*************************/
- (void)sendFindProductsByIdsWithCompanyId:(NSString *)companyId
                             productTypeId:(NSString *)productTypeId
                                   Success:(void (^)(NSMutableArray *success))success
                                   failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:companyId forKey:@"companyId"];
    
    [params addParameter:productTypeId forKey:@"productTypeId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_FINDPRODUCTSBYIDS
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
                                                                    
                                                                    ShopModel *commentModel = [ShopModel yy_modelWithDictionary:dictionary];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*********************************获取可预约的场地*************************/
- (void)sendFindOrderCanAppointmentWithUserId:(NSNumber *)userId
                                    productId:(NSNumber *)productId
                                         date:(NSString *)date
                                      Success:(void (^)(NSMutableArray *success))success
                                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:@8 forKey:@"productId"];
    
    [params addParameter:date forKey:@"date"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_ORDER_SEARCH_COUNT
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
                                                                    
                                                                    AppointmentModel *commentModel = [AppointmentModel yy_modelWithDictionary:dictionary];
                                                                
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*********************************提交订单*************************/
- (void)sendCommitOrderWithUserId:(NSNumber *)userId
                        productId:(NSNumber *)productId
                      contactName:(NSString *)contactName
                      contactPhoneNumber:(NSString *)contactPhoneNumber
                             date:(NSString *)date
                           remark:(NSString *)remark
                        uniqueKeyArray:(NSMutableArray *)timeModelArray
                    payableAmount:(NSString *)price
                          Success:(void (^)(NSString *orderNumber))success
                          failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    [params addParameter:productId forKey:@"productId"];
    
    [params addParameter:date forKey:@"date"];
    
    [params addParameter:contactName forKey:@"reserverName"];
    
    [params addParameter:contactPhoneNumber forKey:@"reserverContactNo"];
    
    [params addParameter:remark forKey:@"memo"];
    
    if (timeModelArray.count) {
        
        NSString *arrayString = [self arrayStringWithTimeModeArray:timeModelArray];
        
        [params addParameter:[self dictionaryString:arrayString] forKey:@"courtJsonStr"];
        
    }
    
    [params addParameter:price forKey:@"payableAmount"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:COMMIT_ORDER_COURTS
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}


//用uniqueKeyString得到{\"uniqueKey\":\"A01Y010012016040109001000\"}
- (NSString *)dictionaryStringWithTimeModel:(AppointmentTimeModel *)timeModel {
    
    return [NSString stringWithFormat:@"{\"uniqueKey\":\"%@\",\"price\":\"%@\"}",timeModel.uniqueKey,timeModel.price];
}

//用uniqueKeyArray得到[{\"uniqueKey\":\"A01Y010012016040109001000\"},{\"uniqueKey\":\"A01Y010022016040109001000\"},{\"uniqueKey\":\"A01Y010032016040109001000\"]

- (NSString *)arrayStringWithTimeModeArray:(NSMutableArray *)timeModelArray {
    
    NSString *arrayString = @"";
    
    for (int i = 0 ; i < timeModelArray.count; i++) {
        
        AppointmentTimeModel *timeModel = timeModelArray[i];
        
        if (timeModelArray.count == 1) {//表示数组只有一个
            
            arrayString = [NSString stringWithFormat:@"[%@]",[self dictionaryStringWithTimeModel:timeModel]];
            
        } else {
            
            NSString *dictionaryString = [self dictionaryStringWithTimeModel:timeModel];
            
            if (i == 0) {//第一个
                
                arrayString = [NSString stringWithFormat:@"[%@,",dictionaryString];
                
            } else if (i == timeModelArray.count - 1) {//等于最后一个
                
                arrayString = [arrayString stringByAppendingString:[NSString stringWithFormat:@"%@]",dictionaryString]];
                
            } else {
                
                arrayString = [arrayString stringByAppendingString:[NSString stringWithFormat:@"%@,",dictionaryString]];
            }
        }
    }
    
    return arrayString;
}

//用uniqueKeyString得到{\"uniqueKey\":\"A01Y010012016040109001000\"}
- (NSString *)dictionaryString:(NSString *)key {
    
    return [NSString stringWithFormat:@"{\"json\":%@}",key];
}

//*********************************计算价格*************************/
- (void)sendCalculateWithProductId:(NSNumber *)productId
                    uniqueKeyArray:(NSMutableArray *)timeModelArray
                           Success:(void (^)(PriceModel *model))success
                           failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params addParameter:productId forKey:@"productId"];
    
    if (timeModelArray.count) {
        
        NSString *arrayString = [self arrayStringWithTimeModeArray:timeModelArray];
        
        [params setObject:[self dictionaryString:arrayString] forKey:@"courtJsonStr"];
        
    }
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:CALCULATE_PRICE
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                PriceModel *model = [PriceModel yy_modelWithDictionary:recvDic[@"value"]];
                                                                
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}


//**************根据类型获取订单 0->表示全部类型 1->表示已付款 2->表示未付款 返回数组里装的是MyOrderModel************/
- (void)sendFindOrderUserId:(NSNumber *)userId
                       type:(NSNumber *)type
                    success:(void (^)(NSMutableArray *success))success
                    failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    [params addParameter:type forKey:@"orderStatus"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_ORDER_LIST
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
                                                                    
                                                                    MyOrderModel *orderModel = [MyOrderModel yy_modelWithDictionary:dictionary];
                                                                    
                                                                    [dataArray addObject:orderModel];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//**************根据类型获取订单，返回的是MyOrderDetailModel************/
- (void)sendFindOrderDetailOrderNumber:(NSString *)orderNumber
                               success:(void (^)(MyOrderDetailModel *detailModel))success
                               failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(![Common isObjectNull:orderNumber]) {
        
        [params setObject:orderNumber forKey:@"orderNo"];
        
    }

    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_ORDER_DETAIL
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary *dictionary = recvDic[@"value"];
                                                                
                                                                MyOrderDetailModel *orderModel = [MyOrderDetailModel yy_modelWithDictionary:dictionary];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(orderModel);
                                                                    
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
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************根据类型查资讯************/
- (void)sendsearchInfomationsWithWriterId:(NSString *)writerId
                             infoTypeCode:(NSString *)infoTypeCode
                                 sortType:(NSInteger)sortType
                                  success:(void (^)(NSMutableArray *success))success
                                  failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:writerId forKey:@"writerId"];
    
    [params addParameter:infoTypeCode forKey:@"infoTypeCode"];
    
    [params setObject:@(sortType) forKey:@"sortType"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_SEARCH_MATIONS
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
                                                                    
                                                                    InformationModel *informationModel = [[InformationModel alloc] init];
                                                                    
                                                                    [informationModel setValuesForKeysWithDictionary:dictionary];
                                                                    
                                                                    [dataArray addObject:informationModel];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];



}
//**************取消订单************/
- (void)sendCancelOrderWithOrderNumber:(NSString *)orderNumber
                               success:(void (^)(BOOL success))success
                               failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (![Common isObjectNull:orderNumber]) {
        
        [params setObject:orderNumber forKey:@"orderNo"];
    }
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_ORDER_CANCEL
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    //成功取消订单发出通知
                                                                    [STNotificationCenter postNotificationName:STDidSuccessPaySendNotification object:nil];
                                                                    
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
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************资讯点赞*********************/
- (void)sendPointOrCancelPraiseWithUserId:(NSNumber *)userId
                                   busiId:(NSString *)busiId
                              isClickLike:(NSInteger)isClickLike
                                 busiType:(NSInteger)busiType
                                  success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params addParameter:busiId forKey:@"busiId"];
    
    [params setObject:@(isClickLike) forKey:@"isClickLike"];
    
    [params setObject:@(busiType) forKey:@"busiType"];

    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:SAVE_POINT
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************作者主页*********************/
- (void)senSearchWriterInfomationsWithWriterId:(NSString *)writerId
                                        userId:(NSString *)userId
                                       success:(void (^)(InformationWriterModel *success))success
                                       failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    [params addParameter:writerId forKey:@"writerId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_SEARCH_WRITER
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                             NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary * dataDictionary = recvDic[@"value"];
                                                                
                                                                InformationWriterModel *informationWriterModel = [[InformationWriterModel alloc] init];
                                                                
                                                                [informationWriterModel setValuesForKeysWithDictionary:dataDictionary];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(informationWriterModel);
                                                                    
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
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************订阅*********************/
- (void)sendSubscribeWithWriterId:(NSString *)writerId
                           userId:(NSString *)userId
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:writerId forKey:@"writerId"];
    
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:COMMIT_SUBSCRIBE
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//*****************************************取消订阅*********************/
- (void)sendCancelSubscribeWriterId:(NSString *)writerId
                             userId:(NSString *)userId
                            success:(void (^)(BOOL success))success
                            failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:writerId forKey:@"writerId"];
    
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:COMMIT_CANCEL_SUBSCRIBE
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//*****************************************我的订阅*********************/
- (void)sendMySubscribeWithUserId:(NSString *)userId
                          success:(void (^)(NSMutableArray *success))success
                          failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_MY_SUBSCRIBE
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
                                                                    
                                                                    InformationWriterModel *informationModel = [[InformationWriterModel alloc] init];
                                                                    
                                                                    [informationModel setValuesForKeysWithDictionary:dictionary];
                                                                    
                                                                    informationModel.isMineSubscribe = 1;
                                                                    
                                                                    [dataArray addObject:informationModel];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************根据userId来获取个人信息模型*********************/
- (void)sendUserInformtionWithUserId:(NSNumber *)userId
                             success:(void (^)(UserInformationModel *model))success
                             failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_USER_INFORMATION
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary *dictionary = recvDic[@"value"];
                                                                
                                                                UserInformationModel *model = [UserInformationModel yy_modelWithDictionary:dictionary];
                                                                
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************查找作者*********************/
- (void)sendSearchWriterListWithWriterName:(NSString *)writerName
                                    userId:(NSString *)userId
                                   success:(void (^)(NSMutableArray *success))success
                                   failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:writerName forKey:@"writerName"];
    
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_SEARCH_WRITER_LIST
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
                                                                    
                                                                    InformationWriterModel *informationModel = [[InformationWriterModel alloc] init];
                                                                    
                                                                    [informationModel setValuesForKeysWithDictionary:dictionary];
                                                                    
                                                                    [dataArray addObject:informationModel];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************获取评论*********************/
- (void)sendSearchCommentsWithBusiId:(NSInteger)busiId
                            busiType:(NSInteger)busiType
                                 pid:(NSInteger)pid
                              userId:(NSInteger)userId
                         commentType:(NSInteger)commentType
                             success:(void (^)(NSMutableArray *success))success
                             failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(busiId) forKey:@"busiId"];
        
    [params setObject:@(busiType) forKey:@"busiType"];
    
    [params setObject:@(pid) forKey:@"pid"];
    
    [params setObject:@(userId) forKey:@"userId"];
    
    [params setObject:@(commentType) forKey:@"commentType"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_COMMENTS
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
                                                                    
                                                                    InformationCommentModel *commentModel = [[InformationCommentModel alloc] init];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//*****************************************资讯详情*********************/
- (void)getInfomationDetailWithInfoId:(NSNumber *)infoId
                               userId:(NSNumber *)userId
                              success:(void (^)(InformationDetails *success))success
                              failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params addParameter:infoId forKey:@"infoId"];
        
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_INFOMATION_DETAIL
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSDictionary *dictionary = recvDic[@"value"];
                                                                
                                                                InformationDetails *model = [[InformationDetails alloc] init];
                                                                
                                                                [model setValuesForKeysWithDictionary:dictionary];

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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];


}

//*****************************************评论*********************/
- (void)sendSaveCommentWithBusiId:(NSInteger)busiId
                         busiType:(NSInteger)busiType
                           userId:(NSInteger)userId
                           remark:(NSString *)remark
                              pid:(NSInteger)pid
                       isHideName:(BOOL)isHideName
                       numberStar:(NSInteger)numberStar
                    commentPhotos:(NSString *)commentPhotos
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(busiId) forKey:@"busiId"];
    
    [params setObject:@(busiType) forKey:@"busiType"];
    
    [params setObject:@(userId) forKey:@"userId"];

    [params addParameter:remark forKey:@"remark"];
    
    [params setObject:@(pid) forKey:@"pid"];
    
    [params setObject:@(isHideName) forKey:@"isHideName"];

    [params addParameter:commentPhotos forKey:@"commentPhotos"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:SAVE_COMMENT_SUM
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];

}

//*****************************************根据类型获取订阅作者*********************/
- (void)sendWriterListWithUserId:(NSNumber *)userId
                    suscribeType:(NSString *)suscribeType
                         success:(void (^)(NSMutableArray *dataArray))success
                         failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];

    [params addParameter:suscribeType forKey:@"suscribeType"];

    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_WRITER_LIST
                                                 parameters:params
                                                    success:^(id responseObject) {

                                                        NSError *localError = nil;

                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];

                                                        if (localError == nil) {

                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;

                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSArray *array = recvDic[@"value"];
                                                                
                                                                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                                                                
                                                                for (int i = 0; i < array.count; i++) {
                                                                    
                                                                    NSDictionary *dictionary = array[i];
                                                                    
                                                                    InformationWriterModel *model = [InformationWriterModel yy_modelWithDictionary:dictionary];
                                                                    
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

                                                                failure(localError);

                                                            });

                                                        }

                                                    } failure:^(STNetError *error) {

                                                        dispatch_async(dispatch_get_main_queue(), ^{

                                                            failure(error.error);
                                                        });

                                                    }];
    request.needHeaderAuthorization = NO;

    request.requestSerializerType = STRequestSerializerTypeJSON;

    [self startRequest:request];
}

//*****************************************上传商品评论图片*********************/
- (void)sendUploadImagesWithUserId:(NSInteger)userId
                              type:(NSInteger)type
                        imageArray:(NSArray *)imageArray
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@(userId) forKey:@"userId"];
    
    [params setObject:@(type) forKey:@"type"];
    
    NSMutableArray *base64ImageArray = [NSMutableArray array];
    
    for (int i = 0; i < imageArray.count; i++) {
        
        NSMutableDictionary *base64ImageDic = [NSMutableDictionary dictionary];
        UIImage *image = imageArray[i];
        NSData *data = UIImageJPEGRepresentation(image, 0.3f);
        NSString *encodedImageStr = [data base64Encoding];
        [base64ImageDic setObject:encodedImageStr forKey:@"base64Str"];
        [base64ImageArray addObject:base64ImageDic];
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:base64ImageArray forKey:@"json"];
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString *file = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSLog(@"图片上传error：%@",parseError.userInfo);
    
    [params setObject:file forKey:@"file"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url = @"http://121.196.223.175:8081/stapi/upload/uploadImages";
    
    [manager POST:url parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *recvDic = (NSDictionary *)parsedObject;

        if ([recvDic[@"code"] isEqualToNumber:@0]) {

            NSString *imageUrl = recvDic[@"value"];
            
            dispatch_async(dispatch_get_main_queue(), ^{

                success(imageUrl);
            });

        } else {

            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];

            dispatch_async(dispatch_get_main_queue(), ^{

                failure(failureError);

            });
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{

            failure(error);

        });
        
    }];
}

//*****************************************获取击败人数数据*********************/
+ (void)sendGetDefeatDataWithUserId:(NSNumber *)userId
                            success:(void (^)(NSString *dataString))success
                            failure:(void (^)(NSError *error))failure {
    
     NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.completionQueue = dispatch_queue_create("sendGetDefeatData", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_DEFEAT_DATA] parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *recvDic = (NSDictionary *)parsedObject;
        
        if ([recvDic[@"code"] isEqualToNumber:@0]) {
                
            success(recvDic[@"value"]);
            
        } else {
            
            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
            
             failure(failureError);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];
}

//*****************************************检查是否已绑定*********************/
- (void)sendcheckBindWithAccountNo:(NSString *)accountNo
                              type:(NSString *)type
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:accountNo forKey:@"accountNo"];
    
    [params addParameter:type forKey:@"type"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_CHECKBIND
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************绑定注册*********************/
- (void)sendBindRegisterWithMobile:(NSString *)mobile
                          nickName:(NSString *)nickName
                         accountNo:(NSString *)accountNo
                          password:(NSString *)password
                           headImg:(NSString *)headImg
                              type:(NSString *)type
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:mobile forKey:@"mobile"];
    
    [params addParameter:nickName forKey:@"nickName"];
    
    [params addParameter:accountNo forKey:@"accountNo"];
    
    [params addParameter:password forKey:@"password"];
    
    [params addParameter:headImg forKey:@"headImg"];
    
    [params addParameter:type forKey:@"type"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:SAVE_BIND_REGISTER
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************更新好友好友信息*********************/
- (void)sendUpdateFriendInformationWithUserId:(NSNumber *)userId
                                   friendUserId:(NSNumber *)friendUserId
                               friendNickName:(NSString *)friendNickName
                     friendHeadImageUrlString:(NSString *)friendHeadImageUrlString
                                        success:(void (^)(BOOL success))success
                                        failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"curUserId"];
    
    [params addParameter:friendUserId forKey:@"fUserId"];
    
    [params addParameter:friendNickName forKey:@"nickName"];
    
    [params addParameter:friendHeadImageUrlString forKey:@"headImg"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:UPDATE_FRIEND
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                    
                                                                    //成功的更新好友信息发出的通知
                                                                    [STNotificationCenter postNotificationName:STDidSuccessUpdateFriendInformationSendNotification object:nil];
                                                                    
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
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************检查是否已注册*********************/
- (void)sendCheckRegisterForThirdParyWithAccountNo:(NSString *)accountNo
                                           success:(void (^)(NSString *success))success
                                           failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:accountNo forKey:@"accountNo"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:CHECK_REGISTER
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************注册第三方登录账号*********************/
- (void)sendRegisterForThirdParyWithAccountNo:(NSString *)accountNo
                                     nickName:(NSString *)nickName
                                      headImg:(NSString *)headImg
                                      success:(void (^)(NSString *success))success
                                      failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:accountNo forKey:@"accountNo"];
    
    [params addParameter:nickName forKey:@"nickName"];
    
    [params addParameter:headImg forKey:@"headImg"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:REGIST_THIRDPARY
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************检查手机号是否已经注册*********************/
- (void)sendcheckRegisterForMobileWithmobile:(NSString *)mobile
                                     success:(void (^)(NSString *success))success
                                     failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:mobile forKey:@"mobile"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:CHECK_MOBILE
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************检测通讯录*********************/
+ (void)sendcheckAddressBookWithMobileOwnerId:(NSString *)mobileOwnerId
                              addressBookJson:(NSString *)addressBookJson
                                      success:(void (^)(NSArray *addressArray))success
                                      failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:mobileOwnerId forKey:@"mobileOwnerId"];
    
    [params addParameter:addressBookJson forKey:@"addressBookJson"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,CHECK_ADDRESS_BOOK] parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *recvDic = (NSDictionary *)parsedObject;
        
        if ([recvDic[@"code"] isEqualToNumber:@0]) {

            NSArray *array = recvDic[@"value"];
            
            success(array);
    
        } else {
            
            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
            
           failure(failureError);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       failure(error);
        
    }];
}


//*****************************************获取用户天龄下降因素*********************/
- (void)sendLifeDescendFactorsWithUserId:(NSNumber *)userId
                                 success:(void (^)(NSArray *addressArray))success
                                 failure:(void (^)(NSError *error))failure {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    STApiRequest *request = [STApiRequest requestWithMethod:STRequestMethodGet
                                                        url:GET_DESCEND_FACTORS
                                                 parameters:params
                                                    success:^(id responseObject) {
                                                        
                                                        NSError *localError = nil;
                                                        
                                                        id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
                                                        
                                                        if (localError == nil) {
                                                            
                                                            NSDictionary *recvDic = (NSDictionary *)parsedObject;
                                                            
                                                            if ([recvDic[@"code"] isEqualToNumber:@0]) {
                                                                
                                                                NSArray *array = recvDic[@"value"];
                                                                
                                                                NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                                                                
                                                                for (int i = 0; i < array.count; i++) {
                                                                    
                                                                    NSDictionary *dictionary = array[i];
                                                                    
                                                                    LifeDescendFactorsModel *model = [[LifeDescendFactorsModel alloc] init];
                                                                    
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
                                                                
                                                                failure(localError);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(STNetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error.error);
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = STRequestSerializerTypeJSON;
    
    [self startRequest:request];
}

//*****************************************获取免责条款及协议*********************/
+ (void)sendGetAgreement:(void (^)(NSString *urlString))success
                 failure:(void (^)(NSError *error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,GET_AGREEMENT] parameters:nil  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *recvDic = (NSDictionary *)parsedObject;
        
        if ([recvDic[@"code"] isEqualToNumber:@0]) {
            
            success(recvDic[@"value"]);
            
        } else {
            
            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
            
            failure(failureError);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];


}

//*****************************************获取免责条款及协议*********************/
+ (void)sendCheckPasswordWithUserId:(NSNumber *)userId
                           password:(NSString *)password
                            success:(void (^)(BOOL success))success
                            failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params addParameter:userId forKey:@"userId"];
    
    [params addParameter:password forKey:@"password"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@%@",ST_API_SERVER,@"/stapi/user/checkPassword"] parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *recvDic = (NSDictionary *)parsedObject;
        
        if ([recvDic[@"code"] isEqualToNumber:@0]) {
            
            success([recvDic[@"value"] boolValue]);
            
        } else {
            
            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
            
            failure(failureError);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
        
    }];

}

@end
