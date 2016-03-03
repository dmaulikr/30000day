//
//  GJChatViewMessageModel.h
//  GJChat
//
//  Created by guojia on 15/10/8.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOChatViewMessageModel : NSObject

//异步处理数据,主线程返回数据
+ (void)configMessageArrayWithMessageArray:(NSMutableArray *)messageArray
                              FromClientId:(NSString *)myClientID
                                toClientId:(NSString *)friendClientId
                                     block:(void(^)(BOOL,NSMutableArray*))c;

@end

@interface GJChatViewMessageDetailModel :NSObject
@property(nonatomic,assign)BOOL isSend;//表示谁发的,yes表示自己发的,NO表示好友发的
@property(nonatomic,copy)  NSString *symbolStr;//标识符,表示本模型是那种类型的[文字,语音,图片,视频]

//1.文字
@property(nonatomic,copy)  NSString *willShowMessage;//将要被显示的文字
@property(nonatomic,assign)CGFloat messageLabelConstrains;//文字label约束
@property(nonatomic,assign)CGFloat messageCellHeight;//显示文字的cell高度

//2.图片
@property(nonatomic,assign)CGFloat imageViewConstrains;//将要显示的图片的约束
@property(nonatomic,assign)CGFloat imageViewCellHeight;//将要显示的图片cell高度
@property(nonatomic,copy)NSString *willShowImageURL;//将要被显示的图片
//3.语言
//4.视频
@end