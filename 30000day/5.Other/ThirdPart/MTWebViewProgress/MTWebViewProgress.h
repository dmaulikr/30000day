//
//  MTWebViewProgress.h
//  17dong_ios
//
//  Created by win5 on 7/16/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import <Foundation/Foundation.h>

#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif


@interface MTWebViewProgress : NSObject<UIWebViewDelegate>
@property (nonatomic, njk_weak) id<UIWebViewDelegate>webViewProxyDelegate;
@property (nonatomic, copy) void (^MTWebViewProgressBlock)(float progress);
@property (nonatomic, readonly) float progress;
@end


