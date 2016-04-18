//
//  CDConvsVC.h
//  LeanChat
//
//  Created by lzw on 15/4/10.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDChatListVC.h"

@interface CDConvsVC : CDChatListVC

@property (nonatomic,copy) void (^unreadMessageChange)(NSInteger totalUnreadCount);//未读消息个数改变发出的通知

@end
