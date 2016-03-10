//
//  MDRadialProgressView.m
//  30000天
//
//  Created by 30000天_001 on 14-10-16.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressLabel.h"
#import "MDRadialProgressTheme.h"

@interface MDRadialProgressView ()

// Padding from the view bounds to the outer circumference of the view.
// Useful because at times the circle may appear "cut" by one or two pixels
// since it's drawing over the view bounds.
@property (assign, nonatomic) NSUInteger internalPadding;

@end


@implementation MDRadialProgressView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:[MDRadialProgressTheme standardTheme]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInitWithTheme:theme];
    }
    return self;
}

- (void)awakeFromNib
{
    [self internalInitWithTheme:[MDRadialProgressTheme standardTheme]];
}

- (void)dealloc {
    [self removeObserver:self.label forKeyPath:keyThickness];
}

- (void)internalInitWithTheme:(MDRadialProgressTheme *)theme
{
    // Default values for public properties
	self.progressTotal = 1;
	self.progressCounter = 0;
	self.startingSlice = 1;
    self.clockwise = YES;
	
	// Use standard theme by default
	self.theme = theme;
	
	// Init the progress label, even if not visible.
	self.label = [[MDRadialProgressLabel alloc] initWithFrame:self.bounds andTheme:self.theme];
	[self addSubview:self.label];
	
	// Private properties
	self.internalPadding = 2;
	
	// Accessibility
	self.isAccessibilityElement = YES;
	self.accessibilityLabel = NSLocalizedString(@"Progress", nil);
	
	// Important to avoid showing artifacts
	self.backgroundColor = [UIColor clearColor];
	
	// Register the progress label for changes in the thickness so that it can be repositioned.
	[self addObserver:self.label forKeyPath:keyThickness options:NSKeyValueObservingOptionNew context:nil];
    
    self.label.hidden = YES;
}

#pragma mark - Setters

- (void)setProgressCounter:(float)progressCounter
{
	_progressCounter = progressCounter;
	[self notifyProgressChange];
	[self setNeedsDisplay];
}

- (void)setProgressTotal:(float)progressTotal
{
	_progressTotal = progressTotal;
	[self notifyProgressChange];
	[self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    if (self.progressTotal <= 0) {
        return;
    }
    
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGSize viewSize = self.bounds.size;
	CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
	
    // Draw the slices.
	CGFloat radius = viewSize.width / 2 - self.internalPadding;
    [self drawSlices:self.progressTotal
		   completed:self.progressCounter
			  radius:radius
			  center:center
		   inContext:contextRef];
	
	// Draw the slice separators.
	[self drawSlicesSeparators:contextRef withViewSize:viewSize andCenter:center];
	
    // Draw the center.
	[self drawCenter:contextRef withViewSize:viewSize andCenter:center];
}

- (void)drawSlices:(NSUInteger)slicesCount
         completed:(NSUInteger)slicesCompleted
            radius:(CGFloat)circleRadius
            center:(CGPoint)center
         inContext:(CGContextRef)context
{
    BOOL cgClockwise = !self.clockwise;
    NSUInteger startingSlice = self.startingSlice -1;
    
	if (!self.theme.sliceDividerHidden && self.theme.sliceDividerThickness > 0) {
		// Draw one arc at a time.
        
        CGFloat sliceAngle = (2 * M_PI ) / slicesCount;
        for (int i =0; i < slicesCount; i++) {
            CGFloat startValue = (sliceAngle * i) + sliceAngle * startingSlice;
            CGFloat startAngle, endAngle;
            if (self.clockwise) {
                startAngle = - M_PI_2 + startValue;
				endAngle = startAngle + sliceAngle;
            } else {
                startAngle = - M_PI_2 - startValue;
				endAngle = startAngle - sliceAngle;
            }
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, circleRadius,
							startAngle, endAngle, cgClockwise);
            
            CGColorRef color = self.theme.incompletedColor.CGColor;
            
            if (i < slicesCompleted) {
                color = self.theme.completedColor.CGColor;
            }
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
        }
    } else {
		// Draw just two arcs, one for the completed slices and one for the
		// uncompleted ones.
		
        CGFloat originAngle, endAngle;
		CGFloat sliceAngle = (2 * M_PI) / self.progressTotal;
		CGFloat startingAngle = sliceAngle * startingSlice;
//        NSLog(@"%lf",sliceAngle * self.progressCounter);
        
        CGFloat speedProgress=sliceAngle * self.progressCounter;
        
        if (speedProgress < 0.01) {
            speedProgress = speedProgress * 10;
        }
        
		CGFloat progressAngle = speedProgress;
		
		if (self.progressCounter == 0) {
			originAngle = -M_PI_2;
			endAngle = originAngle + 2 * M_PI;
		} else {
			if (self.clockwise) {
				originAngle = -M_PI_2 + startingAngle;
				endAngle = originAngle + progressAngle;
			} else {
				originAngle = -M_PI_2 - startingAngle;
				endAngle = originAngle - progressAngle;
			}
		}
		
		// Draw the arcs grouped instead of individually to avoid
		// artifacts between one slice and another.
		
		// Completed slices.
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, circleRadius, originAngle, endAngle, cgClockwise);
		CGColorRef color = self.theme.completedColor.CGColor;
		CGContextSetFillColorWithColor(context, color);
		CGContextFillPath(context);
		
		if (self.progressCounter < self.progressTotal) {
			// Incompleted slices
			CGContextBeginPath(context);
			CGContextMoveToPoint(context, center.x, center.y);
			CGFloat startAngle = endAngle;
			endAngle = originAngle;
			CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, originAngle, cgClockwise);
			color = self.theme.incompletedColor.CGColor;
			CGContextSetFillColorWithColor(context, color);
			CGContextFillPath(context);
		}
	}
}

