//
//  LONetworkCache.m
//  LianjiaOnlineApp
//
//  Created by GuoJia on 15/12/10.
//  Copyright © 2015年 GuoJia. All rights reserved.
//

#import "LONetworkCache.h"

#define ONE_DAY_INTERVAL 86400

#if DEBUG
#	define CHECK_FOR_LONETWORKCACHE_PLIST() if([key isEqualToString:@"LONetworkCache.plist"]) { \
NSLog(@"LONetworkCache.plist is a reserved key and can not be modified."); \
return; }
#else
#	define CHECK_FOR_LONETWORKCACHE_PLIST() if([key isEqualToString:@"LONetworkCache.plist"]) return;
#endif

static inline NSString* cachePathForKey(NSString* directory, NSString* key) {
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return [directory stringByAppendingPathComponent:key];
}

#pragma mark -

@interface LONetworkCache () {
    dispatch_queue_t _cacheInfoQueue;
    dispatch_queue_t _frozenCacheInfoQueue;
    dispatch_queue_t _diskQueue;
    NSMutableDictionary* _cacheInfo;
    NSString* _directory;
    BOOL _needsSave;
}

@property(nonatomic,copy) NSDictionary* frozenCacheInfo;
@end

@implementation LONetworkCache

+ (instancetype)currentCache {
    return [self globalCache];
}

+ (instancetype)globalCache {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    NSString* cachesDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString* oldCachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"LONetworkCache"] copy];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:oldCachesDirectory]) {
        [[NSFileManager defaultManager] removeItemAtPath:oldCachesDirectory error:NULL];
    }
    
    cachesDirectory = [[[cachesDirectory stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"LONetworkCache"] copy];
    return [self initWithCacheDirectory:cachesDirectory];
}

