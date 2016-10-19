//
//  CDChatListController.h
//  LeanChat
//
//  Created by Qihe Bian on 7/25/14.
//  Copyright (c) 2014 LeanCloud. All rights reserved.
//

#import "AVIMConversation+Custom.h"
#import "LZConversationCell.h"

/**
 *  最近对话页面
 */
@interface CDChatListVC : STRefreshViewController

@property (nonatomic,copy) void (^badgeNumberBlock)(NSInteger);

@end