- (void)drawSlicesSeparators:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int outerDiameter = viewSize.width;
    float outerRadius = outerDiameter / 2 - self.internalPadding;
    int innerDiameter = outerDiameter - self.theme.thickness;
    float innerRadius = innerDiameter / 2;
    
    if (! self.theme.sliceDividerHidden) {
        float sliceCount = self.progressTotal;
        float sliceAngle = (2 * M_PI) / sliceCount;
        CGContextSetLineWidth(contextRef, self.theme.sliceDividerThickness);
        CGContextSetStrokeColorWithColor(contextRef, self.theme.sliceDividerColor.CGColor);
        for (int i = 0; i < sliceCount; i++) {
            double startAngle = sliceAngle * i - M_PI_2;
			double endAngle = sliceAngle * (i + 1) - M_PI_2;
            
			CGContextBeginPath(contextRef);
			CGContextMoveToPoint(contextRef, center.x, center.y);
			
			// Draw the outer arc
			CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle, endAngle, 0);
			// Draw the inner arc. The separator line is drawn automatically when moving from
			// the point where the outer arc ended to the point where the inner arc starts.
			CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle, startAngle, 1);
			
			CGContextSetStrokeColorWithColor(contextRef, self.theme.sliceDividerColor.CGColor);
			CGContextStrokePath(contextRef);
        }
    }
}

- (void)drawCenter:(CGContextRef)contextRef withViewSize:(CGSize)viewSize andCenter:(CGPoint)center
{
	int innerDiameter = viewSize.width - self.theme.thickness;
    float innerRadius = innerDiameter / 2;
	
	CGContextSetLineWidth(contextRef, self.theme.thickness);
	CGRect innerCircle = CGRectMake(center.x - innerRadius, center.y - innerRadius,
									innerDiameter, innerDiameter);
	CGContextAddEllipseInRect(contextRef, innerCircle);
	CGContextClip(contextRef);
	CGContextClearRect(contextRef, innerCircle);
	CGContextSetFillColorWithColor(contextRef, self.theme.centerColor.CGColor);
	CGContextFillRect(contextRef, innerCircle);
}

# pragma mark - Accessibility

- (UIAccessibilityTraits)accessibilityTraits
{
	return [super accessibilityTraits] | UIAccessibilityTraitUpdatesFrequently;
}

# pragma mark - Notifications
# pragma mark 设置文字的地方
- (void)notifyProgressChange
{
	// Update the accessibilityValue and the progressSummaryView text.
	float percentageCompleted = (100.0f / self.progressTotal) * self.progressCounter;
	
	self.accessibilityValue = [NSString stringWithFormat:@"%.2f", percentageCompleted];
    
	self.label.text = [NSString stringWithFormat:@"%ld\n%.2f",(long)self.progressCounter,self.progressTotal];
    if (self.progressCounter == -1 || self.progressTotal == -1) {
        self.label.text = [NSString stringWithFormat:@"请先设置\n您的生日"];
    }
    
	NSString *notificationText = [NSString stringWithFormat:@"%@ %@",
								  NSLocalizedString(@"Progress changed to:", nil),
								  self.accessibilityValue];
	UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, notificationText);
}


@end
