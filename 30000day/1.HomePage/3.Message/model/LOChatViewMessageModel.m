//
//  GJChatViewMessageModel.m
//  GJChat
//
//  Created by guojia on 15/10/8.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import "LOChatViewMessageModel.h"
#import <AVOSCloudIM.h>

@implementation LOChatViewMessageModel

+ (void)configMessageArrayWithMessageArray:(NSMutableArray *)messageArray
                              FromClientId:(NSString *)myClientID
                                toClientId:(NSString *)friendClientId
                                     block:(void(^)(BOOL,NSMutableArray*))c {

    NSMutableArray *newMessageArray = [NSMutableArray array];
    dispatch_async(dispatch_queue_create("messageDispath", DISPATCH_QUEUE_SERIAL), ^{
        for (int i = 0; i<messageArray.count;i++) {
            AVIMTypedMessage *object = messageArray[i];
            if ([object isKindOfClass:[AVIMTextMessage class]]) {//文字
                GJChatViewMessageDetailModel *detailModel = [[GJChatViewMessageDetailModel alloc] init];
                CGRect rect = [LOChatViewMessageModel rectWithText:object.text];
                CGSize size = rect.size;
                detailModel.messageLabelConstrains = SCREEN_WIDTH - 70 - size.width - 60 - 20;
                detailModel.messageCellHeight = size.height + 45;
                detailModel.willShowMessage = object.text;
                if ([object.clientId isEqualToString:myClientID]) {
                    detailModel.isSend = YES;
                } else if ([object.clientId isEqualToString:friendClientId]) {
                    detailModel.isSend = NO;
                }
                detailModel.symbolStr = MESSAGE_STRING;
                [newMessageArray addObject:detailModel];
            } else if ([object isKindOfClass:[AVIMImageMessage class]]){//图片
                GJChatViewMessageDetailModel *detailModel = [[GJChatViewMessageDetailModel alloc] init];
                if ([object.clientId isEqualToString:myClientID]) {
                    detailModel.isSend = YES;
                } else if ([object.clientId isEqualToString:friendClientId]) {
                    detailModel.isSend = NO;
                }
                detailModel.symbolStr = MESSAGE_IMAGE;
                detailModel.willShowImageURL = object.text;//给URL赋值
                AVIMImageMessage *newOject = (AVIMImageMessage *)object;
                if (newOject.width > SCREEN_WIDTH/2) {//像素比这个大
                    detailModel.imageViewConstrains = SCREEN_WIDTH/2 - 120;
                                        
                    detailModel.imageViewCellHeight = (SCREEN_WIDTH/2)*((float)newOject.height/(float)newOject.width) - 4;
                    
                } else {//像素比这个小
                    detailModel.imageViewConstrains = SCREEN_WIDTH - newOject.width - 120;
                    detailModel.imageViewCellHeight = newOject.height - 4;
                }
                [newMessageArray addObject:detailModel];
            } else if ([object isKindOfClass:[AVIMAudioMessage class]]){//语音
                
            
            } else if ([object isKindOfClass:[AVIMVideoMessage class]]){//视频
                
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newMessageArray.count>0 && c) {
                c(YES,newMessageArray);
            }
        });
    });
}

+ (CGRect)rectWithText:(NSString *)text {
    
    return  [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 160, 2000) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
}

@end

@implementation GJChatViewMessageDetailModel

@end