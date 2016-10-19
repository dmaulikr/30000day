//
//  ShareTableViewCell.h
//  30000day
//
//  Created by WeiGe on 16/6/30.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *WeChatFriendsBtn;

@property (weak, nonatomic) IBOutlet UIButton *WeChatBtn;

@property (weak, nonatomic) IBOutlet UIButton *QQspaceBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (weak, nonatomic) IBOutlet UIButton *SinaBtn;

@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

@property (weak, nonatomic) IBOutlet UIButton *shortMessageBtn;

@property (weak, nonatomic) IBOutlet UIButton *LinkBtn;

@property (nonatomic,copy) void (^(buttonBlock))(NSInteger);

@end
