//
//  MDRadialProgressLabel.h
//  30000天
//
//  Created by 30000天_001 on 14-10-16.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRadialProgressTheme;

@interface MDRadialProgressLabel : UILabel

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme;

// If adjustFontSizeToFitBounds is enabled, limit the size of the font to the bounds'width * pointSizeToWidthFactor.
@property (assign, nonatomic) CGFloat pointSizeToWidthFactor;

// Whether the algorithm to autoscale the font size is enabled or not.
@property (assign, nonatomic) BOOL adjustFontSizeToFitBounds;

@end
