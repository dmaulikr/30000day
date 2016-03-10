//
//  MDRadialProgressLabel.m
//  30000天
//
//  Created by 30000天_001 on 14-10-16.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "MDRadialProgressLabel.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"

// iOS6 has deprecated UITextAlignment* in favour of NSTextAlignment*
// This allow me to use the property from iOS < 6.
#ifdef __IPHONE_6_0
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#endif


@interface MDRadialProgressLabel ()

@property (assign, nonatomic) CGRect originalFrame;

@end


@implementation MDRadialProgressLabel

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme
{
    self = [super initWithFrame:frame];
    if (self) {
		
		// Center it in the frame.
		CGPoint center = CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y+ frame.size.height / 2);
		self.center = center;
		
		// Reduce the bounds according to the thickness declared in the theme.
		// This may change later, see observeValueForKeyPath...
		CGFloat offset = theme.thickness;
		CGFloat width = frame.size.width - offset;
		CGFloat height = frame.size.height - offset;
		CGRect adjustedFrame = CGRectMake(frame.origin.x + offset, frame.origin.y + offset, width, height);
		self.bounds = adjustedFrame;
		// Customise appearance
		self.font = theme.font;
		self.textAlignment = UITextAlignmentCenter;
		self.textColor = [UIColor colorWithRed:109.0/255 green:157.0/255 blue:234.0/255 alpha:1.0];
		self.pointSizeToWidthFactor = 0.5;
		self.adjustFontSizeToFitBounds = YES;
		if (theme.dropLabelShadow) {
			self.shadowColor = theme.labelShadowColor;
			self.shadowOffset = theme.labelShadowOffset;
		}
		
		// Align horizontally and vertically (numberOfLines) the label.
		self.numberOfLines = 0;
		self.adjustsFontSizeToFitWidth = YES;
		
		// Very important because iOS 6 uses a white color which will results
		// in the label drawing over the MDRadialProgressView.
		self.backgroundColor = [UIColor clearColor];
    }
	
    return self;
}


- (void)drawRect:(CGRect)rect
{
	if (self.adjustFontSizeToFitBounds) {
		// adjustsFontSizeToFitWidth works but the text look too big when the progress view is small.
		// This scale down the font until its point size is less than pointSizeToWidthFactor of the bounds' width.
//        NSLog(@"%lf",self.pointSizeToWidthFactor);
//        NSLog(@"%lf",rect.size.width);
//        NSLog(@"%lf",self.font.pointSize);
		CGFloat maxWidth = rect.size.width * self.pointSizeToWidthFactor;
        self.font = [self.font fontWithSize:maxWidth/2.8];
		
	}
	
	[super drawRect:rect];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:keyThickness]) {
		MDRadialProgressView *view = (MDRadialProgressView *)object;
		CGFloat offset = view.theme.thickness;
		CGRect frame = view.frame;
		CGRect adjustedFrame = CGRectMake(frame.origin.x + offset, frame.origin.y + offset,
										  frame.size.width - offset, frame.size.height - offset);
		
		self.bounds = adjustedFrame;
		[self setNeedsLayout];
	}
}



@end
