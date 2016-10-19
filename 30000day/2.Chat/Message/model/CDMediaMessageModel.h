//
//  CDMediaMessageModel.h
//  30000day
//
//  Created by GuoJia on 16/7/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDMediaMessageModel : NSObject

@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSString *imageMessageId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSData   *image;
@property (nonatomic, strong) NSString *localURLString;
@property (nonatomic, strong) NSString *remoteURLString;
@property (nonatomic, strong) NSDate   *messageDate;

@end
