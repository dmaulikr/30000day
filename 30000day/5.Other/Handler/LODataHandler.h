//
//  LODataHandler.h
//  30000day
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopDetailModel.h"


//当前用户成功添加好友发出的通知
static NSString *const STUserAddFriendsSuccessPostNotification = @"STUserAddFriendsSuccessPostNotification";

//当前用户个人信息改变发出通知
static NSString *const STUserAccountHandlerUseProfileDidChangeNotification = @"STUserAccountHandlerUseProfileDidChangeNotification";

//成功获取好友的时候发送的通知
static NSString *const STUseDidSuccessGetFriendsSendNotification = @"STUseDidSuccessGetFriendsSendNotification";


@class LONetError;

@class STBaseViewController;

@class WeatherInformationModel;

@interface LODataHandler : NSObject

@property (nonatomic, weak) STBaseViewController *delegate;

//********* 发送验证请求 *************/
- (void)getVerifyWithPhoneNumber:(NSString *)phoneNumber
                            type:(NSNumber *)type
                          success:(void (^)(NSString *responseObject))success
                          failure:(void (^)(NSString *error))failure;


//*********** 核对短信验证码是否正确 ********/
- (void)postVerifySMSCodeWithPhoneNumber:(NSString *)phoneNumber
                             smsCode:(NSString *)smsCode
                             success:(void (^)(NSString *mobileToken))success
                             failure:(void (^)(NSError *error))failure;


//************ 修改密码*****************//
- (void)sendUpdateUserPasswordWithMobile:(NSString *)mobile
                             mobileToken:(NSString *)mobileToken
                                password:(NSString *)password
                                 success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSError *error))failure;

//**************通过用户名获取userId通过用户名获取userId**********/
- (void)sendGetUserIdByUserName:(NSString *)userName
                        success:(void (^)(NSNumber *userId))success
                        failure:(void (^)(NSError *error))failure;


//***** 普通登录 *****/
//提醒:登录成功会获取用户的个人信息，首界面应刷新，所以登录成功会发出一个通知
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                  isPostNotification:(BOOL)isPostNotification
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *))failure;


//***** 用户注册 *****/
//提醒:注册成功会获取用户的个人信息，首界面应刷新，所以注册成功会发出一个通知
- (void)postRegesiterWithPassword:(NSString *)password
                      phoneNumber:(NSString *)phoneNumber
                         nickName:(NSString *)nickName
                      mobileToken:(NSString *)mobileToken//校验后获取的验证码
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
                                  failure:(void (^)(NSError *))failure;


//************添加一个好友(currentUserId:当前用户的userId,nickName:待添加的userId,nickName:待添加的昵称)*************/
- (void)sendAddUserRequestWithcurrentUserId:(NSString *)currentUserId
                                     userId:(NSString *)userId
                                    success:(void(^)(BOOL success))success
                                    failure:(void (^)(NSError *error))failure;
//***** 更新个人信息 *****/
//提醒：保存成功后会发出通知
- (void)sendUpdateUserInformationWithUserId:(NSNumber *)userId
                                  nickName:(NSString *)nickName
                                    gender:(NSNumber *)gender
                                  birthday:(NSString *)birthday
                        headImageUrlString:(NSString *)headImageUrlString
                                  success:(void (^)(BOOL))success
                                  failure:(void (^)(LONetError *))failure;

//************获取通讯录好友************//
- (void)sendAddressBooklistRequestCompletionHandler:(void(^)(NSMutableArray *,NSMutableArray *,NSMutableArray *))handler;


//***********开始定位操作(sucess是城市的名字)****************/
- (void)startFindLocationSucess:(void (^)(NSString *))sucess
                        failure:(void (^)(NSError *))failure;


//*****************获取天气情况(代码块返回的是天气模型)***********/
- (void)getWeatherInformation:(NSString *)cityName
                        sucess:(void (^)(WeatherInformationModel *))sucess
                       failure:(void (^)(NSError *))failure;


//**********获取用户的天龄(dataArray装的是UserLifeModel模型)**********************/
- (void)sendUserLifeListWithCurrentUserId:(NSNumber *)currentUserId
                                   endDay:(NSString *)endDay//2016-02-19这种模式
                                dayNumber:(NSString *)dayNumber
                                success:(void (^)(NSMutableArray *dataArray))success
                                failure:(void (^)(LONetError *error))failure;


//***********获取健康因子(里面装的是GetFacotorModel数组)***************/
- (void)sendGetFactors:(void (^)(NSMutableArray *dataArray))success
               failure:(void (^)(LONetError *error))failure;


