//
//  AVIMDirectRefreshMessage.m
//  30000day
//
//  Created by GuoJia on 16/6/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AVIMDirectRefreshMessage.h"

@implementation AVIMDirectRefreshMessage

+ (void)load {
    
    [self registerSubclass];
}

+ (AVIMMessageMediaType)classMediaType {
    
    return YourDirectMessageTypeOperation;
}

+ (instancetype)messageWithContent:(NSString *)content attributes:(NSDictionary *)attributes {
    
    AVIMDirectRefreshMessage *message = [super messageWithText:content attachedFilePath:nil attributes:nil];
    
    message.text = content;
    
    message.attributes = attributes;
    
    return message;
}

@end
