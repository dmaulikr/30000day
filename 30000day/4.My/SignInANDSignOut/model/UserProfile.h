//
//  UserProfile.h
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

//@property (nonatomic ,copy) NSString *UserID;//用户id
//
//@property (nonatomic ,copy) NSString *LoginName;//账号
//
//@property (nonatomic ,copy) NSString *LoginPassword;//密码
//
//@property (nonatomic ,copy) NSString *SkinName;//***
//
//@property (nonatomic ,copy) NSString *NickName;//昵称
//
//@property (nonatomic ,copy) NSString *Gender;//性别
//
//@property (nonatomic ,copy) NSString *Email;//邮箱
//
//@property (nonatomic ,copy) NSString *Birthday;//出生日期
//
//@property (nonatomic ,copy) NSString *Address;//地址
//
//@property (nonatomic ,copy) NSString *Life;//天龄
//
//@property (nonatomic ,copy) NSString *HeadImg;//头像
//
//@property (nonatomic ,copy) NSString *Name;//真实姓名
//
//@property (nonatomic ,copy) NSString *Age;//年龄
//
//@property (nonatomic ,copy) NSString *RoleID;//角色
//
//@property (nonatomic ,copy) NSString *PhoneNumber;//手机号码
//
//@property (nonatomic ,copy) NSString *RegDate;//注册时间
//
//@property (nonatomic ,copy) NSString *A1;//问题1
//
//@property (nonatomic ,copy) NSString *A2;//问题2
//
//@property (nonatomic ,copy) NSString *A3;//问题3
//
//@property (nonatomic ,copy) NSString *Q1;//答案1
//
//@property (nonatomic ,copy) NSString *Q2;//答案2
//
//@property (nonatomic ,copy) NSString *Q3;//答案3


@property (nonatomic,strong) NSNumber *age;//生日

@property (nonatomic,strong) NSNumber *gender;//性别

@property (nonatomic,copy)  NSString *nickName;//用户昵称

@property (nonatomic,strong) NSNumber *userType;//

@property (nonatomic,strong) NSNumber *userId;//用户Id

@property (nonatomic,copy)  NSString *userName;//账号

@property (nonatomic,copy)  NSString *headImg;//用户的头像

@property (nonatomic,copy)  NSString *birthday;

@property (nonatomic,copy) NSString *email;

@end
