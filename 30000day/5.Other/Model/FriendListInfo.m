//
//  FirendListInfo.m
//  30000天
//
//  Created by 30000天_001 on 14-8-29.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "FriendListInfo.h"

@implementation FriendListInfo

+(UserInfo *)userWithUserInfo:(UserInfo *)user
{
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
    return info;
}


@end
