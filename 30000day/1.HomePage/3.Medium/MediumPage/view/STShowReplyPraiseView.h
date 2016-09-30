//
//  STShowReplyPraiseView.h
//  30000day
//
//  Created by GuoJia on 16/9/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVIMReplyMessage.h"
#import "AVIMPraiseMessage.h"

@interface STShowReplyPraiseView : UIView

@property (nonatomic,copy) void (^replyBlock)(NSArray <AVIMReplyMessage *>*replyArray);
@property (nonatomic,copy) void (^praiseBlock)(NSArray <AVIMPraiseMessage *>*replyArray);

+ (STShowReplyPraiseView *)showReplyPraiseView;
- (void)configureViewWithReplyArray:(NSArray <AVIMReplyMessage *>*)replyArray praiseArray:(NSArray <AVIMPraiseMessage *>*)praiseArray;
+ (CGFloat)heightReplyPraiseViewWithReplyArray:(NSArray <AVIMReplyMessage *>*)replyArray praiseArray:(NSArray <AVIMPraiseMessage *>*)praiseArray;

@end
