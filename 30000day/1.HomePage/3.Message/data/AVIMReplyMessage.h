//
//  AVIMReplyMessage.h
//  30000day
//
//  Created by GuoJia on 16/9/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <AVOSCloudIM/AVOSCloudIM.h>

static AVIMMessageMediaType const AVIMMessageMediaReply = 98;//int8_t 最大是127，最小是-127，如果超过这个范围赋值就会出现问题
@interface AVIMReplyMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

@end
