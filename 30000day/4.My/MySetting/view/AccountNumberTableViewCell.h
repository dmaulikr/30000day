//
//  AccountNumberTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountNumberTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *accountNumberLable;
@property (weak, nonatomic) IBOutlet UIButton *phoneNumberButton;
//按钮点击回调
@property (nonatomic,copy) void (^buttonBlock)();
@property (nonatomic,strong) UserProfile *profile;

@end
