//
//  UIImage+WF.h
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-19.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WF)

/**
 *通过工程中图片名字返回中心拉伸的图片
 */
+ (UIImage *)stretchedImageWithName:(NSString *)name;

/**
 *通过给定图片返回中心拉伸的图片
 */
+ (UIImage *)stretchedImageWithimage:(UIImage *)image;

/**
 * 改变图片的颜色
 */
- (UIImage *)imageWithColor:(UIColor *)color;

@end
