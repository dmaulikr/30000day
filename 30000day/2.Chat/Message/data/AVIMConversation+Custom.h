//
//  AVIMConversation+CustomAttributes.h
//  LeanChatLib
//
//  Created by lzw on 15/4/8.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>

#define CONVERSATION_TYPE @"type"

typedef enum : NSUInteger {
    CDConversationTypeSingle = 0,
    CDConversationTypeGroup,
} CDConversationType;

@interface AVIMConversation (Custom)
/**
 *  最后一条消息。通过 SDK 的消息缓存找到的
 */
@property (nonatomic, strong) AVIMTypedMessage *lastMessage;

/**
 *  未读消息数，保存在了数据库。收消息的时候，更新数据库
 */
@property (nonatomic, assign) NSNumber *unreadCount;

/**
 *  是否有人提到了你，配合 @ 功能。不能看最后一条消息。
 *  因为可能倒数第二条消息提到了你，所以维护一个标记。
 */
@property (nonatomic, assign) BOOL mentioned;

/**
 *  对话的类型，因为可能是两个人的群聊。所以不能通过成员数量来判断
 *
 *  @return 单聊或群聊
 */
- (CDConversationType)type;

/**
 *  单聊对话的对方的 clientId
 */
- (NSString *)otherId;

/**
 *  对话中会员的的名称
 */
- (NSString *)memberName:(NSString *)memberClientId;

/**
 *
 * 根据对方Id取到对方原本的昵称
 **/
- (NSString *)originNickName:(NSString *)memberClientId;

/**
 *  对话显示的名称。单聊显示对方名字，群聊显示对话的name
 */
- (NSString *)conversationDisplayName;

/**
 *  对话对方的头像url,头像根据clientId去匹配
 */
- (NSString *)headUrl:(NSString *)clientId;

/**
 *  对话显示的公告，目前只限于群聊
 */
- (NSString *)groupChatNotice;

/**
 * 获取群主的名字，如何当前有给群主昵称那么显示昵称,目前仅限于群聊
 */
- (NSString *)groupChatAdminName;

/**
 * 获取群聊的群头像URL,目前仅限于群聊
 */
- (NSString *)groupChatImageURL;


/**
 *  对话的图标，通过 conversationId 生成五彩图像
 */
- (UIImage *)icon;

@end