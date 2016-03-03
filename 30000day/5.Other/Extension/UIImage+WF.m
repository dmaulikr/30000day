//
//  UIImage+WF.m
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-19.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "UIImage+WF.h"

@implementation UIImage (WF)

+ (UIImage *)stretchedImageWithName:(NSString *)name {
    
    UIImage *image = [UIImage imageNamed:name];
    int leftCap = image.size.width * 0.5;
    int topCap = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

+ (UIImage *)stretchedImageWithimage:(UIImage *)image {
    
    int leftCap = image.size.width * 0.5;
    int topCap = image.size.height * 0.5;
    return [image stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, self.size.height-5);
    
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextClipToMask(context, rect, self.CGImage);
    
    [color setFill];
    
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
