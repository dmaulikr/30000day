//
//  AVIMAcceptMessage.h
//  30000day
//
//  Created by GuoJia on 16/6/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AVIMTypedMessage.h"

@interface AVIMAcceptMessage : AVIMTypedMessage <AVIMTypedMessageSubclassing>

+ (instancetype)messageWithContent:(NSString *)content attributes:(NSDictionary *)attributes;

@end
