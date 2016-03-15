//
//  UserAccountHandler.m
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "UserAccountHandler.h"
#import "UserProfile.h"

@interface UserAccountHandler () {

    UserProfile *_privateUserProfile;//私有的用户信息
}

@end

@implementation UserAccountHandler

+ (UserAccountHandler *)shareUserAccountHandler {
    
    static id sharedHandler = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedHandler = [[self alloc] init];
        
    });
    
    return sharedHandler;
};

- (id)init {

    if ( self = [super init] ) {
        
        _privateUserProfile = [[UserProfile alloc] init];
        
    }
    
    return self;
}


- (UserProfile *)userProfile {
    
    return _privateUserProfile;
    
}

- (void)setUserProfile:(UserProfile *)userProfile {
    
    _privateUserProfile = userProfile;
    
}


@end
