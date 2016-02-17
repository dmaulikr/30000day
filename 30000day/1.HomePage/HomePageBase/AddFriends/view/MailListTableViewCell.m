//
//  MailListTableViewCell.m
//  30000day
//
//  Created by wei on 16/2/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MailListTableViewCell.h"

@implementation MailListTableViewCell

- (void)awakeFromNib {
    
    self.invitationButton.layer.cornerRadius = 6;
    
    self.invitationButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)invitationButtonAction:(id)sender {
    
    if (self.invitationButtonBlock) {
        
        self.invitationButtonBlock();
    }
}

@end
