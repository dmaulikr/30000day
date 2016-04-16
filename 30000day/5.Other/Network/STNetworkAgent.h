//
//  STNetworkAgent.h
//  30000day
//
//  Created by GuoJia on 16/4/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STRequest.h"

@interface STNetworkAgent : NSObject

typedef NS_ENUM(NSInteger, STNetworkReachabilityStatus) {
    
    STNetworkReachabilityStatusUnknown      = -1,
    
    STNetworkReachabilityStatusNotReachable = 0,
    
    STNetworkReachabilityStatus3G           = 1,
    
    STNetworkReachabilityStatusWiFi         = 2,
};

+ (instancetype)sharedAgent;


//------------------------------------------------------------------------------
/**
 *  测试网络连接状况
 *
 *  @return YES:有网络 NO:无网络
 */
- (BOOL)isReachable;


//------------------------------------------------------------------------------
/**
 *  网络状态监控
 *
 *  @return 返回明确的网络状态
 */
- (STNetworkReachabilityStatus)networkReachabilityStatus;


//------------------------------------------------------------------------------
/**
 *  添加并发起一个网络请求
 *
 *  @param request        服务器数据请求的地址, 不能为空
 *
 *  @return 请求的Hash编码值
 */
- (NSString *)addRequest:(STRequest *)request;


//------------------------------------------------------------------------------
/**
 *  取消一系列网络请求
 *
 *  @param requestHashArray    请求的Hash编码值数组
 *
 *  @return 返回明确的网络状态
 */
- (void)cancelRequestsWithHashArray:(NSArray *)requestHashArray;


//------------------------------------------------------------------------------
/**
 *  取消全部网络请求
 */
- (void)cancelAllRequests;

@property (strong, nonatomic, readonly) NSMutableDictionary *urlFilters;

@end