//***********获取每个健康模型的子模型(param:factorsArray装的是GetFactorModel,return:dataArray装GetFactorModel数组)***************/
- (void)sendGetSubFactorsWithFactorsModel:(NSMutableArray *)factorsArray
                                  success:(void (^)(NSMutableArray *dataArray))success
                                  failure:(void (^)(LONetError *error))failure;


//***********获获取某人的健康因子(里面装的是GetFacotorModel数组)***************/
- (void)sendGetUserFactorsWithUserId:(NSNumber *)userId
                   factorsModelArray:(NSMutableArray *)factorsModelArray
                             success:(void (^)(NSMutableArray *dataArray))success
                             failure:(void (^)(LONetError *error))failure;


//********保存某人健康因子到服务器(factorsModelArray存储的是GetFactorModel模型)*********************/
//提醒:如果保存成功,首界面天龄应该改变,保存成功会发出一个通知
- (void)sendSaveUserFactorsWithUserId:(NSNumber *)userId
                    factorsModelArray:(NSMutableArray *)factorsModelArray
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(LONetError *error))failure;


//***********************************更新用户头像*********************/
- (void)sendUpdateUserHeadPortrait:(NSNumber *)userId
                           headImage:(UIImage *)image
                           success:(void (^)(NSString *imageUrl))success
                           failure:(void (^)(NSError *error))failure;

//***********************************获取个人密保问题*********************/
- (void)sendGetSecurityQuestion:(NSNumber *)userId
                       success:(void (^)(NSDictionary *dic))success
                       failure:(void (^)(LONetError *error))failure;

//***********************************获取所有密保问题*********************/
- (void)sendGetSecurityQuestionSum:(void (^)(NSArray *array))sucess
                           failure:(void (^)(LONetError *error))failure;

//***********************************验证个人密保问题*********************/
- (void)sendSecurityQuestionvalidate:(NSNumber *)userId
                        answer:(NSArray *)answerArr
                        success:(void (^)(NSString *successToken))success
                        failure:(void (^)(LONetError *error))failure;

//***********************************密保修改密码*********************/
- (void)sendSecurityQuestionUptUserPwdBySecu:(NSNumber *)userId
                               token:(NSString *)token
                            password:(NSString *)password
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(LONetError *error))failure;

//***********************************修改密码*********************/
- (void)sendChangePasswordWithUserId:(NSNumber *)userId
                            oldPassword:(NSString *)oldPassword
                            newPassword:(NSString *)newPassword
                                success:(void (^)(BOOL success))success
                                failure:(void (^)(NSError *error))failure;

//***********************************添加密保*********************/
- (void)sendChangeSecurityWithUserId:(NSNumber *)userId
                         qidArray:(NSArray *)qidArray
                         answerArray:(NSArray *)answerArray
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure;


//***********************************统计环境因素*********************/
- (void)sendStatUserLifeWithUserId:(NSNumber *)userId
                        dataString:(NSString *)data
                           success:(void (^)(BOOL success))success
                           failure:(void (^)(NSError *error))failure;


//***********************************绑定邮箱*********************/
- (void)sendUploadUserSendEmailWithUserId:(NSNumber *)userId
                              emailString:(NSString *)email
                                  success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSError *error))failure;


//***********************************验证邮箱*********************/
- (void)sendVerificationUserEmailWithUserId:(NSNumber *)userId
                                  success:(void (^)(NSDictionary *verificationDictionary))success
                                  failure:(void (^)(NSError *error))failure;

//*********************************获取商家所有的数据*******************/
- (void)sendCompanyListSuccess:(void (^)(NSMutableArray *companyListArray))success
                           failure:(void (^)(NSError *error))failure;


//*********************************获取商家详细的数据*******************/
- (void)sendCompanyDetailsWithCompanyId:(NSString *)companyId
                                    Success:(void (^)(ShopDetailModel *model))success
                                    failure:(void (^)(NSError *error))failure;

//*********************************获取城市地铁数据*******************/
- (void)sendCitySubWayWithCityId:(NSString *)cityId
                                Success:(void (^)(NSMutableArray *))success
                                failure:(void (^)(NSError *error))failure;

//*********************************获取评论列表*******************/
- (void)sendfindCommentListWithProductId:(NSInteger)productId
                                    type:(NSInteger)type
                                     pId:(NSInteger)pId
                                  userId:(NSInteger)userId
                         Success:(void (^)(NSMutableArray *success))success
                         failure:(void (^)(NSError *error))failure;


@end
