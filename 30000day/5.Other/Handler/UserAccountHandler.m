//
//  UserAccountHandler.m
//  30000day
//
//  Created by GuoJia on 16/2/2.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "UserAccountHandler.h"

@interface UserAccountHandler () {

    UserInfo *_privateUserInfo;//私有的用户信息
    
    NSMutableArray *_privateUserAccountArray;//私有的之前保存用户登录的账号和密码
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
        
        //从磁盘中读取上次存储的数组
        _privateUserAccountArray = [NSMutableArray arrayWithArray:[Common readAppDataForKey:USER_ACCOUNT_ARRAY]];
        
        _privateUserInfo = [[UserInfo alloc] init];
        
    }
    
    return self;
}

- (void)saveUserAccountWithModel:(UserInfo *)userInfo {
    
    _privateUserInfo = userInfo;
    
    //保存用户的UID
    [Common saveAppDataForKey:KEY_SIGNIN_USER_UID withObject:_privateUserInfo.UserID];
    
    //保存用户名
    [Common saveAppDataForKey:KEY_SIGNIN_USER_NAME withObject:_privateUserInfo.LoginName];
    
    //保存用户密码
    [Common saveAppDataForKey:KEY_SIGNIN_USER_PASSWORD withObject:_privateUserInfo.LoginPassword];
    
     NSMutableDictionary *userAccountDictionary = [NSMutableDictionary dictionary];
    
    if (_privateUserAccountArray.count == 0 ) {
        
        [userAccountDictionary setObject:_privateUserInfo.LoginName forKey:KEY_SIGNIN_USER_NAME];
        
        [userAccountDictionary setObject:_privateUserInfo.LoginPassword forKey:KEY_SIGNIN_USER_PASSWORD];
        
        [_privateUserAccountArray addObject:userAccountDictionary];
        
        [Common saveAppDataForKey:USER_ACCOUNT_ARRAY withObject:_privateUserAccountArray];
        
    } else {
        
            BOOL isExist = NO;//默认是不存在的

            for (NSInteger i = 0; i < _privateUserAccountArray.count; i++) {

                userAccountDictionary = _privateUserAccountArray[i];

                if ([[userAccountDictionary objectForKey:KEY_SIGNIN_USER_NAME] isEqualToString:_privateUserInfo.LoginName] && [[userAccountDictionary objectForKey:KEY_SIGNIN_USER_PASSWORD] isEqualToString:_privateUserInfo.LoginPassword]) {
                    
                    isExist = YES;
                    
                }
            }
            if (isExist == NO) {//如果不存在，就要保存

                NSDictionary *dc = [NSDictionary dictionaryWithObjectsAndKeys:_privateUserInfo.LoginName,KEY_SIGNIN_USER_NAME,_privateUserInfo.LoginPassword,KEY_SIGNIN_USER_PASSWORD, nil];

                [_privateUserAccountArray addObject:dc];
                
                [Common saveAppDataForKey:USER_ACCOUNT_ARRAY withObject:_privateUserAccountArray];
            }
        }
    
    //登录的时候进行发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAccountHandlerUseProfileDidChangeNotification" object:nil];
}

- (NSMutableArray *)lastUserAccountArray {
    
    return _privateUserAccountArray;
    
}

- (UserInfo *)userInfo {
    
    return _privateUserInfo;
    
}

- (void)setUserInfo:(UserInfo *)userInfo {
    
    _privateUserInfo = userInfo;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAccountHandlerUseProfileDidChangeNotification" object:nil];
}

- (void)logout {
    
    [Common removeAppDataForKey:KEY_SIGNIN_USER_UID];
    
    [Common removeAppDataForKey:KEY_SIGNIN_USER_NAME];
    
    [Common removeAppDataForKey:KEY_SIGNIN_USER_PASSWORD];
    
    _privateUserInfo = nil;
}

- (void)getUserInfo {
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"LoginName"] = [Common readAppDataForKey:KEY_SIGNIN_USER_NAME];
    
    parameters[@"LoginPassword"] = [Common readAppDataForKey:KEY_SIGNIN_USER_PASSWORD];
    
    [mgr GET:@"http://116.254.206.7:12580/M/API/Login" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSError *localError = nil;
         
         id parsedObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&localError];
         
         NSDictionary *recvDic = (NSDictionary *)parsedObject;
         
         dispatch_async(dispatch_get_main_queue(), ^{
         
             [_privateUserInfo setValuesForKeysWithDictionary:recvDic];
             
             //登录的时候进行发送通知
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAccountHandlerUseProfileDidChangeNotification" object:nil];
            
         });//主队列，主线程
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        
     }];
}

@end
