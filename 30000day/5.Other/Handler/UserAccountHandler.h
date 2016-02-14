//
//  UserAccountHandler.h
//  30000day
//  处理用户账号相关的模型
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface UserAccountHandler : NSObject

@property (nonatomic ,strong) UserProfile *userProfile;//保存在处理器里面的用户信息,setter方法会发出通知

@property (nonatomic ,strong,readonly) NSMutableArray *lastUserAccountArray;//之前保存用户登录的账号和密码

+ (UserAccountHandler *)shareUserAccountHandler;

//获取用户的各种信息
- (void)getUserInfo;

//退出登录
- (void)logout;

//********************************系统调用的接口************************//
/**
 *   1.保存用户上次登录的账号
 *   2.同时也会更新用户信息
 *   3.该接口不要调用,是系统调用的
 **/
- (void)saveUserAccountWithModel:(UserProfile *)userProfile;

@end
