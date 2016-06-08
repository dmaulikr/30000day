///
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
#import <AdSupport/AdSupport.h>

#import "LZPushManager.h"
#import <iVersion/iVersion.h>
#import "CDChatManager.h"
#import "STCoreDataHandler.h"
#import "STLocationMananger.h"
#import "SearchVersionManager.h"
#import "NewFriendManager.h"
#import "STDataHandler.h"


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
    
//    NSString *isFirstStartString = [Common readAppDataForKey:FIRSTSTARTHKHEALTHSTORE];
//    
//    if ([Common isObjectNull:isFirstStartString]) {
//        
//        [Common saveAppDataForKey:FIRSTSTARTHKHEALTHSTORE withObject:@"1"];
//        
//        //提示用户
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"”30000天“想访问您的运动记录" message:@"30000天想访问您的运动记录，用于计算天龄" delegate:self cancelButtonTitle:@"不予许" otherButtonTitles:@"好", nil];
//        
//        [alertView show];
//        
//    } else {

        //***********************************配置获取健康信息*******************************//
        if ([HKHealthStore isHealthDataAvailable]) {
            
            _healthStore1 = [[HKHealthStore alloc] init];
            
            NSSet *readDataTypes = [self dataTypesToRead];
            
            [_healthStore1 requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
                
                if (!success) {
                    
                    NSLog(@"error = %@", error);
                    
                    return;
                }
            }];
        }
        
   // }
    
//    //设置需要获取的权限这里仅设置了步数
//    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
//    
//    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//    
//    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
//    
//    //从健康应用中获取权限
//    [healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
//        
//        if (success) {
//            NSLog(@"获取步数权限成功");
//
//        } else {
//            NSLog(@"获取步数权限失败");
//        }
//    }];

    
    //***********************************配置JPush*******************************//
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions appKey:@"1f961fd96fccd78eeb958e08" channel:@"Publish channel" apsForProduction:YES advertisingIdentifier:advertisingId];
    
    //***********************************设置聚合SDK的APPID*******************************//
    [[JHOpenidSupplier shareSupplier] registerJuheAPIByOpenId:jhOpenID];
    
    /******** UMeng分享 ********/
    [UMSocialData setAppKey:@"56c6d04f67e58e0833000755"];
    
    [UMSocialWechatHandler setWXAppId:@"wx18ea1411855f610f" appSecret:@"6ef9e5d4cfee4b009c3705aa0b24e727" url:@"http://www.umeng.com/social"];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2624326542" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialQQHandler  setQQWithAppId:@"1105319699" appKey:@"ICTHVJyulerm5QOo" url:@"http://www.umeng.com/social"];
    
    //***********************************初始化LeanCloud*********************************//
    [AVOSCloud setApplicationId:@"0t5NyhngDJQBB3x5S8KEIUWT-gzGzoHsz" clientKey:@"nNXF4pHFlb6d3TydcNE5ohdq"];

    [iVersion sharedInstance].applicationBundleID = @"com.shutian.30000day";
    
    [iVersion sharedInstance].previewMode = NO;
    
    //********要使用百度地图，请先启动BaiduMapManager ********/、
//    _mapManager = [[BMKMapManager alloc] init];
//    
//    BOOL ret = [_mapManager start:@"fSt6Niw70uNQDMa6Oh9aoyCSuulWoU7o" generalDelegate:self];
//    
//    if (!ret) {
//        
//        NSLog(@"manager start failed!");
//    }
    
    //初始化版本控制器
    [[SearchVersionManager shareManager] synchronizedDataFromServer];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//如果此时你的客户端 软件仍在打开，则会调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    UIApplicationState state = application.applicationState;
    
    if (state == UIApplicationStateActive) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[notification.userInfo objectForKey:@"alertTitle"]
                                                        message:notification.alertBody
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if ([userInfo[CALENDAR_NOTIFICATION] isEqualToString:CALENDAR_NOTIFICATION]) {//表示是我们添加的提醒
        
        
    } else if([userInfo[WORK_REST_NOTIFICATION] isEqualToString:WORK_REST_NOTIFICATION]){//健康作息
        
        
    } else if([userInfo[CHECK_NOTIFICATION] isEqualToString:CHECK_NOTIFICATION]){//体检提醒

     if ([Common isObjectNull:[[Common readAppDataForKey:CHECK_REPEAT] stringValue]]) {//无记录
         
         if (notification.repeatInterval != NSCalendarUnitYear) {//半年的提醒
             
             [[UIApplication sharedApplication] cancelLocalNotification:notification];
             
         } else {
             
         }
         
     } else {
         
         if ([[Common readAppDataForKey:CHECK_REPEAT] isEqualToNumber:@0]) {//半年
            
             [[UIApplication sharedApplication] cancelLocalNotification:notification];
             
         } else {//1年
             
             
         }
     }
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
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
    
    if (application.applicationState == UIApplicationStateActive) {
        
        NSString *type = [userInfo valueForKey:@"jpushType"];
        
        if ([type isEqualToString:@"1"]) {//正在等待验证
            
        } else if ([type isEqualToString:@"2"]) {//接受
            
            
        } else if ([type isEqualToString:@"3"]) {//拒绝
            
        }
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


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex) {
//        
//        //***********************************配置获取健康信息*******************************//
//        if ([HKHealthStore isHealthDataAvailable]) {
//            
//            _healthStore1 = [[HKHealthStore alloc] init];
//            
//            NSSet *readDataTypes = [self dataTypesToRead];
//            
//            [_healthStore1 requestAuthorizationToShareTypes:nil readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
//                
//                if (!success) {
//                    
//                    NSLog(@"error = %@", error);
//                    
//                    return;
//                }
//            }];
//        }
//        
//    }
//    
//}

@end
