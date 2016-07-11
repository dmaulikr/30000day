//
//  LODataHandler.h
//  30000day
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopDetailModel.h"
#import "CompanyModel.h"
#import <CoreLocation/CoreLocation.h>
#import "InformationWriterModel.h"
#import "InformationDetails.h"
#import "InformationCommentModel.h"
#import "LifeDescendFactorsModel.h"

//当前用户成功添加好友发出的通知
static NSString *const STUserAddFriendsSuccessPostNotification = @"STUserAddFriendsSuccessPostNotification";
//当前用户个人信息改变发出通知
static NSString *const STUserAccountHandlerUseProfileDidChangeNotification = @"STUserAccountHandlerUseProfileDidChangeNotification";
//成功获取好友的时候发送的通知
static NSString *const STUseDidSuccessGetFriendsSendNotification = @"STUseDidSuccessGetFriendsSendNotification";
//成功移除好友的时候发送的通知
static NSString *const STUseDidSuccessDeleteFriendSendNotification = @"STUseDidSuccessDeleteFriendSendNotification";
//成功取消订单会发出通知
static NSString *const STDidSuccessCancelOrderSendNotification = @"STDidSuccessCancelOrderSendNotification";
//成功支付会发出通知
static NSString *const STDidSuccessPaySendNotification = @"STDidSuccessPaySendNotification";
//成功订阅发出的通知
static NSString *const STDidSuccessSubscribeSendNotification = @"STDidSuccessSubscribeSendNotification";
//取消订阅发送的通知
static NSString *const STDidSuccessCancelSubscribeSendNotification = @"STDidSuccessCancelSubscribeSendNotification";
//当开始pop控制器的时候发出的通知
static NSString *const STWillPopViewControllerSendNotification = @"STWillPopViewControllerSendNotification";
//当成功的链接凌云聊天服务器发出的通知
static NSString *const STDidSuccessConnectLeanCloudViewSendNotification = @"STDidSuccessConnectLeanCloudViewSendNotification";
//当成功的更新好友的信息（好友的昵称、备注头像）所发出的通知
static NSString *const STDidSuccessUpdateFriendInformationSendNotification = @"STDidSuccessUpdateFriendInformationSendNotification";
//当成功的更新自己的信息发出通知
static NSString *const STUserDidSuccessUpdateInformationSendNotification = @"STUserDidSuccessUpdateInformationSendNotification";
//当成功的切换显示好友模式
static NSString *const STUserDidSuccessChangeBigOrSmallPictureSendNotification = @"STUserDidSuccessChangeBigOrSmallPictureSendNotification";
//有人申请加为好友
 static NSString *const STDidApplyAddFriendSendNotification = @"STDidApplyAddFriendSendNotification";
//别人同意加为好友
 static NSString *const STDidApplyAddFriendSuccessSendNotification = @"STDidApplyAddFriendSuccessSendNotification";
//通讯录成功的存入沙盒
static NSString *const STDidSaveInFileSendNotification = @"STDidSaveInFileSendNotification";
//日历那成功删除提醒发出的通知
static NSString *const STDidSuccessDeleteRemindSendNotification = @"STDidSuccessDeleteRemindSendNotification";
//日历提醒成功或者增加发出的通知
static NSString *const STDidSuccessChangeOrAddRemindSendNotification = @"STDidSuccessChangeOrAddRemindSendNotification";
//退出群聊
static NSString *const STDidSuccessQuitGroupChatSendNotification = @"STDidSuccessQuitGroupChatSendNotification";
//邀请人，踢人、修改群资料发出的通知
static NSString *const STDidSuccessGroupChatSettingSendNotification = @"STDidSuccessGroupChatSettingSendNotification";
//从后台进入前台发送通知刷新主页
static NSString *const STDidSuccessEnterForegroundSendNotification = @"STDidSuccessEnterForegroundSendNotification";
//运动结束后发送通知刷新历史记录
static NSString *const STDidSuccessSportInformationSendNotification = @"STDidSuccessSportInformationSendNotification";

@class STNetError;
@class WeatherInformationModel;
@class SearchConditionModel;
@class MyOrderDetailModel;
@class UserInformationModel;
@class PriceModel;

