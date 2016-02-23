//
//  LONetworkAgent.h
//  30000day
//
//  LONetworkAgent 负责执行 request，并且 request 的 hash 值来记录运行中的request
//  具有停止request等能力
//
//  Created by GuoJia on 15/12/11.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LORequest.h"
@interface LONetworkAgent : NSObject

typedef NS_ENUM(NSInteger, LONetworkReachabilityStatus) {
    
    LONetworkReachabilityStatusUnknown      = -1,
    
    LONetworkReachabilityStatusNotReachable = 0,
    
    LONetworkReachabilityStatus3G           = 1,
    
    LONetworkReachabilityStatusWiFi         = 2,
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
- (LONetworkReachabilityStatus)networkReachabilityStatus;


//------------------------------------------------------------------------------
/**
 *  添加并发起一个网络请求
 *
 *  @param request        服务器数据请求的地址, 不能为空
 *
 *  @return 请求的Hash编码值
 */
- (NSString *)addRequest:(LORequest *)request;


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
