//
//  LODataHandler.h
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

//当前用户成功添加好友发出的通知
static NSString *const UserAddFriendsSuccessPostNotification = @"UserAddFriendsSuccessPostNotification";

//当前用户个人信息改变发出通知
static NSString *const UserAccountHandlerUseProfileDidChangeNotification = @"UserAccountHandlerUseProfileDidChangeNotification";

#import <Foundation/Foundation.h>

@class LONetError;

@class STBaseViewController;

@class WeatherInformationModel;

@interface LODataHandler : NSObject

@property (nonatomic, weak) STBaseViewController *delegate;

//********* 发送验证请求 *************/
- (void)getVerifyWithPhoneNumber:(NSString *)phoneNumber
                          success:(void (^)(NSString *responseObject))success
                          failure:(void (^)(NSString *error))failure;


//*********** 核对短信验证码是否正确 ********/
- (void)postVerifySMSCodeWithPhoneNumber:(NSString *)phoneNumber
                             smsCode:(NSString *)smsCode
                             success:(void (^)(NSString *mobileToken))success
                             failure:(void (^)(NSError *error))failure;

//***** 普通登录 *****/
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(LONetError *))failure;

//***** 用户注册 *****/
- (void)postRegesiterWithPassword:(NSString *)password
                      phoneNumber:(NSString *)phoneNumber
                         nickName:(NSString *)nickName
                      mobileToken:(NSString *)mobileToken//校验后获取的验证码
                         birthday:(NSString *)birthday//生日
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *))failure;

//**** 获取好友(dataArray存储的是UserInformationModel) *****/
- (void)getMyFriendsWithUserId:(NSString *)userId
                                success:(void (^)(NSMutableArray * dataArray))success
                                failure:(void (^)(NSError *))failure;

//**********搜索某一个用户（里面装的UserInformationModel）**********************/
- (void)sendSearchUserRequestWithNickName:(NSString *)nickName
                            currentUserId:(NSString *)curUserId
                                  success:(void(^)(NSMutableArray *))success
                                  failure:(void (^)(LONetError *))failure;

//************添加一个好友(currentUserId:当前用户的userId,nickName:待添加的userId,nickName:待添加的昵称)*************/
- (void)sendAddUserRequestWithcurrentUserId:(NSString *)currentUserId
                                     userId:(NSString *)userId
                                   nickName:(NSString *)nickName
                                    success:(void(^)(BOOL success))success
                                    failure:(void (^)(LONetError *error))failure;

//***** 更新个人信息 *****/
- (void )postUpdateProfileWithUserID:(NSString *)userID
                                 Password:(NSString *)password
                                loginName:(NSString *)loginName
                                 NickName:(NSString *)nickName
                                   Gender:(NSString *)gender
                                 Birthday:(NSString *)birthday
                                 success:(void (^)(BOOL))success
                                 failure:(void (^)(NSError *))failure;

//******* 设置健康因子  ************/
- (void)postUpdateHealthDataWithPassword:(NSString *)password
                               loginName:(NSString *)loginName
                                cityName:(NSString *)cityName
                                 success:(void (^)(BOOL))success
                                failure:(void (^)(NSError *))failure;


//************获取通讯录好友************//
- (void)sendAddressBooklistRequestCompletionHandler:(void(^)(NSMutableArray *,NSMutableArray *,NSMutableArray *))handler;



//***********开始定位操作(sucess是城市的名字)****************/
- (void)startFindLocationSucess:(void (^)(NSString *))sucess
                        failure:(void (^)(NSError *))failure;


//*****************获取天气情况(代码块返回的是天气模型)***********/
- (void)getWeatherInformation:(NSString *)cityName
                        sucess:(void (^)(WeatherInformationModel *))sucess
                       failure:(void (^)(NSError *))failure;


//**********获取用户的天龄**********************/
- (void)getUserLifeStateUserID:(NSString *)userID
                      Password:(NSString *)password
                     loginName:(NSString *)loginName
                       success:(void (^)(NSMutableArray *,NSMutableArray*))success
                       failure:(void (^)(NSError *))failure;


//**********获取用户的天龄(dataArray装的是模型)**********************/
- (void)sendUserLifeListWithCurrentUserId:(NSString *)currentUserId
                                   endDay:(NSString *)endDay//2016-02-19这种模式
                                dayNumber:(NSString *)dayNumber
                                success:(void (^)(NSMutableArray *dataArray))success
                                failure:(void (^)(LONetError *error))failure;

@end
