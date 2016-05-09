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
#import "UMSocial.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <AlipaySDK/AlipaySDK.h>
#import "JPUSHService.h"

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
#import "STCoreDataHandler.h"
#import "STLocationMananger.h"
#import "SearchTableVersion.h"


#define kApplicationId @"m7baukzusy3l5coew0b3em5uf4df5i2krky0ypbmee358yon"
#define kClientKey @"2e46velw0mqrq3hl2a047yjtpxn32frm0m253k258xo63ft9"

@import HealthKit;

@interface AppDelegate () {
    
    BMKMapManager* _mapManager;
}
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
    
    //***********************************配置JPush*******************************//
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:@"1f961fd96fccd78eeb958e08" channel:@"Publish channel" apsForProduction:NO];
    
    //***********************************设置聚合SDK的APPID*******************************//
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:jhOpenID];
    
    /******** UMeng分享 ********/
    [UMSocialData setAppKey:@"56c6d04f67e58e0833000755"];
    
    [UMSocialWechatHandler setWXAppId:@"wx18ea1411855f610f" appSecret:@"6ef9e5d4cfee4b009c3705aa0b24e727" url:@"http://www.umeng.com/social"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3403884903" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialQQHandler  setQQWithAppId:@"1105117619" appKey:@"XuTcDNJbNvk1LpkG" url:@"http://www.umeng.com/social"];
    
    //***********************************初始化LeanCloud*********************************//
    [AVOSCloudCrashReporting enable];//打开凌云崩溃报告
    
    [AVOSCloud setApplicationId:@"0t5NyhngDJQBB3x5S8KEIUWT-gzGzoHsz" clientKey:@"nNXF4pHFlb6d3TydcNE5ohdq"];
    
    [iRate sharedInstance].applicationBundleID = @"com.shutian.30000day";
    
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    
    [iRate sharedInstance].previewMode = NO;
    
    [iVersion sharedInstance].applicationBundleID = @"com.shutian.30000day";
    
    [iVersion sharedInstance].previewMode = NO;
    
    //********要使用百度地图，请先启动BaiduMapManager ********/、
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:@"fSt6Niw70uNQDMa6Oh9aoyCSuulWoU7o" generalDelegate:self];//
    if (!ret) {
        NSLog(@"manager start failed!");
    }

