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
    [super awakeFromNib];
    
    self.invitationButton.layer.cornerRadius = 6;
    self.invitationButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)invitationButtonAction:(id)sender {
    
    if (self.invitationButtonBlock) {
        
        self.invitationButtonBlock((UIButton *)sender);
    }
}

- (void)setDataModel:(ChineseString *)dataModel {
    
    _dataModel = dataModel;
    
    self.titleLabel.text = dataModel.string;
    
    if (dataModel.status == 1) {
        
        [self.invitationButton setTitle:@"＋" forState:UIControlStateNormal];
        
        [self.invitationButton setBackgroundColor:[UIColor colorWithRed:73.0/255.0 green:117.0/255.0 blue:188.0/255.0 alpha:1.0]];
        
        [self.invitationButton setTag:1];
        
    } else if(dataModel.status == 2) {
        
        [self.invitationButton setTitle:@"已加" forState:UIControlStateNormal];
        
        [self.invitationButton setUserInteractionEnabled:NO];
        
        [self.invitationButton setTitleColor:[UIColor colorWithRed:73.0/255.0 green:117.0/255.0 blue:188.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        
        [self.invitationButton setBackgroundColor:[UIColor whiteColor]];
        
        [self.invitationButton setTag:2];
        
    } else {
        
        [self.invitationButton setTitle:@"邀请" forState:UIControlStateNormal];
        
        [self.invitationButton setBackgroundColor:[UIColor colorWithRed:73.0/255.0 green:117.0/255.0 blue:188.0/255.0 alpha:1.0]];
        
        [self.invitationButton setTag:0];
    }
}

@end
