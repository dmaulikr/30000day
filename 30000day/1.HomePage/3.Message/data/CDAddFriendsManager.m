//
//  CDAddFriendsManager.m
//  30000day
//
//  Created by GuoJia on 16/5/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CDAddFriendsManager.h"

@implementation CDAddFriendsManager

+ (CDAddFriendsManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    static CDAddFriendsManager *manager;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[CDAddFriendsManager alloc] init];
        
    });
    
    return manager;
}

- (void)subscribePresenceToUser:(NSNumber *)userId andCallback:(AVBooleanResultBlock)callback {
    
    AVStatus *status = [[AVStatus alloc] init];
    
    status.type = @"subscribe";
    
    [AVStatus sendPrivateStatus:status  toUserWithID:[NSString stringWithFormat:@"%@",userId] andCallback:^(BOOL succeeded, NSError *error) {
        
        callback(succeeded,error);
    }];
}

- (void)acceptPresenceSubscriptionRequestFrom:(NSNumber *)userId andCallback:(AVBooleanResultBlock)callback {
    
    AVStatus *status = [[AVStatus alloc] init];
    
    status.type = @"acceptSubscribe";
    
    [AVStatus sendPrivateStatus:status  toUserWithID:[NSString stringWithFormat:@"%@",userId] andCallback:^(BOOL succeeded, NSError *error) {
        
        callback(succeeded,error);
    }];
}

#pragma mark ---

@end