@interface STDataHandler : NSObject

+ (STDataHandler *)sharedHandler;

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
+ (void)sendUpdateUserPasswordWithMobile:(NSString *)mobile
                             mobileToken:(NSString *)mobileToken
                                password:(NSString *)password
                                 success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSError *error))failure;

//**************通过用户名获取userId**********/
+ (void)sendGetUserIdByUserName:(NSString *)userName
                        success:(void (^)(NSNumber *userId))success
                        failure:(void (^)(NSError *error))failure;


//***** 普通登录 *****/
//提醒:登录成功会获取用户的个人信息，首界面应刷新，所以登录成功会发出一个通知
//提醒:并且会循环设置个人健康因素，直到成功
//isFromThirdParty @0:普通登录 @1:第三方登录 @2:游客登录
- (NSString *)postSignInWithPassword:(NSString *)password
                           loginName:(NSString *)loginName
                  isPostNotification:(BOOL)isPostNotification
                    isFromThirdParty:(NSNumber *)isFromThirdParty
                                type:(NSString *)type
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *))failure;


//***** 用户注册 *****/
//提醒:注册成功会发通知
//提醒:并且会循环设置个人健康因素，直到成功
- (void)postRegesiterWithPassword:(NSString *)password
                      phoneNumber:(NSString *)phoneNumber
                         nickName:(NSString *)nickName
                      mobileToken:(NSString *)mobileToken//校验后获取的验证码
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *))failure;


//**** 获取好友(dataArray存储的是UserInformationModel) *****/
+ (void)getMyFriendsWithUserId:(NSString *)userId
                         order:(NSString *)order
                       success:(void (^)(NSMutableArray * dataArray))success
                       failure:(void (^)(NSError *))failure;

//************************ 删除好友 **********/
+ (void)sendDeleteFriendWithUserId:(NSNumber *)userId
                      friendUserId:(NSNumber *)friendId
                       success:(void (^)(BOOL  success))success
                       failure:(void (^)(NSError *))failure;


//**********搜索某一个用户（里面装的UserInformationModel）**********************/
+ (void)sendSearchUserRequestWithNickName:(NSString *)nickName
                            currentUserId:(NSString *)curUserId
                                  success:(void(^)(NSMutableArray *))success
                                  failure:(void (^)(NSError *))failure;


//************添加一个好友(currentUserId:当前用户的userId,userId:待添加的userId,messageType:消息类型 @1请求;@2接受;@3拒绝*************/
//添加好友会发送一个极光推送
+ (void)sendPushMessageWithCurrentUserId:(NSNumber *)currentUserId
                                     userId:(NSNumber *)userId
                                messageType:(NSNumber *)messageType
                                    success:(void(^)(BOOL success))success
                                    failure:(void (^)(NSError *error))failure;
//***** 更新个人信息 *****/
//提醒：保存成功后会发出通知
- (void)sendUpdateUserInformationWithUserId:(NSNumber *)userId
                                  nickName:(NSString *)nickName
                                    gender:(NSNumber *)gender
                                  birthday:(NSString *)birthday
                        headImageUrlString:(NSString *)headImageUrlString
                                      memo:(NSString *)memo//个人简介
                                  success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSError *))failure;

//************获取通讯录好友************//
+ (void)sendAddressBooklistRequestCompletionHandler:(void(^)(NSMutableArray *,NSMutableArray *,NSMutableArray *))handler;


//***********开始定位操作(sucess是城市的名字)****************/
- (void)startFindLocationSucess:(void (^)(NSString *,NSString *,CLLocationCoordinate2D))sucess
                        failure:(void (^)(NSError *))failure;


//*****************获取天气情况(代码块返回的是天气模型)***********/
+ (void)getWeatherInformation:(NSString *)cityName
                        sucess:(void (^)(WeatherInformationModel *))sucess
                       failure:(void (^)(NSError *))failure;


