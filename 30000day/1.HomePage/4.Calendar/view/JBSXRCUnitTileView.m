//
//  JBSXRCUnitTileView.m
//  30000天
//
//  Created by 30000天_001 on 14-12-9.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "JBSXRCUnitTileView.h"
#import <QuartzCore/QuartzCore.h>

@interface JBSXRCUnitTileView ()

@end

@implementation JBSXRCUnitTileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.eventCountLabel.hidden = NO;
        
        self.dayLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        
        CGRect lunarLabelFrame = self.lunarLabel.frame;
        lunarLabelFrame.origin.y = self.bounds.size.height/5*4;
        lunarLabelFrame.size.height = self.bounds.size.height/5;
        self.lunarLabel.frame = lunarLabelFrame;
        
        self.lunarLabel.font = [UIFont systemFontOfSize:9.0f];
        self.lunarLabel.textColor = [UIColor grayColor];
        
        self.lunarLabel.hidden = NO;
    }
    return self;
}


/**************************************************************
 *模版方法，设置Tile的显示
 **************************************************************/
- (void)updateUnitTileViewShowingWithOtherUnit:(BOOL)otherUnit Selected:(BOOL)selected Today:(BOOL)today eventsCount:(NSInteger)eventsCount
{
    [super updateUnitTileViewShowingWithOtherUnit:otherUnit Selected:selected Today:today eventsCount:eventsCount];
    
    if (otherUnit) {
        self.dayLabel.textColor = [UIColor grayColor];
        self.lunarLabel.textColor = [UIColor grayColor];
    } else {
        if (selected) {
            self.dayLabel.textColor = [UIColor redColor];
            self.lunarLabel.textColor = [UIColor redColor];
        } else if (today) {
            self.dayLabel.textColor = [UIColor blueColor];
            self.lunarLabel.textColor = [UIColor blueColor];
        } else {
            self.dayLabel.textColor = [UIColor blackColor];
            self.lunarLabel.textColor = [UIColor blackColor];
        }
    }
    
    if (eventsCount == 0) {
        self.eventCountLabel.text = @"";
    } else {
        self.eventCountLabel.text = [NSString stringWithFormat:@"%li", (long)eventsCount];
    }
}

@end
