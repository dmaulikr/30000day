//
//  UserInfo.m
//  30000天
//
//  Created by 30000天_001 on 15/7/29.
//  Copyright (c) 2015年 30000天_001. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (UserInfo *)userWithUserInfo:(UserInfo *)user {
    
    UserInfo *info = [[UserInfo alloc] init];
    
    info.UserID = user.UserID;
    
    info.LoginName = user.LoginName;
    
    info.LoginPassword = user.LoginPassword;
    
    info.SkinName = user.SkinName;
    
    info.NickName = user.NickName;
    
    info.Gender = user.Gender;
    
    info.Email = user.Email;
    
    info.Birthday = user.Birthday;
    
    info.Address = user.Address;
    
    info.Life = user.Life;
    
    info.HeadImg = user.HeadImg;
    
    info.Name = user.Name;
    
    info.Age = user.Age;
    
    info.RoleID = user.RoleID;
    
    info.PhoneNumber = user.PhoneNumber;
    
    info.RegDate = user.RegDate;
    
    info.A1 = user.A1;
    
    info.A2 = user.A2;
    
    info.A3 = user.A3;
    
    info.Q1 = user.Q1;
    
    info.Q2 = user.Q2;
    
    info.Q3 = user.Q3;
    
    return info;
}


@end