//**********获取用户的天龄(dataArray装的是UserLifeModel模型)**********************/
+ (void)sendUserLifeListWithCurrentUserId:(NSNumber *)currentUserId
                                   endDay:(NSString *)endDay//2016-02-19这种模式
                                dayNumber:(NSString *)dayNumber
                                success:(void (^)(NSMutableArray *dataArray))success
                                failure:(void (^)(NSError *error))failure;


//***********获取健康因子(里面装的是GetFacotorModel数组)***************/
+ (void)sendGetFactors:(void (^)(NSMutableArray *dataArray))success
               failure:(void (^)(NSError *error))failure;


//***********获获取某人的健康因子(里面装的是GetFacotorModel数组)***************/
+ (void)sendGetUserFactorsWithUserId:(NSNumber *)userId
                   factorsModelArray:(NSMutableArray *)factorsModelArray
                             success:(void (^)(NSMutableArray *dataArray))success
                             failure:(void (^)(NSError *error))failure;


//********保存某人健康因子到服务器(factorsModelArray存储的是GetFactorModel模型)*********************/
//提醒:如果保存成功,首界面天龄应该改变,保存成功会发出一个通知
+ (void)sendSaveUserFactorsWithUserId:(NSNumber *)userId
                    factorsModelArray:(NSMutableArray *)factorsModelArray
                              success:(void (^)(NSString *dataString))success
                              failure:(void (^)(NSError *error))failure;


//***********************************更新用户头像*********************/
+ (void)sendUpdateUserHeadPortrait:(NSNumber *)userId
                           headImage:(UIImage *)image
                           success:(void (^)(NSString *imageUrl))success
                           failure:(void (^)(NSError *error))failure;

//***********************************获取个人密保问题*********************/
+ (void)sendGetSecurityQuestion:(NSNumber *)userId
                       success:(void (^)(NSDictionary *dic))success
                       failure:(void (^)(NSError *error))failure;

//***********************************获取所有密保问题*********************/
+ (void)sendGetSecurityQuestionSum:(void (^)(NSArray *array))sucess
                           failure:(void (^)(NSError *error))failure;

//***********************************验证个人密保问题*********************/
+ (void)sendSecurityQuestionvalidate:(NSNumber *)userId
                        answer:(NSArray *)answerArr
                        success:(void (^)(NSString *successToken))success
                        failure:(void (^)(NSError *error))failure;

//***********************************密保修改密码*********************/
+ (void)sendSecurityQuestionUptUserPwdBySecu:(NSNumber *)userId
                               token:(NSString *)token
                            password:(NSString *)password
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure;

//***********************************修改密码*********************/
+ (void)sendChangePasswordWithUserId:(NSNumber *)userId
                            oldPassword:(NSString *)oldPassword
                            newPassword:(NSString *)newPassword
                                success:(void (^)(BOOL success))success
                                failure:(void (^)(NSError *error))failure;

//***********************************添加密保*********************/
+ (void)sendChangeSecurityWithUserId:(NSNumber *)userId
                 questionAnswerArray:(NSMutableArray *)modelArray
                             success:(void (^)(BOOL success))success
                             failure:(void (^)(NSError *error))failure;


//***********************************统计环境因素*********************/
+ (void)sendStatUserLifeWithUserId:(NSNumber *)userId
                        dataString:(NSString *)data
                           success:(void (^)(BOOL success))success
                           failure:(void (^)(NSError *error))failure;


//***********************************绑定邮箱*********************/
+ (void)sendUploadUserSendEmailWithUserId:(NSNumber *)userId
                              emailString:(NSString *)email
                                  success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSError *error))failure;


//***********************************验证邮箱*********************/
+ (void)sendVerificationUserEmailWithUserId:(NSNumber *)userId
                                  success:(void (^)(NSDictionary *verificationDictionary))success
                                  failure:(void (^)(NSError *error))failure;

//*********************************获取商家详细的数据*******************/
+ (void)sendCompanyDetailsWithProductId:(NSString *)productId
                                    Success:(void (^)(ShopDetailModel *model))success
                                    failure:(void (^)(NSError *error))failure;

//*********************************获取城市地铁数据*******************/
+ (void)sendCitySubWayWithCityId:(NSString *)cityId
                                Success:(void (^)(NSMutableArray *))success
                                failure:(void (^)(NSError *error))failure;


