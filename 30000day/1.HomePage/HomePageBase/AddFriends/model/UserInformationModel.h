//
//  SearchUserInformationModel.h
//  30000day
//  当前用户、当前用户的好友、搜索到的用户模型
//  Created by GuoJia on 16/2/19.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformationModel : NSObject

@property (nonatomic,strong) NSNumber *gender;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *age;

@property (nonatomic,strong) NSNumber *chgLife;//今天改变的的 0:不改变 正数:增加的 负数:减少的

@property (nonatomic,strong) NSNumber *totalLife;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *headImg;

@property (nonatomic,strong) NSNumber *curLife;//当前的的天龄

@property (nonatomic , strong) NSNumber *flag;//0 表示不是好友 1表示是好友 -1表示是自己

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *birthday;//生日

@property (nonatomic,copy) NSString *memo;//备注

/**
 *  @return @{@"xxx":@{@"nickName":@"GuoJia",@"userId":@"100000035",@"imgUrl":@"http://xxxxxx.xxxxxx"},@"yyy":@{@"nickName":@"guojia",@"userId":@"100000016",@"imgUrl":@"http://xxxxxx.xxxxxx"},@"type":0}
 */
+ (NSDictionary *)attributesDictionay:(UserInformationModel *)model userProfile:(UserProfile *)userProfile;

@end
