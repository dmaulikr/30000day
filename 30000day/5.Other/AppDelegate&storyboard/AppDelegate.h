//
//  AppDelegate.h
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//开启聊天之旅的信息
- (void)openChatCompletion:(void (^)(BOOL success))success
                                  failure:(void (^)(NSError *))failure;

@end

