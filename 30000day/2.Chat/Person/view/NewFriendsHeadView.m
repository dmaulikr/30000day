//
//  NewFriendsHeadView.m
//  30000day
//
//  Created by WeiGe on 16/6/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "NewFriendsHeadView.h"

@implementation NewFriendsHeadView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
    
    [self addGestureRecognizer:tapGesture];

}


-  (void)viewClick {

    if (self.viewClickBlock) {
        self.viewClickBlock();
    }

}


@end
