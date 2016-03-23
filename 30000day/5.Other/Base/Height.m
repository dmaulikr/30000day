    //
//  Height.m
//  Share
//
//  Created by ls on 15/8/8.
//  Copyright (c) 2015年 dllo. All rights reserved.
//

#import "Height.h"

@implementation Height

+(CGFloat)heightWithText:(NSString *)text width:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    
    return rect.size.height;
}


+(CGFloat)widthWithText:(NSString *)text height:(CGFloat)height fontSize:(CGFloat)fontSize
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
    return rect.size.width;
}
@end
