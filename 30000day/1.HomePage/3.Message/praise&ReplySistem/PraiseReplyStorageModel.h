//
//  PraiseReplyStorageModel.h
//  30000day
//
//  Created by GuoJia on 16/9/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PraiseReplyStorageModel : NSObject

@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSNumber *readState;//0：阅读过 1：没阅读过 2：过渡类型
@property (nonatomic,strong) NSData   *metaData;//AVIMPraiseMessage和AVIMReplyMessage归档过来的
@property (nonatomic,strong) NSString *messageId;//消息的id
@property (nonatomic,strong) NSNumber *messageType;//98,99
@property (nonatomic,strong) NSNumber *visibleType;//0自己，1好友 2公开

@end
