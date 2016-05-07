//
//  STConversationCell.h
//  30000day
//
//  Created by GuoJia on 16/5/6.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSBadgeView/JSBadgeView.h>

@interface STConversationCell : UITableViewCell

+ (CGFloat)heightOfCell;

+ (STConversationCell *)dequeueOrCreateCellByTableView :(UITableView *)tableView;

+ (void)registerCellToTableView: (UITableView *)tableView ;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel  *messageTextLabel;

@property (nonatomic, strong) JSBadgeView *badgeView;

@property (nonatomic, strong) UILabel *timestampLabel;

//新增加的长按手势
@property (nonatomic,copy) void (^longPressBlock)();

@end
