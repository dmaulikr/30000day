//
//  UIView+Extension.h
//  郭佳微博
//
//  Created by admin on 15/4/7.
//  Copyright (c) 2015年 guojia. All rights reserved.
//  封装的设置x,y,width,height对屏幕适配有一点用处

#import <UIKit/UIKit.h>

@interface UIView (Extension)//扩展只能扩展方法不能扩展变量
@property(nonatomic,assign)  CGFloat x;
@property(nonatomic,assign)  CGFloat y;
@property(nonatomic,assign)  CGFloat centerX;
@property(nonatomic,assign)  CGFloat centerY;

@property(nonatomic,assign)  CGFloat width;
@property(nonatomic,assign)  CGFloat height;
@property(nonatomic,assign)  CGSize size;
@property(nonatomic,assign)  CGPoint origin;
@end