//*********************************根据筛选条件来获取所有的商品列表*******************/
+ (void)sendShopListWithSearchConditionModel:(SearchConditionModel *)conditionModel
                                    isSearch:(BOOL)isSearch
                                  pageNumber:(NSInteger)pageNumber
                                     Success:(void (^)(NSMutableArray *))success
                                     failure:(void (^)(NSError *error))failure;

//*********************************获取评论列表*******************/
+ (void)sendfindCommentListWithProductId:(NSInteger)productId
                                    type:(NSInteger)type
                                     pId:(NSInteger)pId
                                  userId:(NSInteger)userId
                         Success:(void (^)(NSMutableArray *success))success
                         failure:(void (^)(NSError *error))failure;

//*********************************评论*************************/
+ (void)sendsaveCommentWithProductId:(NSString *)productId
                                type:(NSInteger)type
                              userId:(NSString *)userId
                              remark:(NSString *)remark
                          numberStar:(NSInteger)numberStar
                              picUrl:(NSString *)picUrl
                                 pId:(NSString *)pId
                                 Success:(void (^)(BOOL success))success
                                 failure:(void (^)(NSError *error))failure;

//*********************************点赞*************************/
+ (void)sendPointPraiseOrCancelWithCommentId:(NSString *)commentId
                                 isClickLike:(BOOL)isClickLike
                                     Success:(void (^)(BOOL success))success
                                     failure:(void (^)(NSError *error))failure;


//*********************************商品详情评论*************************/
+ (void)sendDefaultCommentWithBusiId:(NSNumber *)busiId
                                     Success:(void (^)(NSMutableArray *success))success
                                     failure:(void (^)(NSError *error))failure;

//*********************************店长推荐*************************/
+ (void)sendShopOwnerRecommendWithCompanyId:(NSString *)companyId
                                      count:(NSInteger)count
                                     Success:(void (^)(NSMutableArray *success))success
                                     failure:(void (^)(NSError *error))failure;

//*********************************平台推荐*************************/
+ (void)sendPlatformRecommendWithProductTypeId:(NSString *)ProductTypeId
                                         count:(NSInteger)count
                                       Success:(void (^)(NSMutableArray *success))success
                                       failure:(void (^)(NSError *error))failure;

//*********************************商店*************************/
+ (void)sendfindCompanyInfoByIdWithCompanyId:(NSString *)companyId
                                    Success:(void (^)(CompanyModel *success))success
                                    failure:(void (^)(NSError *error))failure;

//*********************************商店下的商品*************************/
+ (void)sendFindProductsByIdsWithCompanyId:(NSString *)companyId
                             productTypeId:(NSString *)productTypeId
                                   Success:(void (^)(NSMutableArray *success))success
                                   failure:(void (^)(NSError *error))failure;

//*********************************获取可预约的场地*************************/
+ (void)sendFindOrderCanAppointmentWithUserId:(NSNumber *)userId
                                    productId:(NSNumber *)productId
                                         date:(NSString *)date
                                      Success:(void (^)(NSMutableArray *success))success
                                      failure:(void (^)(NSError *error))failure;

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
                          failure:(void (^)(NSError *error))failure;

//*********************************计算价格*************************/
- (void)sendCalculateWithProductId:(NSNumber *)productId
                    uniqueKeyArray:(NSMutableArray *)timeModelArray
                           Success:(void (^)(PriceModel *model))success
                           failure:(void (^)(NSError *error))failure;

//**************根据类型获取订单 0->表示全部类型 1->表示已付款 2->表示未付款 返回数组里装的是MyOrderModel************/
+ (void)sendFindOrderUserId:(NSNumber *)userId
                       type:(NSNumber *)type
                    success:(void (^)(NSMutableArray *success))success
                    failure:(void (^)(NSError *error))failure;

//**************根据类型获取订单，返回的是MyOrderDetailModel************/
+ (void)sendFindOrderDetailOrderNumber:(NSString *)orderNumber
                    success:(void (^)(MyOrderDetailModel *detailModel))success
                    failure:(void (^)(NSError *error))failure;

