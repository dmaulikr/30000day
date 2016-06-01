//
//  NewFriendManager.h
//  30000day
//
//  Created by GuoJia on 16/5/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STManager.h"

@interface NewFriendManager : STManager

+ (void)subscribePresenceToUserWithUserProfile:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback;

+ (void)acceptPresenceSubscriptionRequestFrom:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback;

+ (void)drictRefresh:(UserInformationModel *)model andCallback:(AVBooleanResultBlock)callback;

@end
