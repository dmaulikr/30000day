//
//  XHMessageModel.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XHMessageBubbleFactory.h"

typedef NS_ENUM(NSInteger, XHMessageStatus){
    XHMessageStatusSending,
    XHMessageStatusSent,
    XHMessageStatusReceived,
    XHMessageStatusFailed,
};

@class XHMessage;

@protocol XHMessageModel <NSObject>

@required
- (NSString *)text;

- (UIImage *)photo;
- (NSString *)thumbnailUrl;
- (NSString *)originPhotoUrl;

- (UIImage *)videoConverPhoto;
- (NSString *)videoConverPhotoURL;
- (NSString *)videoPath;
- (NSString *)videoUrl;
- (CGFloat)photoWitdh;//需要显示的图片宽
- (CGFloat)photoHeight;//需要显示的图片高


- (NSString *)voicePath;
- (NSString *)voiceUrl;
- (NSString *)voiceDuration;

- (UIImage *)localPositionPhoto;
- (NSString *)geolocations;
- (CLLocation *)location;

- (NSString *)emotionPath;

- (UIImage *)avator;
- (NSString *)avatorUrl;

- (XHBubbleMessageMediaType)messageMediaType;

- (XHBubbleMessageType)bubbleMessageType;

@optional

- (NSString *)sender;

- (NSDate *)timestamp;

- (BOOL)isRead;
- (void)setIsRead:(BOOL)isRead;

- (XHMessageStatus)status;

@end