//*****************************************根据类型查资讯************/
+ (void)sendsearchInfomationsWithWriterId:(NSString *)writerId
                             infoTypeCode:(NSString *)infoTypeCode
                                 sortType:(NSInteger)sortType
                                  success:(void (^)(NSMutableArray *success))success
                                  failure:(void (^)(NSError *error))failure;

//**************取消订单,会出发通知:STDidSuccessPaySendNotification************/
+ (void)sendCancelOrderWithOrderNumber:(NSString *)orderNumber
                               success:(void (^)(BOOL success))success
                               failure:(void (^)(NSError *error))failure;

//*****************************************资讯点赞*********************/
+ (void)sendPointOrCancelPraiseWithUserId:(NSNumber *)userId
                                   busiId:(NSString *)busiId
                              isClickLike:(NSInteger)isClickLike
                                 busiType:(NSInteger)busiType
                                  success:(void (^)(BOOL success))success
                                  failure:(void (^)(NSError *error))failure;

//*****************************************作者主页*********************/
+ (void)senSearchWriterInfomationsWithWriterId:(NSString *)writerId
                                        userId:(NSString *)userId
                                       success:(void (^)(InformationWriterModel *success))success
                                       failure:(void (^)(NSError *error))failure;

//*****************************************订阅*********************/
+ (void)sendSubscribeWithWriterId:(NSString *)writerId
                           userId:(NSString *)userId
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *error))failure;

//*****************************************取消订阅*********************/
+ (void)sendCancelSubscribeWriterId:(NSString *)writerId
                             userId:(NSString *)userId
                            success:(void (^)(BOOL success))success
                            failure:(void (^)(NSError *error))failure;

//*****************************************我的订阅*********************/
+ (void)sendMySubscribeWithUserId:(NSString *)userId
                          success:(void (^)(NSMutableArray *success))success
                          failure:(void (^)(NSError *error))failure;

//*****************************************根据userId来获取个人信息模型*********************/
+ (void)sendUserInformtionWithUserId:(NSNumber *)userId
                          success:(void (^)(UserInformationModel *model))success
                          failure:(void (^)(NSError *error))failure;

//*****************************************查找作者*********************/
+ (void)sendSearchWriterListWithWriterName:(NSString *)writerName
                                    userId:(NSString *)userId
                          success:(void (^)(NSMutableArray *success))success
                          failure:(void (^)(NSError *error))failure;

//*****************************************获取评论*********************/
+ (void)sendSearchCommentsWithBusiId:(NSInteger)busiId
                            busiType:(NSInteger)busiType
                                 pid:(NSInteger)pid
                              userId:(NSInteger)userId
                         commentType:(NSInteger)commentType
                             success:(void (^)(NSMutableArray *success))success
                             failure:(void (^)(NSError *error))failure;

//*****************************************资讯详情*********************/
+ (void)getInfomationDetailWithInfoId:(NSNumber *)infoId
                               userId:(NSNumber *)userId
                              success:(void (^)(InformationDetails *success))success
                              failure:(void (^)(NSError *error))failure;


//*****************************************评论*********************/
+ (void)sendSaveCommentWithBusiId:(NSInteger)busiId
                         busiType:(NSInteger)busiType
                           userId:(NSInteger)userId
                           remark:(NSString *)remark
                              pid:(NSInteger)pid
                       isHideName:(BOOL)isHideName
                       numberStar:(NSInteger)numberStar
                    commentPhotos:(NSString *)commentPhotos
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *error))failure;

//*****************************************根据类型获取订阅作者*********************/
+ (void)sendWriterListWithUserId:(NSNumber *)userId
                    suscribeType:(NSString *)suscribeType
                         success:(void (^)(NSMutableArray *dataArray))success
                         failure:(void (^)(NSError *error))failure;

//*****************************************上传商品评论图片*********************/
+ (void)sendUploadImagesWithUserId:(NSInteger)userId
                              type:(NSInteger)type
                        imageArray:(NSArray *)imageArray
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSError *error))failure;

