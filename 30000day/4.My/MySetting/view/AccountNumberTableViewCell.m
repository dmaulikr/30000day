//
//  AccountNumberTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/9.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AccountNumberTableViewCell.h"

@interface AccountNumberTableViewCell () <UIAlertViewDelegate>

@end

@implementation AccountNumberTableViewCell{
    BOOL _isCanPush;//是否可以前往绑定界面
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accountNumberLable.font = [UIFont systemFontOfSize:15];
    _isCanPush = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (IBAction)buttonAction:(id)sender {
    if (_isCanPush) {//可以前往绑定
        if (self.buttonBlock) {
            self.buttonBlock();
        }
    }
}

- (void)setProfile:(UserProfile *)profile {
    _profile = profile;
    if ([Common isObjectNull:[STUserAccountHandler userProfile].mobile]) {
        [self.phoneNumberButton setTitle:@"暂未绑定,前往绑定" forState:UIControlStateNormal];
        [self.phoneNumberButton setTitleColor:LOWBLUECOLOR forState:UIControlStateNormal];
        _isCanPush = YES;
    } else {
        [self.phoneNumberButton setTitle:[STUserAccountHandler userProfile].mobile forState:UIControlStateNormal];
        [self.phoneNumberButton setTitleColor:RGBACOLOR(130, 130, 130, 1) forState:UIControlStateNormal];
        _isCanPush = NO;
    }
}

@end
