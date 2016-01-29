//
//  FirendListInfo.h
//  30000天
//
//  Created by 30000天_001 on 14-8-29.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendListInfo : NSObject
@property (nonatomic ,copy) NSString *AllowSeeMe;//是否允许看我
@property (nonatomic ,copy) NSString *Birthday;//生日
@property (nonatomic ,copy) NSString *CurrentUserID;//本人ID
@property (nonatomic ,copy) NSString *Focus;//是否关注好友  nil表示
@property (nonatomic ,copy) NSString *FriendGender;//性别   0女  1男
@property (nonatomic ,copy) NSString *FriendHeadImg;//好友自己的头像
@property (nonatomic ,copy) NSString *FriendPhoneNumber;//好友手机号码
@property (nonatomic ,copy) NSString *FriendSelfNickName;//好友自己的昵称
@property (nonatomic ,copy) NSString *FriendUserID;//好友在user表的ID
@property (nonatomic ,copy) NSString *HeadImg;//好友备注头像
@property (nonatomic ,copy) NSString *MyFriendID;//用户好友表ID
@property (nonatomic ,copy) NSString *Nickname;//好友昵称
@property (nonatomic ,copy) NSString *Remarks;//对好友的备注
@property (nonatomic ,copy) NSString *TotalDays;//天龄
@property (nonatomic ,copy) NSString *YesterdayAddedDays;//昨天的天龄增减量


+(UserInfo *)userWithUserInfo:(UserInfo*)user;
@end
