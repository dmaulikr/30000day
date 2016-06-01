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
    
    [self registerSubclass];
}

- (instancetype)init {
    
    if ((self = [super init])) {
        
        self.mediaType = [[self class] classMediaType];
    }
    
    return self;
}

+ (AVIMMessageMediaType)classMediaType {
    
    return 233;
}

+ (instancetype)messageWithContent:(NSString *)content attributes:(NSDictionary *)attributes {
    
    AVIMRequestMessage *message = [[self alloc] init];
    
    message.text = content;
    
    message.attributes = attributes;
    
    return message;
}

@end
