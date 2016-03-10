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


#import "CDAbuseReport.h"
#import "CDCacheManager.h"
#import "CDUtils.h"
#import "CDAddRequest.h"
#import "LZPushManager.h"
#import <iRate/iRate.h>
#import <iVersion/iVersion.h>
#import "CDChatManager.h"
#import "CDIMService.h"
#import <AVOSCloudCrashReporting/AVOSCloudCrashReporting.h>
#import "CDUserManager.h"
#import "CDSoundManager.h"

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
    
    //***********************************初始化LeanCloud*********************************//
    [AVOSCloud setApplicationId:@"Y53KlD1EfKwLOgoVv4onj3jh-gzGzoHsz" clientKey:@"FgrznsRALF0F8c1vOFYe45j2"];
    
    [iRate sharedInstance].applicationBundleID = @"com.shutian.30000day";
    
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    [iRate sharedInstance].previewMode = NO;
    
    [iVersion sharedInstance].applicationBundleID = @"com.shutian.30000day";
    
    [iVersion sharedInstance].previewMode = NO;
    
    [AVOSCloud setLastModifyEnabled:YES];
    
    [[LZPushManager manager] registerForRemoteNotification];//配置推送
    
    [CDAddRequest registerSubclass];
    
    [CDAbuseReport registerSubclass];

#ifdef DEBUG
    [AVPush setProductionMode:NO];  //如果要测试申请好友是否有推送，请设置为 YES
//    [AVOSCloud setAllLogsEnabled:YES];
#endif
    
    [self initAnalytics];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

- (void)initAnalytics {
    [AVAnalytics setAnalyticsEnabled:YES];
#ifdef DEBUG
    [AVAnalytics setChannel:@"Debug"];
#else
    [AVAnalytics setChannel:@"App Store"];
#endif
    // 应用每次启动都会去获取在线参数，这里同步获取即可。可能是上一次启动获取得到的在线参数。不过没关系。
    NSDictionary *configParams = [AVAnalytics getConfigParams];
    DLog(@"configParams: %@", configParams);
}

- (void)openChatCompletion:(void (^)(BOOL success))success
                   failure:(void (^)(NSError *))failure {
    
    [CDChatManager manager].userDelegate = [CDIMService service];

#ifdef DEBUG
    //使用开发证书来推送，方便调试，具体可看这个变量的定义处
    [CDChatManager manager].useDevPushCerticate = YES;
#endif
    
    [[CDChatManager manager] openWithClientId:[NSString stringWithFormat:@"%@",[Common readAppDataForKey:KEY_SIGNIN_USER_UID]] callback: ^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                success(YES);
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
               failure(error);
                
            });
        }
        
    }];
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
        
        //  当使用 https://github.com/leancloud/leanchat-cloudcode 云代码更改推送内容的时候
        //        {
        //            aps =     {
        //                alert = "lzwios : sdfsdf";
        //                badge = 4;
        //                sound = default;
        //            };
        //            convid = 55bae86300b0efdcbe3e742e;
        //        }
        [[CDChatManager manager] didReceiveRemoteNotification:userInfo];
        
        [AVAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
        
        DLog(@"receiveRemoteNotification");
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    
    if (result == FALSE) {
        
        //调用其他SDK，例如支付宝SDK等
    }
    
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[LZPushManager manager] syncBadge];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[LZPushManager manager] syncBadge];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[LZPushManager manager] saveInstallationWithDeviceToken:deviceToken userId:[Common readAppDataForKey:KEY_SIGNIN_USER_UID]];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
    
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKQuantityType *stairsCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierFlightsClimbed];
    
    HKQuantityType *movingDistanceCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    return [NSSet setWithObjects: stepCountType,stairsCountType,movingDistanceCountType, nil];
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

@end
