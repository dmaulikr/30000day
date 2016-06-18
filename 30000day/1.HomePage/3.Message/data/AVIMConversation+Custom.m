//
//  AVIMConversation+CustomAttributes.m
//  LeanChatLib
//
//  Created by lzw on 15/4/8.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "AVIMConversation+Custom.h"
#import "CDChatManager.h"
#import "UIImage+Icon.h"
#import <objc/runtime.h>
#import "PersonInformationsManager.h"

@implementation AVIMConversation (Custom)

- (AVIMTypedMessage *)lastMessage {
    
    return objc_getAssociatedObject(self, @selector(lastMessage));
}

- (void)setLastMessage:(AVIMTypedMessage *)lastMessage {
    
    objc_setAssociatedObject(self, @selector(lastMessage), lastMessage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)unreadCount {
    
    return objc_getAssociatedObject(self, @selector(unreadCount));
}

- (void)setUnreadCount:(NSNumber *)unreadCount {
    
    objc_setAssociatedObject(self, @selector(unreadCount),unreadCount, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)mentioned {
    
    return [objc_getAssociatedObject(self, @selector(mentioned)) boolValue];
}

- (void)setMentioned:(BOOL)mentioned {
    
    objc_setAssociatedObject(self, @selector(mentioned), @(mentioned), OBJC_ASSOCIATION_ASSIGN);
}

- (CDConversationType)type {
    
    return [[self.attributes objectForKey:CONVERSATION_TYPE] intValue];
}

/**
 *  对话中会员的的名称
 */
- (NSString *)memberName:(NSString *)memberClientId {
    
    NSDictionary *otherDictionary = self.attributes;
    
    NSDictionary *newDictionay = [otherDictionary objectForKey:memberClientId];
    
    if (![Common isObjectNull:[[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[memberClientId longLongValue]]].nickName]) {
        
        return [[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[memberClientId longLongValue]]].nickName;
        
    } else {
        
        return [newDictionay objectForKey:ORIGINAL_NICK_NAME];
    }
}

/**
 *  对话显示的名称。单聊显示对方名字，群聊显示对话的name
 */
- (NSString *)conversationDisplayName {
    
    if ([self type] == CDConversationTypeSingle) {
        
        NSDictionary *otherDictionary = self.attributes;
        
        NSString *clientId = [self otherId];
        
        NSDictionary *newDictionay = [otherDictionary objectForKey:clientId];
        
        if (![Common isObjectNull:[[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[clientId longLongValue]]].nickName]) {
            
            return [[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[clientId longLongValue]]].nickName;
            
        } else {
            
            return [newDictionay objectForKey:ORIGINAL_NICK_NAME];
        }
        
    } else {
        
        return self.name;
    }
}

/**
 *  对话显示的公告，目前只限于群聊
 */
- (NSString *)groupChatNotice {
    
    NSDictionary *dictionary = self.attributes;
    
    NSString *notice = [dictionary objectForKey:CONVERSATION_NOTICE];
    
    if (notice) {//表示有设置自定义的属性
        
        return notice;
        
    } else {//表示没有设置自定义的属性
        
        return @"暂无公告";
    }
}

/**
 * 获取群主的名字，如何当前有给群主昵称那么显示昵称,目前仅限于群聊
 */
- (NSString *)groupChatAdminName {
    
    NSDictionary *otherDictionary = self.attributes;
    
    NSString *clientId = self.creator;
    
    NSDictionary *newDictionay = [otherDictionary objectForKey:clientId];
    
    if (![Common isObjectNull:[[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[clientId longLongValue]]].nickName]) {
        
        return [[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[clientId longLongValue]]].nickName;
        
    } else {
        
        return [newDictionay objectForKey:ORIGINAL_NICK_NAME];
    }
}

/**
 *  对话对方的头像url。单聊对方的头像，群聊头像根据clientId去匹配
 */
- (NSString *)headUrl:(NSString *)clientId {
    
    NSDictionary *otherDictionary = self.attributes;
    
    NSDictionary *newDictionay = [otherDictionary objectForKey:clientId];
    
    if ([[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[clientId longLongValue]]] && ![Common isObjectNull:[[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[clientId longLongValue]]].headImg]) {
        
        return [[PersonInformationsManager shareManager] infoWithFriendId:[NSNumber numberWithLongLong:[clientId longLongValue]]].headImg;
        
    } else {
        
        if ([Common isObjectNull:[newDictionay objectForKey:ORIGINAL_IMG_URL]]) {//表示这人在attributes无记录
            
            return @"";
            
        } else {
            
            return [newDictionay objectForKey:ORIGINAL_IMG_URL];
        }
    }
}

- (NSString *)otherId {
    
    NSArray *members = self.members;
    
    if (members.count == 0) {
        return INVALID_CONVERSATION;
    }
    
    if (members.count == 1) {
        
        return members[0];
    }
    
    NSString *otherId;
    
    if ([members[0] isEqualToString:[CDChatManager sharedManager].clientId]) {
        
        otherId = members[1];
        
    } else {
        
        otherId = members[0];
    }
    
    return otherId;
}

/**
 * 获取群聊的群头像URL,目前仅限于群聊
 */
- (NSString *)groupChatImageURL {
    
    NSDictionary *otherDictionary = self.attributes;
    
    return [otherDictionary objectForKey:CONVERSATION_IMAGE_URL];
}

- (UIImage *)icon {
    
    NSString *name = self.name;
    
    if (name.length == 0) {
        
        name = @"Conversation";
    }
    
    return [UIImage imageWithHashString:self.conversationId displayString:[[name substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
}

@end
