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
#import "FriendListInfo.h"

#import "AddressBookModel.h"
#import "ChineseString.h"
#import "WeatherInformationModel.h"
#import "UserInformationModel.h"
#import "UserLifeModel.h"
#import "GetFactorModel.h"

#import "AFNetworking.h"
//电话簿
#import <AddressBook/AddressBook.h>

//定位头文件
#import <CoreLocation/CoreLocation.h>

//聚合头文件
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"

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

@property (nonatomic,copy) void (^(getLocationBlock))(NSString *);//获取地理位置和城市名称的回调代码块

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
                               success:(void (^)(NSString *responseObject))success
                               failure:(void (^)(NSString *error))failure {
    
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        
        [parameters addParameter:phoneNumber forKey:@"mobile"];
    
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

//***** 普通登录 *****/
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(LONetError *))failure {
    
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
                                                                [self setUserInformationWithDictionary:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary] userName:loginName password:password];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    success(YES);
                                                                   
                                                                });
                                                                
                                                            } else {
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                            }
                                                            
                                                           
                                                            
                                                        } else {
                                                            
                                                            LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                               failure(error);
                                                                
                                                            });
                                                            
                                                        }
                                                        
                                                    } failure:^(LONetError *error) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                            failure(error);
                                                            
                                                        });
                                                        
                                                    }];
    request.needHeaderAuthorization = NO;
    
    request.requestSerializerType = LORequestSerializerTypeJSON;
    
    return [self startRequest:request];
}


//私有api设置个人信息
- (void)setUserInformationWithDictionary:(NSMutableDictionary *)jsonDictionary userName:(NSString *)userName password:(NSString *)password {
    
    UserProfile *userProfile = [[UserProfile alloc] init];
    
    [userProfile setValuesForKeysWithDictionary:jsonDictionary];
    
    STUserAccountHandler.userProfile = userProfile;
    
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
            
            userAccountDictionary = userAccountArray[i];
            
            if ([[userAccountDictionary objectForKey:KEY_SIGNIN_USER_NAME] isEqualToString:userName] && [[userAccountDictionary objectForKey:KEY_SIGNIN_USER_PASSWORD] isEqualToString:password]) {
                
                isExist = YES;
                
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
    
    //登录的时候进行发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:UserAccountHandlerUseProfileDidChangeNotification object:STUserAccountHandler.userProfile];
    
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
                                                                [self setUserInformationWithDictionary:[NSMutableDictionary dictionaryWithDictionary:jsonDictionary] userName:phoneNumber password:password];
                                                                
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
                                                                
                                                                NSMutableArray *array = [UserInformationModel mj_objectArrayWithKeyValuesArray:recvDic[@"value"]];
                                                                
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
    
    [parameters addParameter:gender forKey:@"gender"];
    
    [parameters addParameter:birthday forKey:@"birthday"];
    
    [parameters addParameter:headImageUrlString forKey:@"headImg"];
    
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
                                                                    //发出通知
                                                                    [STNotificationCenter postNotificationName:UserAccountHandlerUseProfileDidChangeNotification object:nil];
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
                                  failure:(void (^)(LONetError *))failure {
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
                
                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}];
                
                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(error);
                    
                });
            }
            
        } else {
            
            NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"出现了未知因素"}];
            
            LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
            
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
                                    failure:(void (^)(LONetError *error))failure {
    //内部测试接口
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters addParameter:currentUserId forKey:@"curUserId"];
    
    [parameters addParameter:userId forKey:@"fUserId"];
    
    [Common urlStringWithDictionary:parameters withString:ADD_USER];
    
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
                                                                        [[NSNotificationCenter defaultCenter] postNotificationName:UserAddFriendsSuccessPostNotification object:nil];
                                                                        
                                                                    } else {
                                                                        
                                                                        LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                        
                                                                        failure(error);
                                                                    }
                                                                    
                                                                });
                                                            } else if ([recvDic[@"code"] isEqualToNumber:@1014]) {
                                                                
                                                                NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:@"不能添加自己为好友"}];
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:failureError];
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    
                                                                    failure(error);
                                                                    
                                                                });
                                                                
                                                            }
                                                            
                                                        } else {
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                LONetError *error = [LONetError errorWithAFHTTPRequestOperation:nil NSError:localError];
                                                                
                                                                failure(error);
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


//***************开始定位操作********************/
- (void)startFindLocationSucess:(void (^)(NSString *))sucess
                        failure:(void (^)(NSError *))failure {
    
    
    self.getLocationBlock = sucess;
    
    self.getLocationErrorBlock = failure;
    
    // 判断定位操作是否被允许
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init] ;
        
        self.locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter = 100;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            [_locationManager requestWhenInUseAuthorization];
            
        }
        
    } else {
        
        //提示用户无法进行定位操作  Product
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"开启定位功能可查看天气噢！"
                                                          delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }

    //开始定位
    [_locationManager startUpdatingLocation];
}

