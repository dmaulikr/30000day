//
//  UIView+Extension.m
//  郭佳微博
//
//  Created by admian on 15/4/7.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
//所以这边只有方法
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x  = x;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;

    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerX {
    
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
    
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;

    self.frame = frame;
}

- (CGFloat)y {
    
    return self.frame.origin.y;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.bounds;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGSize)size {
    return self.frame.size;
}
@end
