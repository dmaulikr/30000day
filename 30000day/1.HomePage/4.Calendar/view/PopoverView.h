//
//  PopoverView.h
//  30000天
//
//  Created by 30000天_001 on 14-10-16.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverView : UIView

-(id)initWithPoint:(CGPoint)point titles:(NSArray *)titles images:(NSArray *)images;
-(void)show;
-(void)dismiss;
-(void)dismiss:(BOOL)animated;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@end
