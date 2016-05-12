//
//  NewFriendManager.m
//  30000day
//
//  Created by GuoJia on 16/5/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NewFriendManager.h"
#import "NewFriendModel.H"
#import "YYModel.h"

static NewFriendManager *manager;

@interface NewFriendManager ()

//获取角标的回调
@property(nonatomic,copy)void(^getBadgeNumberBlock)(NSInteger badgeNumber);
//获取数据的回调
@property(nonatomic,copy)void(^getDataBlock)(NSMutableArray *dataArray);

@end

@implementation NewFriendManager

+ (NewFriendManager *)shareManager {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[NewFriendManager alloc] init];
        
        [STNotificationCenter addObserver:manager selector:@selector(synchronizedDataFromServer) name:STDidApplyAddFriendSendNotification object:nil];
    });
    
    return manager;
}

//成功获取到通知:角标刷新
- (void)synchronizedDataFromServer {
    
    [self sendFindAllApplyAddFriendWithUserId:STUserAccountHandler.userProfile.userId
                                      success:^(NSMutableArray *dataArray) {
                                          
                                          int badgeNumber = 0;
                                          
                                          for (int i = 0; i < dataArray.count; i++) {
                                              
                                              NewFriendModel *oldModel = dataArray[i];
                                              
                                              badgeNumber += oldModel.badgeNumber;
                                          }
                                          
                                          if (self.getBadgeNumberBlock) {
                                              
                                              self.getBadgeNumberBlock(badgeNumber);
                                          }
                                          
                                          if (self.getDataBlock) {
                                              
                                              self.getDataBlock(dataArray);
                                          }
                                          
                                      } failure:^(NSError *error) {
                                          
                                          
                                      }];
}


//**********************查找当前有哪些人申请加我为好友【数组里存储的是NewFriendModel】********************//
- (void)sendFindAllApplyAddFriendWithUserId:(NSNumber *)userId
                                    success:(void (^)(NSMutableArray *dataArray))success
                                    failure:(void (^)(NSError *error))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?userId=%@",ST_API_SERVER,FIND_APPLY_ALL_ADD_FRIEND,userId]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (connectionError) {//链接出现问题
            
            failure(connectionError);
            
        } else {//链接没有问题
            
            NSError *localError = nil;
            
            id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError];
            
            if (localError == nil) {
                
                NSDictionary *recvDic = (NSDictionary *)parsedObject;
                
                if ([recvDic[@"code"] isEqualToNumber:@0]) {
                    
                    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                    
                    NSArray *array = recvDic[@"value"];
                    
                    for (int i = 0; i < array.count; i++) {
                        
                        NewFriendModel *model = [NewFriendModel yy_modelWithDictionary:array[i]];
                        
                        BOOL isExist = NO;//默认是不存在
                        
                        NSMutableArray *oldArray = [self decodeObject];
                        
                        for (int i = 0; i < oldArray.count; i++) {
                            
                            NewFriendModel *oldModel = oldArray[i];
                            
                            if ([oldModel.userId isEqualToString:model.userId]) {
                               
                                model.badgeNumber = oldModel.badgeNumber;
                                
                                isExist = YES;
                            }
                        }
                        
                        if (!isExist) {//不存在
                            
                            model.badgeNumber = 1;
                        }
                        
                        [dataArray addObject:model];
                    }
                    
                    //归档到文件
                    [self encodeDataObject:dataArray];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        success(dataArray);
                    });
                    
                } else {
                    
                    NSError *failureError = [[NSError alloc] initWithDomain:@"reverse-DNS" code:10000 userInfo:@{NSLocalizedDescriptionKey:parsedObject[@"msg"]}];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        failure(failureError);
                        
                    });
                }
                
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    failure(localError);
                    
                });
            }
        }
    }];
}


//清除申请好友的角标
- (void)cleanApplyFiendBadgeNumber:(void (^)(NSInteger badgerNumber))success {
    
   [self cleanBadgeNumber];
   
    //在从服务器去拉取
   [self sendFindAllApplyAddFriendWithUserId:STUserAccountHandler.userProfile.userId success:^(NSMutableArray *dataArray) {
       
       [self cleanBadgeNumber];
       
       success(0);
       
    } failure:^(NSError *error) {
       
    }];
    
    success(0);
}

- (void)cleanBadgeNumber {
    
    NSMutableArray *oldArray = [self decodeObject];
    
    for (int i = 0; i < oldArray.count; i++) {
        
        NewFriendModel *oldModel = oldArray[i];
        
        oldModel.badgeNumber = 0;
    }
    
    //清除完后归档
    [self encodeDataObject:oldArray];
}

//获取角标
- (void)getBadgeNumber:(void (^)(NSInteger badgeNumber))success {
    
    //保存角标的代码块
    self.getBadgeNumberBlock = success;
    
    success([self badgeNumber]);
}

- (NSInteger)badgeNumber {
    
    NSMutableArray *oldArray = [self decodeObject];
    
    //先获取本地的角标
    int badgeNumber = 0;
    
    for (int i = 0; i < oldArray.count; i++) {
        
        NewFriendModel *oldModel = oldArray[i];
        
        badgeNumber += oldModel.badgeNumber;
    }
    
    return badgeNumber;
}

//获取所有的数据
- (void)getDataArray:(void (^)(NSMutableArray *dataArray))success {
    
    //保存获取数据的代码块
    self.getDataBlock = success;
    //从服务器去下载
    [self sendFindAllApplyAddFriendWithUserId:STUserAccountHandler.userProfile.userId
                                      success:^(NSMutableArray *dataArray) {
                                          
                                          success(dataArray);
                                          
                                      } failure:^(NSError *error) {
                                          
                                          
                                      }];
    
    success([self decodeObject]);
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STDidApplyAddFriendSendNotification object:nil];
}

@end
