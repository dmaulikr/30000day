//
//  CDChatVC.m
//  LeanChat
//
//  Created by lzw on 15/4/10.
//  Copyright (c) 2015年 LeanCloud. All rights reserved.
//

#import "CDChatVC.h"

@interface CDChatVC ()

@end

@implementation CDChatVC

- (instancetype)initWithConversation:(AVIMConversation *)conv {
    
    self = [super initWithConversation:conv];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackgroundColor:RGBACOLOR(247, 247, 247, 1)];
}

@end
