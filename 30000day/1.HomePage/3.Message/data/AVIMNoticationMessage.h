//
//  AVIMNoticationMessage.h
//  30000day
//
//  Created by GuoJia on 16/6/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AVIMTypedMessage.h"

static AVIMMessageMediaType const AVIMMessageMediaTypeNotification = 100;//int8_t 最大是127，最小是-127，如果超过这个范围赋值就会出现问题

@interface AVIMNoticationMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

@end
