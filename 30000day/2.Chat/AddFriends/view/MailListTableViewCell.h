//
//  MailListTableViewCell.h
//  30000day
//
//  Created by wei on 16/2/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChineseString.h"

@interface MailListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *invitationButton;

@property (nonatomic , copy) void (^(invitationButtonBlock))(UIButton *button);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) ChineseString *dataModel;


@end
