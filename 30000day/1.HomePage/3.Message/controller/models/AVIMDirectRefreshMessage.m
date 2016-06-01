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

- (instancetype)init {
    
    if ((self = [super init])) {
        
        self.mediaType = [[self class] classMediaType];
        
    }
    
    return self;
}

+ (AVIMMessageMediaType)classMediaType {
    
    return 235;
}

+ (instancetype)messageWithContent:(NSString *)content attributes:(NSDictionary *)attributes {
    
    AVIMDirectRefreshMessage *message = [[self alloc] init];
    
    message.text = content;
    
    message.attributes = attributes;
    
    return message;
}

@end
