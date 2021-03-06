//
//  XHMessage.h
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XHMessageModel.h"

@interface XHMessage : NSObject <XHMessageModel, NSCoding, NSCopying>

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *originPhotoUrl;
@property (nonatomic, assign) CGFloat photoWitdh;//需要显示的图片宽
@property (nonatomic, assign) CGFloat photoHeight;//需要显示的图片高


@property (nonatomic, strong) UIImage *videoConverPhoto;
@property (nonatomic, copy) NSString *videoConverPhotoURL;//视频缩略图服务器地址
@property (nonatomic, copy) NSString *videoPath;
@property (nonatomic, copy) NSString *videoUrl;


@property (nonatomic, copy) NSString *voicePath;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, copy) NSString *voiceDuration;

@property (nonatomic, copy) NSString *emotionPath;

@property (nonatomic, strong) UIImage *localPositionPhoto;
@property (nonatomic, copy) NSString *geolocations;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) UIImage *avator;
@property (nonatomic, copy) NSString *avatorUrl;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, copy) NSString *senderOriginNickNname;//发送者原本的昵称,用来比对群聊的中是否有人@你

@property (nonatomic, strong) NSDate *timestamp;

@property (nonatomic, assign) BOOL sended;

@property (nonatomic, assign) XHBubbleMessageMediaType messageMediaType;

@property (nonatomic, assign) XHBubbleMessageType bubbleMessageType;

@property (nonatomic) BOOL isRead;

@property (nonatomic,assign) XHMessageStatus status;

- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                   timestamp:(NSDate *)timestamp;

/**
 *  初始化图片类型的消息
 *
 *  @param photo          目标图片
 *  @param thumbnailUrl   目标图片在服务器的缩略图地址
 *  @param originPhotoUrl 目标图片在服务器的原图地址
 *  @param photoWitdh     目标图片缩略图的宽度
 *  @param photoHeight    目标图片缩略图的高度
 *  @param sender         发送者
 *  @param date           发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithPhoto:(UIImage *)photo
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                   photoWitdh:(CGFloat)photoWitdh
                  photoHeight:(CGFloat)photoHeight
                       sender:(NSString *)sender
                    timestamp:(NSDate *)timestamp;

/**
 *  初始化视频类型的消息
 *
 *  @param videoConverPhoto 目标视频的封面图
 *  @param videoConverPhotoURL 目标视频缩略图在服务器的地址
 *  @param videoPath        目标视频的本地路径，如果是下载过，或者是从本地发送的时候，会存在
 *  @param videoUrl         目标视频在服务器上的地址
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVideoConverPhoto:(UIImage *)videoConverPhoto
                     videoConverPhotoURL:(NSString *)videoConverPhotoURL
                               videoPath:(NSString *)videoPath
                                videoUrl:(NSString *)videoUrl
                              photoWitdh:(CGFloat)photoWitdh
                             photoHeight:(CGFloat)photoHeight
                                  sender:(NSString *)sender
                               timestamp:(NSDate *)timestamp;

/**
 *  初始化语音类型的消息
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp;

/**
 *  初始化语音类型的消息。增加已读未读标记
 *
 *  @param voicePath        目标语音的本地路径
 *  @param voiceUrl         目标语音在服务器的地址
 *  @param voiceDuration    目标语音的时长
 *  @param sender           发送者
 *  @param date             发送时间
 *  @param isRead           已读未读标记
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                           sender:(NSString *)sender
                        timestamp:(NSDate *)timestamp
                           isRead:(BOOL)isRead;

- (instancetype)initWithEmotionPath:(NSString *)emotionPath
                             sender:(NSString *)sender
                          timestamp:(NSDate *)timestamp;

- (instancetype)initWithLocalPositionPhoto:(UIImage *)localPositionPhoto
                              geolocations:(NSString *)geolocations
                                  location:(CLLocation *)location
                                    sender:(NSString *)sender
                                 timestamp:(NSDate *)timestamp;
/**
 *  初始化通知类型的消息
 *
 *  @param messageText      通知消息的正文
 *  @param sender           发送者
 *  @param timestamp        发送时间
 *
 *  @return 返回Message model 对象
 */
- (instancetype)initWithNotificationMessageText:(NSString *)messageText
                                         sender:(NSString *)sender
                                      timestamp:(NSDate *)timestamp;

@end
