//
//  AppDelegate.m
//  30000day
//
//  Created by GuoJia on 16/1/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppDelegate.h"
#import "JHAPISDK.h"
#import "JHOpenidSupplier.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#define kApplicationId @"m7baukzusy3l5coew0b3em5uf4df5i2krky0ypbmee358yon"
#define kClientKey @"2e46velw0mqrq3hl2a047yjtpxn32frm0m253k258xo63ft9"

@import HealthKit;

@interface AppDelegate ()

@property (nonatomic) HKHealthStore *healthStore1;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //***********************************配置获取健康信息*******************************//
    if ([HKHealthStore isHealthDataAvailable]) {
        
        _healthStore1 = [[HKHealthStore alloc] init];
        
        NSSet *readDataTypes = [self dataTypesToRead];
        
        [_healthStore1 requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            
            if (!success) {
                NSLog(@"You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: %@. If you're using a simulator, try it on a device.", error);
                return;
            }
        }];
        
    }
    
    //***********************************设置聚合SDK的APPID*******************************//
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:jhOpenID];
    
    /******** UMeng分享 ********/
    [UMSocialData setAppKey:@"56c6d04f67e58e0833000755"];
    
    [MobClick startWithAppkey:@"56c6d04f67e58e0833000755" reportPolicy:BATCH channelId:nil];
    
    [MobClick setAppVersion:BUNDEL_VERSION];
    
    [MobClick setCrashReportEnabled:NO];
    
    [UMSocialWechatHandler setWXAppId:@"" appSecret:@"" url:@"http://www.umeng.com/social"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3403884903" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialQQHandler  setQQWithAppId:@"1105117617" appKey:@"XuTcDNJbNvk1LpkG" url:@"http://www.umeng.com/social"];
    
    
    //**************初始化 LeanCloud******//
    [AVOSCloud setApplicationId:@"Y53KlD1EfKwLOgoVv4onj3jh-gzGzoHsz" clientKey:@"FgrznsRALF0F8c1vOFYe45j2"];
#ifdef DEBUG
    [AVAnalytics setAnalyticsEnabled:NO];
    [AVOSCloud setVerbosePolicy:kAVVerboseShow];
    [AVLogger addLoggerDomain:AVLoggerDomainIM];
    [AVLogger addLoggerDomain:AVLoggerDomainCURL];
    [AVLogger setLoggerLevelMask:AVLoggerLevelAll];
#endif
    
    return YES;
}

//如果此时你的客户端 软件仍在打开，则会调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    if ([userInfo[@"myNotification"] isEqualToString:@"myNotification"]) {//表示是我们添加的提醒
        
        UIApplicationState state = application.applicationState;
        
        if (state == UIApplicationStateActive) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[notification.userInfo objectForKey:@"alertTitle"]
                                                            message:notification.alertBody
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            
            
            
            [alert show];
            
        }
        
    } else {//系统的通知，或者推送
        
        
        
        
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    
    if (result == FALSE) {
        
        //调用其他SDK，例如支付宝SDK等
    }
    
    return result;
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKQuantityType *stairsCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    HKQuantityType *movingDistanceCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    return [NSSet setWithObjects: stepCountType,stairsCountType,movingDistanceCountType, nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
