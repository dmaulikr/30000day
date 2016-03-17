//
//  STAvatarBrowser.m
//  30000day
//
//  Created by GuoJia on 16/3/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STAvatarBrowser.h"

@interface STAvatarBrowser ();

@property (nonatomic,copy) void (^completionBlock)();

@end

static CGRect oldframe;

@implementation STAvatarBrowser

+ (void)showImageView:(UIImageView *)avatarImageView {
    
    UIImage *image = avatarImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    
    imageView.image = image;
    
    imageView.tag = 1;
    
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImageView:)];
    
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

+ (void)showImage:(UIImage *)avatarImage {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:avatarImage];

    imageView.tag = 1;
    
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = CGRectMake(0,([UIScreen mainScreen].bounds.size.height - avatarImage.size.height*[UIScreen mainScreen].bounds.size.width/avatarImage.size.width)/2, [UIScreen mainScreen].bounds.size.width, avatarImage.size.height*[UIScreen mainScreen].bounds.size.width/avatarImage.size.width);
        
        backgroundView.alpha = 1;
        
    } completion:nil];
}

+ (void)hideImage:(UITapGestureRecognizer *)tap {
    
    UIView *backgroundView = tap.view;
    
    [UIView animateWithDuration:0.3 animations:^{
    
        backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
    }];
    
    [STNotificationCenter postNotificationName:STAvatarBrowserDidHideAvatarImage object:nil];
}

+ (void)hideImageView:(UITapGestureRecognizer*)tap {
    
    UIView *backgroundView = tap.view;
    
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame = oldframe;
        
        backgroundView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
    }];
    
    [STNotificationCenter postNotificationName:STAvatarBrowserDidHideAvatarImage object:nil];
}

@end
