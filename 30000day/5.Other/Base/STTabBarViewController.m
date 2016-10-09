//
//  STTabBarViewController.m
//  30000day
//
//  Created by GuoJia on 16/2/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STTabBarViewController.h"
#import "CDChatManager.h"
#import "STPraiseReplyCoreDataStorage.h"


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
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"seleteMedium"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else if (i == 3) {
            controller.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectMy"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            controller.tabBarItem.image = [[UIImage imageNamed:@"my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
#pragma mark ---- 以下修改app和底部tabBarItem角标的方法
    //1.有人请求加为好友
    [STNotificationCenter addObserver:self selector:@selector(changeState) name:STDidApplyAddFriendSendNotification object:nil];
    //2.成功连接上凌云服务器
    [STNotificationCenter addObserver:self selector:@selector(didSuccessConnectLeanCloud) name:STDidSuccessConnectLeanCloudViewSendNotification object:nil];
    //3.收到消息
    [STNotificationCenter addObserver:self selector:@selector(getUnreadMessageBadge) name:kCDNotificationMessageReceived object:nil];
    //4.未读消息变化
    [STNotificationCenter addObserver:self selector:@selector(getUnreadMessageBadge) name:kCDNotificationUnreadsUpdated object:nil];
    //有人点赞或者回复
    [STNotificationCenter addObserver:self selector:@selector(sameReplyPraise:) name:STSameBodyReplyPraiseSendNotification object:nil];
    //成功的获取userId
    [STNotificationCenter addObserver:self selector:@selector(querySameBodyReplyPraise:) name:STUserAccountHandlerUseProfileDidChangeNotification object:nil];
}

- (void)didSuccessConnectLeanCloud {
    [self getUnreadMessageBadge];
}
- (void)getUnreadMessageBadge {
    [[CDChatManager sharedManager] findRecentConversationsWithBlock:^(NSArray *conversations, NSInteger totalUnreadCount, NSError *error) {
        
        dispatch_block_t finishBlock = ^{
            if (!error) {
                NSArray *controllerArray = self.viewControllers;
                UIViewController *controller = controllerArray[1];
                if (totalUnreadCount > 0 || [Common readAppBoolDataForkey:USER_BADGE_NUMBER]) {
                    controller.tabBarItem.badgeValue = @"";//显示底部badge
                } else {
                    controller.tabBarItem.badgeValue = nil;//显示底部badge
                }
            }
        };
        finishBlock();
    }];
}

- (void)sameReplyPraise:(NSNotification *)notification {
    NSArray *controllerArray = self.viewControllers;
    UIViewController *controller = controllerArray[2];
    controller.tabBarItem.badgeValue = @"";//显示底部badge
}

//查询是否有人给你发信息
- (void)querySameBodyReplyPraise:(NSNotification *)notification {
    NSMutableArray *replyArray_1 = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] getPraiseMesssageArrayWithVisibleType:@1 readState:@1 offset:0 limit:0]];
    NSMutableArray *praiseArray_1 = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] geReplyMesssageArrayWithVisibleType:@1 readState:@1 offset:0 limit:0]];
    NSMutableArray *replyArray_2 = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] getPraiseMesssageArrayWithVisibleType:@2 readState:@1 offset:0 limit:0]];
    NSMutableArray *praiseArray_2 = [[NSMutableArray alloc] initWithArray:[[STPraiseReplyCoreDataStorage shareStorage] geReplyMesssageArrayWithVisibleType:@2 readState:@1 offset:0 limit:0]];
    if (replyArray_1.count || praiseArray_1.count || replyArray_2.count || praiseArray_2.count ) {
        NSArray *controllerArray = self.viewControllers;
        UIViewController *controller = controllerArray[2];
        controller.tabBarItem.badgeValue = @"";
    } else {
        NSArray *controllerArray = self.viewControllers;
        UIViewController *controller = controllerArray[2];
        controller.tabBarItem.badgeValue = nil;
    }
}

- (void)changeState {
    NSArray *controllerArray = self.viewControllers;
    UIViewController *controller = controllerArray[1];
    controller.tabBarItem.badgeValue = @"";
}

- (void)dealloc {
    [STNotificationCenter removeObserver:self name:STSameBodyReplyPraiseSendNotification object:nil];
    [STNotificationCenter removeObserver:self name:STDidApplyAddFriendSendNotification object:nil];
    [STNotificationCenter removeObserver:self name:STDidSuccessConnectLeanCloudViewSendNotification object:nil];
    [STNotificationCenter removeObserver:self name:kCDNotificationMessageReceived object:nil];
    [STNotificationCenter removeObserver:self name:kCDNotificationUnreadsUpdated object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
