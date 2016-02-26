//
//  RemindContentTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/25.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "RemindContentTableViewCell.h"

@implementation RemindContentTableViewCell

- (void)awakeFromNib {
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    longPress.minimumPressDuration = 1.0;
    
    [self addGestureRecognizer:longPress];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    if (self.longPressBlock) {
        
        self.longPressBlock(self.longPressIndexPath);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
