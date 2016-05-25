//
//  CDAddFriendsManager.h
//  30000day
//
//  Created by GuoJia on 16/5/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAddFriendsManager : NSObject

+ (CDAddFriendsManager *)shareManager;

//发出添加好友的请求
- (void)subscribePresenceToUser:(NSNumber *)userId andCallback:(AVBooleanResultBlock)callback;

//同意好友的添加请求
- (void)acceptPresenceSubscriptionRequestFrom:(NSNumber *)userId andCallback:(AVBooleanResultBlock)callback;

@end
