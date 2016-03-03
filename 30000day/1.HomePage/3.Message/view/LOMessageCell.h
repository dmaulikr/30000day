//
//  QGMessageCell.h
//  GJChat
//
//  Created by guojia on 15/9/1.
//  Copyright (c) 2015年 guojia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LOChatViewMessageModel.h"

@interface LOMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myHeaderView;//我的头像
@property (weak, nonatomic) IBOutlet UIImageView *friendsHeaderView;//好友的头像
@property(nonatomic,retain)GJChatViewMessageDetailModel *messageDetailModel;
@property(nonatomic,copy)void (^clickBlock)(UIImageView*);

@end