#pragma ---
#pragma mark --- CLLocationManagerDelegate
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
            
            //将获得的所有信息显示到label上
            NSString *city = placemark.locality;
            
            if (!city) {
                
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (![Common isObjectNull:city]) {
                    
                    self.getLocationBlock(city);//回调
                    
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
        
        NSDictionary *param = @{ @"cityname" : cityName};
        
        JHAPISDK *jhapi = [JHAPISDK shareJHAPISDK];
        
        [jhapi executeWorkWithAPI:jhPath
                            APIID:jhAppID
                       Parameters:param
                           Method:jhMethod
                          Success:^(id responseObject) {
                              
                              if ([[responseObject valueForKey:@"result"] isKindOfClass:[NSNull class]]) return;
                              
                              NSString *getCityName = [[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"city_name"];
                              
                              NSString *img = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"realtime"] valueForKey:@"weather"] valueForKey:@"img"];
                              
                              if (![img isKindOfClass:[NSNull class]]) {
                                  
                                  if ([img intValue] < 10) {
                                      
                                      img = [NSString stringWithFormat:@"0%@",img];
                                  }
                              }
                              
                              NSString *maxTem = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"][0] valueForKey:@"info"] valueForKey:@"day"][2];
                              
                              NSString *minTem = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"weather"][0] valueForKey:@"info"] valueForKey:@"night"][2];
                              
//                              NSString *pm25 = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"curPm"];
                              
                              NSString *pm25Index = [[[[[responseObject valueForKey:@"result"] valueForKey:@"data"] valueForKey:@"pm25"] valueForKey:@"pm25"] valueForKey:@"quality"];
                              
                              WeatherInformationModel *informationModel = [[WeatherInformationModel alloc] init];
                              
                              informationModel.cityName = getCityName;
                              
                              informationModel.temperatureString = [NSString stringWithFormat:@"%@ ~ %@ ℃",maxTem,minTem];
                              
                              informationModel.pm25Quality = pm25Index;
                              
                              informationModel.weatherShowImageString = [NSString stringWithFormat:@"%@.png",img];

                              dispatch_async(dispatch_get_main_queue(), ^{
                                 
                                  sucess(informationModel);
                                  
                              });
                          }
         
                          Failure:^(NSError *error) {
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  failure(error);
                                  
                              });
                              
                          }];
    }
}

