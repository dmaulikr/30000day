//
//  LONetworkCache.h
//  LianjiaOnlineApp
//  主要用来缓存一些最近的请求 
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//
#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#if !__has_feature(nullability)
#	define nullable
#	define nonnull
#	define __nullable
#	define __nonnull
#endif


@interface LONetworkCache : NSObject


+ (nonnull instancetype)currentCache __deprecated_msg("Renamed to globalCache");

// Global cache for easy use
+ (nonnull instancetype)globalCache;

// Opitionally create a different FTNetworkCache instance with it's own cache directory
- (nonnull instancetype)initWithCacheDirectory:(NSString* __nonnull)cacheDirectory;

- (void)clearCache;
- (void)removeCacheForKey:(NSString* __nonnull)key;

- (BOOL)hasCacheForKey:(NSString* __nonnull)key;

- (NSData* __nullable)dataForKey:(NSString* __nonnull)key;
- (void)setData:(NSData* __nonnull)data forKey:(NSString* __nonnull)key;
- (void)setData:(NSData* __nonnull)data forKey:(NSString* __nonnull)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (NSDate* __nullable)dateForKey:(NSString* __nonnull)key;
- (NSArray* __nonnull)allKeys;

- (void)copyFilePath:(NSString* __nonnull)filePath asKey:(NSString* __nonnull)key;
- (void)copyFilePath:(NSString* __nonnull)filePath asKey:(NSString* __nonnull)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

- (nullable id<NSCoding>)objectForKey:(NSString* __nonnull)key;
- (void)setObject:(nonnull id<NSCoding>)anObject forKey:(NSString* __nonnull)key;
- (void)setObject:(nonnull id<NSCoding>)anObject forKey:(NSString* __nonnull)key withTimeoutInterval:(NSTimeInterval)timeoutInterval;

@property(nonatomic) NSTimeInterval defaultTimeoutInterval; // Default is 1 day

@end
