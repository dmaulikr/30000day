//
//  UserInformationManager.m
//  30000day
//
//  Created by GuoJia on 16/3/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "UserInformationManager.h"

@interface UserInformationManager ()


@end

@implementation UserInformationManager

+ (UserInformationManager *)shareUserInformationManager {
    
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[self alloc] init];
        
    });
    
    return sharedManager;
    
}

- (UserInformationModel *)informationModelWithUserId:(NSString *)userId {
    
    for (int i = 0; i < self.userInformationArray.count; i++) {
        
        UserInformationModel *model = self.userInformationArray[i];
        
        if ([model.userId isEqual:[NSNumber numberWithLongLong:[userId longLongValue]]]) {
            
            return model;
            
            break;
        }
        
    }
    
    return nil;
}


- (void)setUserInformationArray:(NSMutableArray *)userInformationArray {
    
    _userInformationArray = userInformationArray;
    
    [STNotificationCenter postNotificationName:STUseDidSuccessGetFriendsSendNotification object:nil];
}


@end
