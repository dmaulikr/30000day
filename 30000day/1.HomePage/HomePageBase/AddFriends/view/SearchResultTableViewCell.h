//
//  SearchResultTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendListInfo.h"

@interface SearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic,strong) FriendListInfo *friendsInfo;

@end
