//
//  AVIMRequestMessage.m
//  30000day
//
//  Created by GuoJia on 16/6/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AVIMRequestMessage.h"

@implementation AVIMRequestMessage

+ (void)load {
    
    [AVIMRequestMessage registerSubclass];
}

+ (AVIMMessageMediaType)classMediaType {
    
    return YourRequestMessageTypeOperation;
}

+ (instancetype)messageWithContent:(NSString *)content attributes:(NSDictionary *)attributes {
    
    AVIMRequestMessage *message = [AVIMRequestMessage messageWithText:content file:nil attributes:nil];
    
    message.op = @"av";
    
    message.attributes = attributes;

    return message;
}

@end
