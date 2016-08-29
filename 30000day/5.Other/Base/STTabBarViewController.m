//
//  STTabBarViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STTabBarViewController.h"
#import "CDChatManager.h"

@interface STTabBarViewController ()

@end

@implementation STTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *controllerArray = self.viewControllers;
    
    for (int i = 0; i < controllerArray.count; i++) {
        
        UIViewController *controller = controllerArray[i];
        
        if (i == 0) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectHomePage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        } else if (i == 1) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_messages"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        } else if (i == 2) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_txl"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            
            
        } else if (i == 3) {
            
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectMy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
#pragma mark ---- 以下修改app和底部tabBarItem角标的方法
    //1.有人请求加为好友
    [STNotificationCenter addObserver:self selector:@selector(changeState) name:STDidApplyAddFriendSendNotification object:nil];
    //2.成功连接上凌云服务器
    [STNotificationCenter addObserver:self selector:@selector(getUnreadMessageBadge) name:STDidSuccessConnectLeanCloudViewSendNotification object:nil];
    //3.收到消息
    [STNotificationCenter addObserver:self selector:@selector(getUnreadMessageBadge) name:kCDNotificationMessageReceived object:nil];
    //4.未读消息变化
    [STNotificationCenter addObserver:self selector:@selector(getUnreadMessageBadge) name:kCDNotificationUnreadsUpdated object:nil];
}

- (void)getUnreadMessageBadge {

    [[CDChatManager sharedManager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        
        dispatch_block_t finishBlock = ^{
    
            if (!error) {
                
                NSArray *controllerArray = self.viewControllers;
                UIViewController *controller = controllerArray[1];
                
                if (totalUnreadCount > 0 || [Common readAppBoolDataForkey:USER_BADGE_NUMBER]) {
                    
//                    if (totalUnreadCount >= 100) {
//                        
//                        controller.tabBarItem.badgeValue = @"99+";
//                        
//                    } else {
//                        
//                        controller.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)totalUnreadCount];
//                    }
//                    
//                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalUnreadCount];
                    
                    //成功链接聊天，查询是否有人添加好友
//                    NSArray *controllerArray = self.viewControllers;
//                    UIViewController *controller = controllerArray[2];
                    controller.tabBarItem.badgeValue = @"";//显示底部badge
                    
                } else {
                    
//                    controller.tabBarItem.badgeValue = nil;
//                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                    
//                    NSArray *controllerArray = self.viewControllers;
//                    UIViewController *controller = controllerArray[2];
                    controller.tabBarItem.badgeValue = nil;//显示底部badge
                }
            }
        };
        
        finishBlock();
    }];
    

}

- (void)changeState {

    NSArray *controllerArray = self.viewControllers;
    UIViewController *controller = controllerArray[1];
    controller.tabBarItem.badgeValue = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [STNotificationCenter removeObserver:self name:STDidApplyAddFriendSendNotification object:nil];
    [STNotificationCenter removeObserver:self name:STDidSuccessConnectLeanCloudViewSendNotification object:nil];
    [STNotificationCenter removeObserver:self name:kCDNotificationMessageReceived object:nil];
    [STNotificationCenter removeObserver:self name:kCDNotificationUnreadsUpdated object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
