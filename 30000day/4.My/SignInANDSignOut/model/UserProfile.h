//
//  UserProfile.h
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic,strong) NSNumber *age;//生日

@property (nonatomic,strong) NSNumber *gender;//性别

@property (nonatomic,copy)  NSString *nickName;//用户昵称

@property (nonatomic,strong) NSNumber *userType;//

@property (nonatomic,strong) NSNumber *userId;//用户Id

@property (nonatomic,copy)  NSString *userName;//账号

@property (nonatomic,copy)  NSString *headImg;//用户的头像

@property (nonatomic,copy)  NSString *birthday;

@property (nonatomic,copy) NSString *email;

@property (nonatomic,copy) NSString *memo;//个人简介

@property (nonatomic,copy) NSString *friendSwitch;//添加好友的验证开关

@property (nonatomic,copy) NSString *mobile;//手机号码

@end
