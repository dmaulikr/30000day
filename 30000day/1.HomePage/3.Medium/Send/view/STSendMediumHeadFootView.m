//
//  STSendMediumHeadFootView.m
//  30000day
//
//  Created by GuoJia on 16/8/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STSendMediumHeadFootView.h"

@implementation STSendMediumHeadFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
}

- (IBAction)sendAction:(id)sender {
    
    if (self.sendActionBlock) {
        self.sendActionBlock(sender);
    }
}

@end
