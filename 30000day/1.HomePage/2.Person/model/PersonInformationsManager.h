//
//  PersonInformationsManager.h
//  30000day
//
//  Created by GuoJia on 16/5/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"
#import "UserInformationModel.h"

@interface PersonInformationsManager : STManager

@property (nonatomic,strong) NSMutableArray *informationsArray;//好友的所有的信息

+ (PersonInformationsManager *)shareManager;

- (UserInformationModel *)infoWithFriendId:(NSNumber *)friendUsrId;//朋友的id

@end
