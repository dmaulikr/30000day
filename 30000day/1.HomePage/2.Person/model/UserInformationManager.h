//
//  UserInformationManager.h
//  30000day
//
//  Created by GuoJia on 16/3/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformationModel.h"

@interface UserInformationManager : NSObject

+ (UserInformationManager *)shareUserInformationManager;

@property (nonatomic , strong,readwrite) NSMutableArray *userInformationArray;

//通过一个好友的userId，来查询好友的信息
- (UserInformationModel *)informationModelWithUserId:(NSString *)userId;

@end