//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]; // UITextAttributeTextColor
    
    STDataHandler *dataHandler = [[STDataHandler alloc] init];
    [dataHandler sendSearchTableVersion:^(NSMutableArray *success) {
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSArray *searchTableVersionArray = [defaults objectForKey:KEY_SEARCHTABLEVERSION];
        
        if (searchTableVersionArray.count == 0 || searchTableVersionArray == nil) {
            
            NSMutableArray *successArray = [NSMutableArray array];
            
            for (int i = 0; i < success.count; i++) {
                
                NSMutableDictionary *successDictionary = [NSMutableDictionary dictionary];
                SearchTableVersion *searchTableVersionSuccess = success[i];
                
                [successDictionary setObject:searchTableVersionSuccess.searchTableVersionId forKey:@"searchTableVersionId"];
                [successDictionary setObject:searchTableVersionSuccess.tableName forKey:@"tableName"];
                [successDictionary setObject:searchTableVersionSuccess.version forKey:@"version"];
                
                [successArray addObject:successDictionary];
                
            }
            
            //同步省-城市-区、县的数据
            [[STLocationMananger shareManager] synchronizedLocationDataFromServer];
            
            NSArray *array = [NSArray arrayWithArray:successArray];
            
            [defaults setObject:array forKey:KEY_SEARCHTABLEVERSION];
            
            [defaults synchronize];
            
        } else {
        
            if (searchTableVersionArray.count == success.count) {
            
            for (int i = 0; i < success.count; i++) {
                
                SearchTableVersion *searchTableVersionSuccess = success[i];
                NSDictionary *searchTableVersion = searchTableVersionArray[i];
                
                if ([[NSString stringWithFormat:@"%@",searchTableVersionSuccess.searchTableVersionId] isEqualToString:[[searchTableVersion objectForKey:@"searchTableVersionId"] stringValue]]) {
                    
                    if (![[NSString stringWithFormat:@"%@",searchTableVersionSuccess.version] isEqualToString:[NSString stringWithFormat:@"%@",[searchTableVersion objectForKey:@"version"]]]) {
                        
                        //同步省-城市-区、县的数据
                        [[STLocationMananger shareManager] synchronizedLocationDataFromServer];
                        
                        NSMutableArray *successArray = [NSMutableArray array];
                        
                        for (int i = 0; i < success.count; i++) {
                            
                            NSMutableDictionary *successDictionary = [NSMutableDictionary dictionary];
                            SearchTableVersion *searchTableVersionSuccess = success[i];
                            
                            [successDictionary setObject:searchTableVersionSuccess.searchTableVersionId forKey:@"searchTableVersionId"];
                            [successDictionary setObject:searchTableVersionSuccess.tableName forKey:@"tableName"];
                            [successDictionary setObject:searchTableVersionSuccess.version forKey:@"version"];
                            
                            [successArray addObject:successDictionary];
                            
                        }
                        
                        NSArray *array = [NSArray arrayWithArray:successArray];
                        [defaults setObject:array forKey:KEY_SEARCHTABLEVERSION];
                        [defaults synchronize];

                    } else {
                    
                        NSLog(@"没有更新");
                    
                    }
                    
                } else {
                    
                    NSLog(@"后台数据表版本信息顺序有调整");
                    
                }
            }
                
                } else {
                    
                    NSLog(@"后台数据表版本数量有改动");
                    
                }
                
            }
        
    } failure:^(NSError *error) {
        
        NSLog(@"获取数据版本信息失败！！！！！！！！！！！！！！！");
        
    }];

    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)openChat:(NSNumber *)userId
      completion:(void (^)(BOOL success))success
         failure:(void (^)(NSError *))failure {
    
#ifdef DEBUG
    //使用开发证书来推送，方便调试，具体可看这个变量的定义处
    [CDChatManager manager].useDevPushCerticate = YES;
#endif
    
    [[CDChatManager manager] openWithClientId:[NSString stringWithFormat:@"%@",userId] callback: ^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                success(YES);
                
                [STNotificationCenter postNotificationName:STDidSuccessConnectLeanCloudViewSendNotification object:nil];
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
        
    } else {
        
        
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    
    if (result == FALSE) {
        
        //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
        if ([url.host isEqualToString:@"safepay"]) {
            
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                
                 if ([resultDic[@"resultStatus"] isEqualToString:@"6001"] ) {
                     
                     UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"您已取消支付" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                     
                     [alertview show];
                     
                 } else if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                     
                     [STNotificationCenter postNotificationName:STDidSuccessPaySendNotification object:nil];
                 }
             }];
            
        } else {
            
//            return [WXApi handleOpenURL:url delegate:self] || [WeiboSDK handleOpenURL:url delegate:self] ||[TencentOAuth HandleOpenURL:url];
        }
        return YES;
    }
    
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[LZPushManager manager] syncBadge];
}

//点击了home键,程序进入后台了
- (void)applicationWillTerminate:(UIApplication *)application {
    
    [self saveContext];//保存还未保存的变化
}

- (void)saveContext {
    
    NSError *error = nil;
    
    if ([[STCoreDataHandler shareCoreDataHandler].bgObjectContext hasChanges]) {
        
        [[STCoreDataHandler shareCoreDataHandler].bgObjectContext save:&error];
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
//    rootViewController.deviceTokenValueLabel.text =
//    [NSString stringWithFormat:@"%@", deviceToken];
//    rootViewController.deviceTokenValueLabel.textColor =
//    [UIColor colorWithRed:0.0 / 255
//                    green:122.0 / 255
//                     blue:255.0 / 255
//                    alpha:1];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];

    if (application.applicationState == UIApplicationStateActive) {
        
        NSString *cancelTitle = @"取消";
        
        NSString *showTitle = @"去查看";
        
        NSString *message = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:cancelTitle
                                                  otherButtonTitles:showTitle, nil];
        [alertView show];
    }
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
