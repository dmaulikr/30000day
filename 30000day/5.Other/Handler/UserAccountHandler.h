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

+ (UserAccountHandler *)shareUserAccountHandler;

@end
