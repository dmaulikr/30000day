//
//  NewFriendModel.h
//  30000day
//
//  Created by GuoJia on 16/5/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewFriendModel : NSObject

@property (nonatomic,copy) NSString *status; //1--request   2--accept  3---reject
@property (nonatomic,copy) NSString *friendId;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *friendNickName;
@property (nonatomic,copy) NSString *friendHeadImg;
@property (nonatomic,copy) NSString *friendMemo;
@property (nonatomic,copy) NSString *friendUserName;

@end
