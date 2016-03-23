//
//  Height.h
//  Share
//
//  Created by ls on 15/8/8.
//  Copyright (c) 2015年 dllo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Height : NSObject

+(CGFloat)heightWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize;

+(CGFloat)widthWithText:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize;
@end
