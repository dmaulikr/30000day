//
//  AppDelegate.h
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

//开启聊天之旅的信息
- (void)openChat:(NSNumber *)userId
      completion:(void (^)(BOOL success))success
                                  failure:(void (^)(NSError *))failure;

@end

