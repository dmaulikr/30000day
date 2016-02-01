//
//  PersonViewController.h
//  30000day
//
//  Created by GuoJia on 16/1/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "myFriendsTableViewCell.h"
#import "FriendListInfo.h"

@interface PersonViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *friendsNumLabel;//当期有多少个好友Label

@property (weak, nonatomic) IBOutlet UIButton *switchModeButton;//切换UITableView显示的模式

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UserInfo *userinfo;

@property (nonatomic,strong) FriendListInfo *friendInfo;

@property (nonatomic,strong) NSArray *friendsArray;

@property (nonatomic,assign) NSInteger state;

@end
