//
//  pay.h
//  17dong_ios
//
//  Created by win5 on 14-12-11.
//  Copyright (c) 2014年 win5. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol payResultStatusDelegate <NSObject>

-(void)resultStatus:(NSString *)status;

@end

@interface pay : NSObject

@property (nonatomic, weak) id <payResultStatusDelegate> delegate;

- (void)payWithOrderID:(NSString *)orderID goodTtitle:(NSString *)goodTitle goodPrice:(NSString *)price;

- (void)payByWechatWithOrderID:(NSString *)orderID goodTtitle:(NSString *)goodTitle goodPrice:(NSString *)price;

@end
