//
//  MDRadialProgressTheme.m
//  30000天
//
//  Created by 30000天_001 on 14-10-16.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "MDRadialProgressTheme.h"

static const int kMaxFontSize = 22;


@implementation MDRadialProgressTheme

+ (id)themeWithName:(const NSString *)themeName
{
	return [[MDRadialProgressTheme alloc] init];
}

+ (id)standardTheme
{
	return [MDRadialProgressTheme themeWithName:STANDARD_THEME];
}

- (id)init
{
	self = [super init];
	if (self) {
		// View
		self.completedColor = [UIColor greenColor];
		self.incompletedColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		self.sliceDividerColor = [UIColor whiteColor];
		self.centerColor = [UIColor clearColor];
		self.thickness = 35;
		self.sliceDividerHidden = NO;
		self.sliceDividerThickness = 2;
		
		// Label
		self.labelColor = [UIColor blackColor];
		self.dropLabelShadow = YES;
		self.labelShadowColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
		self.labelShadowOffset = CGSizeMake(1, 1);
		self.font = [UIFont systemFontOfSize:kMaxFontSize];
	}
	
	return self;
}

@end