//*****************************************获取击败人数数据*********************/
+ (void)sendGetDefeatDataWithUserId:(NSNumber *)userId
                           success:(void (^)(NSString *dataString))success
                           failure:(void (^)(NSError *error))failure;

//*****************************************检查是否已绑定*********************/
+ (void)sendcheckBindWithAccountNo:(NSString *)accountNo
                              type:(NSString *)type
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSError *error))failure;

//*****************************************绑定注册*********************/
+ (void)sendBindRegisterWithMobile:(NSString *)mobile
                          nickName:(NSString *)nickName
                         accountNo:(NSString *)accountNo
                          password:(NSString *)password
                           headImg:(NSString *)headImg
                              type:(NSString *)type
                           success:(void (^)(NSString *success))success
                           failure:(void (^)(NSError *error))failure;

//*****************************************更新好友好友信息*********************/
+ (void)sendUpdateFriendInformationWithUserId:(NSNumber *)userId
                                 friendUserId:(NSNumber *)friendUserId
                               friendNickName:(NSString *)friendNickName
                     friendHeadImageUrlString:(NSString *)friendHeadImageUrlString
                                      success:(void (^)(BOOL success))success
                                      failure:(void (^)(NSError *error))failure;

//*****************************************检查是否已注册*********************/
//accountNo:第三方或者访客传进来的唯一标识  type:用来表示到底是QQ、Sina、Wechat、guest
+ (void)sendCheckRegisterForThirdParyWithAccountNo:(NSString *)accountNo
                                              type:(NSString *)type
                                           success:(void (^)(NSString *success))success
                                           failure:(void (^)(NSError *error))failure;

//*****************************************注册第三方登录账号*********************/
+ (void)sendRegisterForThirdParyWithAccountNo:(NSString *)accountNo
                                     nickName:(NSString *)nickName
                                      headImg:(NSString *)headImg
                                         type:(NSString *)type
                                      success:(void (^)(NSString *success))success
                                      failure:(void (^)(NSError *error))failure;

//*****************************************检查手机号是否已经注册*********************/
+ (void)sendcheckRegisterForMobileWithmobile:(NSString *)mobile
                                      success:(void (^)(NSString *success))success
                                      failure:(void (^)(NSError *error))failure;

//*****************************************检测通讯录*********************/
//该方法返回的是子线程中返回的
+ (void)sendcheckAddressBookWithMobileOwnerId:(NSString *)mobileOwnerId
                              addressBookJson:(NSString *)addressBookJson
                                      success:(void (^)(NSArray *addressArray))success
                                      failure:(void (^)(NSError *error))failure;

//*****************************************获取用户天龄下降因素*********************/
+ (void)sendLifeDescendFactorsWithUserId:(NSNumber *)userId
                                 success:(void (^)(NSArray *lifeDescendFactorsArray))success
                                 failure:(void (^)(NSError *error))failure;


//*****************************************获取免责条款及协议*********************/
+ (void)sendGetAgreement:(void (^)(NSString *urlString))success
                 failure:(void (^)(NSError *error))failure;

//*****************************************检测密码是否正确*********************/
+ (void)sendCheckPasswordWithUserId:(NSNumber *)userId
                           password:(NSString *)password
                            success:(void (^)(BOOL success))success
                            failure:(void (^)(NSError *error))failure;

//**********************查找当前有哪些人申请加我为好友【数组里存储的是NewFriendModel】********************//
+ (void)sendFindAllApplyAddFriendWithUserId:(NSNumber *)userId
                                    success:(void (^)(NSMutableArray *dataArray))success
                                    failure:(void (^)(NSError *error))failure;

//*********************删除某一条请求加为好友记录*******************//
+ (void)sendDeleteApplyAddFriendWithUserId:(NSNumber *)userId
                              friendUserId:(NSNumber *)friendId
                                   success:(void (^)(BOOL))success
                                   failure:(void (^)(NSError *))failure;

//*********************设置添加好友开关*******************//
+ (void)sendSetFriendSwitchWithUserId:(NSNumber *)userId
                               status:(NSInteger)status
                              success:(void (^)(BOOL success))success
                              failure:(void (^)(NSError *error))failure;

@end