- (instancetype)initWithCacheDirectory:(NSString*)cacheDirectory {
    if((self = [super init])) {
        _cacheInfoQueue = dispatch_queue_create("com.enormego.egocache.info", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(priority, _cacheInfoQueue);
        
        _frozenCacheInfoQueue = dispatch_queue_create("com.enormego.egocache.info.frozen", DISPATCH_QUEUE_SERIAL);
        priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_set_target_queue(priority, _frozenCacheInfoQueue);
        
        _diskQueue = dispatch_queue_create("com.enormego.egocache.disk", DISPATCH_QUEUE_CONCURRENT);
        priority = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_set_target_queue(priority, _diskQueue);
        
        
        _directory = cacheDirectory;
        
        _cacheInfo = [[NSDictionary dictionaryWithContentsOfFile:cachePathForKey(_directory, @"LONetworkCache.plist")] mutableCopy];
        
        if(!_cacheInfo) {
            _cacheInfo = [[NSMutableDictionary alloc] init];
        }
        
        [[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:NULL];
        
        NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
        NSMutableArray* removedKeys = [[NSMutableArray alloc] init];
        
        for(NSString* key in _cacheInfo) {
            if([_cacheInfo[key] timeIntervalSinceReferenceDate] <= now) {
                [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
                [removedKeys addObject:key];
            }
        }
        
        [_cacheInfo removeObjectsForKeys:removedKeys];
        self.frozenCacheInfo = _cacheInfo;
        [self setDefaultTimeoutInterval:ONE_DAY_INTERVAL * 3];
    }
    
    return self;
}

- (void)clearCache {
    dispatch_sync(_cacheInfoQueue, ^{
        for(NSString* key in _cacheInfo) {
            [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
        }
        
        [_cacheInfo removeAllObjects];
        
        dispatch_sync(_frozenCacheInfoQueue, ^{
            self.frozenCacheInfo = [_cacheInfo copy];
        });
        
        [self setNeedsSave];
    });
}

- (void)removeCacheForKey:(NSString*)key {
    CHECK_FOR_LONETWORKCACHE_PLIST();
    
    dispatch_async(_diskQueue, ^{
        [[NSFileManager defaultManager] removeItemAtPath:cachePathForKey(_directory, key) error:NULL];
    });
    
    [self setCacheTimeoutInterval:0 forKey:key];
}

- (BOOL)hasCacheForKey:(NSString*)key {
    NSDate* date = [self dateForKey:key];
    if(date == nil) return NO;
    if([date timeIntervalSinceReferenceDate] < CFAbsoluteTimeGetCurrent()) return NO;
    
    return [[NSFileManager defaultManager] fileExistsAtPath:cachePathForKey(_directory, key)];
}

- (NSDate*)dateForKey:(NSString*)key {
    __block NSDate* date = nil;
    
    dispatch_sync(_frozenCacheInfoQueue, ^{
        date = (self.frozenCacheInfo)[key];
    });
    
    return date;
}

- (NSArray*)allKeys {
    __block NSArray* keys = nil;
    
    dispatch_sync(_frozenCacheInfoQueue, ^{
        keys = [self.frozenCacheInfo allKeys];
    });
    
    return keys;
}

- (void)setCacheTimeoutInterval:(NSTimeInterval)timeoutInterval forKey:(NSString*)key {
    NSDate* date = timeoutInterval > 0 ? [NSDate dateWithTimeIntervalSinceNow:timeoutInterval] : nil;
    
    // Temporarily store in the frozen state for quick reads
    dispatch_sync(_frozenCacheInfoQueue, ^{
        NSMutableDictionary* info = [self.frozenCacheInfo mutableCopy];
        
        if(date) {
            info[key] = date;
        } else {
            [info removeObjectForKey:key];
        }
        
        self.frozenCacheInfo = info;
    });
    
    // Save the final copy (this may be blocked by other operations)
    dispatch_async(_cacheInfoQueue, ^{
        if(date) {
            _cacheInfo[key] = date;
        } else {
            [_cacheInfo removeObjectForKey:key];
        }
        
        dispatch_sync(_frozenCacheInfoQueue, ^{
            self.frozenCacheInfo = [_cacheInfo copy];
        });
        
        [self setNeedsSave];
    });
}

#pragma mark -
#pragma mark Copy file methods

- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key {
    [self copyFilePath:filePath asKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)copyFilePath:(NSString*)filePath asKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    dispatch_async(_diskQueue, ^{
        [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:cachePathForKey(_directory, key) error:NULL];
    });
    
    [self setCacheTimeoutInterval:timeoutInterval forKey:key];
}

#pragma mark -
#pragma mark Data methods

- (void)setData:(NSData*)data forKey:(NSString*)key {
    [self setData:data forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setData:(NSData*)data forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    CHECK_FOR_LONETWORKCACHE_PLIST();
    
    NSString* cachePath = cachePathForKey(_directory, key);
    
    dispatch_async(_diskQueue, ^{
        [data writeToFile:cachePath atomically:YES];
    });
    
    [self setCacheTimeoutInterval:timeoutInterval forKey:key];
}

- (void)setNeedsSave {
    dispatch_async(_cacheInfoQueue, ^{
        if(_needsSave) return;
        _needsSave = YES;
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, _cacheInfoQueue, ^(void){
            if(!_needsSave) return;
            [_cacheInfo writeToFile:cachePathForKey(_directory, @"LONetworkCache.plist") atomically:YES];
            _needsSave = NO;
        });
    });
}

- (NSData*)dataForKey:(NSString*)key {
    if([self hasCacheForKey:key]) {
        return [NSData dataWithContentsOfFile:cachePathForKey(_directory, key) options:0 error:NULL];
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark Object methods

- (id<NSCoding>)objectForKey:(NSString*)key {
    if([self hasCacheForKey:key]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[self dataForKey:key]];
    } else {
        return nil;
    }
}

- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key {
    [self setObject:anObject forKey:key withTimeoutInterval:self.defaultTimeoutInterval];
}

- (void)setObject:(id<NSCoding>)anObject forKey:(NSString*)key withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [self setData:[NSKeyedArchiver archivedDataWithRootObject:anObject] forKey:key withTimeoutInterval:timeoutInterval];
}


@end