//**********获取用户的天龄(dataArray装的是UserLifeModel模型)**********************/
- (void)sendUserLifeListWithCurrentUserId:(NSString *)currentUserId
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
                                                                    
                                                                    model.data = dictionary[@"data"];
                                                                    
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
                                                                        
                                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                                            
                                                                            failure(error);
                                                                            
                                                                        });
                                                                        
                                                                    }];
                                                                    
                                                                } failure:^(LONetError *error) {
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        
                                                                        failure(error);
                                                                        
                                                                    });
                                                                    
                                                                }];
                                                                
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
                                                                    
                                                                    int j = [dictionary[@"id"] intValue] - 1;
                                                                    
                                                                    if ( j >= 0 ) {
                                                                        
                                                                        GetFactorModel *factorModel = factorsArray[j];
                                                                        
                                                                        SubFactorModel *subModel = [[SubFactorModel alloc] init];
                                                                        
                                                                        subModel.title = dictionary[@"title"];
                                                                        
                                                                        subModel.factorId = dictionary[@"id"];
                                                                        
                                                                        subModel.data = dictionary[@"data"];
                                                                        
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
- (void)sendGetUserFactorsWithUserId:(NSString *)userId
                   factorsModelArray:(NSMutableArray *)factorsModelArray
                             success:(void (^)(NSMutableArray *dataArray))success
                             failure:(void (^)(LONetError *error))failure {
    //异步执行
    dispatch_async(dispatch_queue_create("saveUserFactores", DISPATCH_QUEUE_SERIAL), ^{
        
        NSString *url = [NSString stringWithFormat:@"http://192.168.1.112:8080/stapi/factor/getUserFactor?userId=%@",userId];
        
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
                            
                            NSNumber *dataNumber = dictionary[@"v"];
                            
                            NSNumber *keyNumber = dictionary[@"k"];
                            
                            GetFactorModel *factorModel = factorsModelArray[[keyNumber intValue] - 1];
                            
                            factorModel.userSubFactorModel.data = dataNumber;
                            
                            factorModel.userSubFactorModel.factorId = [NSNumber numberWithInt:i + 1];
                            
                            factorModel.userSubFactorModel.title = [GetFactorModel titleStringWithDataNumber:dataNumber subFactorArray:factorModel.subFactorArray];
                            
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
- (void)sendSaveUserFactorsWithUserId:(NSString *)userId
                    factorsModelArray:(NSMutableArray *)factorsModelArray
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(LONetError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"userId"] = userId;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0; i < factorsModelArray.count; i++) {
        
        GetFactorModel *factorModel = factorsModelArray[i];
        
        if (factorModel.userSubFactorModel.data) {
            
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            
            dictionary[@"v"] = factorModel.userSubFactorModel.data;
            
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
                                                                    [[NSNotificationCenter defaultCenter] postNotificationName:UserAccountHandlerUseProfileDidChangeNotification object:nil];
                                                                    
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




- (NSMutableURLRequest *)PostImageRequest:(NSString *)URLString
                                  UIImage:(UIImage*)image
                               parameters:(NSDictionary *)parameters
                                  success:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure
{
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                   timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 1);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameters allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"ImageField\"; filename=\"x1234.png\"\r\n"];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    return request;
}


-(void)sendUpdateUserHeadPortrait:(NSString *)userId
                        headImage:(UIImage *)image
                          success:(void (^)(BOOL))success
                          failure:(void (^)(LONetError *))failure{
    

//    NSString *URLString=@"http://192.168.1.101:8081/stapi/upload/uploadFile";
//    
//    NSData *data = UIImageJPEGRepresentation(image,0.5);
//    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setValue:userId forKey:@"UserId"];
//    [params setValue:@(1) forKey:@"type"];
//    [params setValue:data forKey:@"file"];
//    
//    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
//
//
//    [manager POST:URLString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//        //[formData appendPartWithFileData:data name:@"file" fileName:@"111.png" mimeType:@"image/png"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"上传成功");
//        NSLog(@"%@",operation.responseString);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"失败");
//        NSLog(@"%@",error.description);
//    }];
    
    
    
    
//    NSData *data = UIImagePNGRepresentation(image);
//    if (data.length <= 1024 * 1024) {
//        data = UIImageJPEGRepresentation(image, 0.3);
//    }else{
//        data = UIImageJPEGRepresentation(image, 0.1);
//    }
//    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setValue:userId forKey:@"UserId"];
//    [params setValue:@(1) forKey:@"type"];
//    [params setValue:encodedImageStr forKey:@"file"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:URLString parameters:params constructingBodyWithBlock:^(id _Nonnull formData) {
//        
//        //使用日期生成图片名称
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        
//        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//        
//        NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
//        
//        [formData appendPartWithFileData:data name:@"uploadFile" fileName:fileName mimeType:@"image/png"];
//        
//    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        
//        //上传图片成功执行回调
//        NSLog(@"成功");
//        //completion(responseObject,nil);
//        
//    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//        
//        //上传图片失败执行回调
//        NSLog(@"%@",error);
//        //completion(nil,error);
//        
//    }];
    
    
//    
//    NSString *URLString=@"http://192.168.1.101:8081/stapi/upload/uploadFile";
//    
//    NSData *data = UIImagePNGRepresentation(image);
////    if (data.length <= 1024 * 1024) {
////        data = UIImageJPEGRepresentation(image, 0.3);
////    }else{
////        data = UIImageJPEGRepresentation(image, 0.1);
////    }
//    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setValue:userId forKey:@"UserId"];
//    [params setValue:@(1) forKey:@"type"];
//    [params setValue:encodedImageStr forKey:@"file"];
//
//    AFNetworkReachabilityManager *netWorkManager=[AFNetworkReachabilityManager sharedManager];
//    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html", @"application/x-javascript",nil];
//    
//    [manager POST:URLString parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        [netWorkManager stopMonitoring];
//        if (responseObject !=nil) {
//            NSLog(@"成功");
//        }
//        NSLog(@"%@",operation.responseString);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    

    
    
    
    
    
//    success(0);//赋值
//    
    NSString *URLString=@"http://192.168.1.101:8081/stapi/upload/uploadFile";
    NSURL *URL = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];

    NSData *data=UIImageJPEGRepresentation(image, 1);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *param=[NSString stringWithFormat:@"userId=%@&type=%d&file=%@",userId,1,encodedImageStr];

    NSData *postData = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setURL:URL];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *error;
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"%@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
    UIImage *ig=[UIImage imageWithData:backData];
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
    }else{
        if ([[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding] intValue]==1) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle: @"提示信息" message:@"上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"上传失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            NSLog(@"error:%@",error);
        }
    }

}

@end
