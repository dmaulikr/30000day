//
//  LODataHandler.h
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LONetError;

@class STBaseViewController;

@interface LODataHandler : NSObject

@property (nonatomic, weak) STBaseViewController *delegate;

//********* 发送验证请求 *************/
- (void)getVerifyWithPhoneNumber:(NSString *)phoneNumber
                          success:(void (^)(NSString *responseObject))success
                          failure:(void (^)(NSString *error))failure;


//*********** 核对短信验证码是否正确 ********/
- (void)postVerifySMSCodeWithPhoneNumber:(NSString *)phoneNumber
                             smsCode:(NSString *)smsCode
                             success:(void (^)(BOOL sucess))success
                             failure:(void (^)(NSError *))failure;

//***** 普通登录 *****/
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(LONetError *))failure;

//***** 用户注册 *****/
- (void)postRegesiterWithPassword:(NSString *)password
                            phoneNumber:(NSString *)phoneNumber
                                nickName:(NSString *)nickName
                               loginName:(NSString *)loginName
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(NSError *))failure;

////***** 忘记密码 *****/
//- (NSString *)postChangePasswordWithPassword:(NSString *)password
//                            phoneNumber:(NSString *)phonenumber
//                             verifyCode:(NSString *)verifycode
//                                success:(void (^)(id responseObject))success
//                                failure:(void (^)(LONetError *))failure;
////***** 忘记密码 *****/
//- (NSString *)getRecordCountIfSuccess:(void (^)(id responseObject))success
//                                     failure:(void (^)(LONetError *))failure;

//**** 获取好友 *****/
- (NSString *)getMyFriendsWithPassword:(NSString *)password
                             loginName:(NSString *)loginName
                                success:(void (^)(id responseObject))success
                                failure:(void (^)(LONetError *))failure;

//***** 更新个人信息 *****/
- (void )postUpdateProfileWithUserID:(NSString *)userID
                                 Password:(NSString *)password
                                loginName:(NSString *)loginName
                                 NickName:(NSString *)nickName
                                   Gender:(NSString *)gender
                                 Birthday:(NSString *)birthday
                                 success:(void (^)(BOOL))success
                                 failure:(void (^)(NSError *))failure;

//******* 保存默认健康因素  ************/
- (void)postUpdateHealthDataWithPassword:(NSString *)password
                               loginName:(NSString *)loginName
                                cityName:(NSString *)cityName
                                 success:(void (^)(BOOL))success
                                failure:(void (^)(NSError *))failure;


@end
