//
//  AVIMAcceptMessage.m
//  30000day
//
//  Created by GuoJia on 16/6/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AVIMAcceptMessage.h"

@implementation AVIMAcceptMessage

+ (void)load {
    
    [self registerSubclass];
}

+ (AVIMMessageMediaType)classMediaType {
    
    return YourAcceptMessageTypeOperation;
}

+ (instancetype)messageWithContent:(NSString *)content attributes:(NSDictionary *)attributes {
    
    AVIMAcceptMessage *message = [super messageWithText:content attachedFilePath:nil attributes:nil];
    
    message.text = content;
    
    message.attributes = attributes;
    
    return message;
}

@end
