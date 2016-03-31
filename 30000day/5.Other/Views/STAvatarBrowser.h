//
//  STAvatarBrowser.h
//  30000day
//
//  Created by GuoJia on 16/3/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  封装的点击显示大图控件

#import <Foundation/Foundation.h>

static NSString *STAvatarBrowserDidHideAvatarImage = @"STAvatarBrowserDidHideAvatarImage";

@interface STAvatarBrowser : NSObject

/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像的image
 */
+ (void)showImage:(UIImage *)avatarImage;

/**
 *	@brief	浏览头像
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
+ (void)showImageView:(UIImageView *)avatarImageView;


@end
