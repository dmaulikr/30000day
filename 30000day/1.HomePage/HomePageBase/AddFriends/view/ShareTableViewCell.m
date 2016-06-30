//
//  ShareTableViewCell.m
//  30000day
//
//  Created by WeiGe on 16/6/30.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShareTableViewCell.h"

@implementation ShareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.WeChatFriendsBtn.layer.borderWidth=1.0;
    self.WeChatFriendsBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.WeChatFriendsBtn.layer.cornerRadius = 6;
    self.WeChatFriendsBtn.layer.masksToBounds = YES;
    
    self.WeChatBtn.layer.borderWidth=1.0;
    self.WeChatBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.WeChatBtn.layer.cornerRadius = 6.0;
    self.WeChatBtn.layer.masksToBounds = YES;
    
    self.QQspaceBtn.layer.borderWidth=1.0;
    self.QQspaceBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.QQspaceBtn.layer.cornerRadius = 6.0;
    self.QQspaceBtn.layer.masksToBounds = YES;
    
    self.qqBtn.layer.borderWidth=1.0;
    self.qqBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.qqBtn.layer.cornerRadius = 6.0;
    self.qqBtn.layer.masksToBounds = YES;
    
    self.SinaBtn.layer.borderWidth=1.0;
    self.SinaBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.SinaBtn.layer.cornerRadius = 6.0;
    self.SinaBtn.layer.masksToBounds = YES;
    
    self.emailBtn.layer.borderWidth=1.0;
    self.emailBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.emailBtn.layer.cornerRadius = 6.0;
    self.emailBtn.layer.masksToBounds = YES;
    
    self.shortMessageBtn.layer.borderWidth=1.0;
    self.shortMessageBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.shortMessageBtn.layer.cornerRadius = 6.0;
    self.shortMessageBtn.layer.masksToBounds = YES;
    
    self.LinkBtn.layer.borderWidth=1.0;
    self.LinkBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.LinkBtn.layer.cornerRadius = 6.0;
    self.LinkBtn.layer.masksToBounds = YES;
    
}

- (IBAction)clickButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (self.buttonBlock) {
        
        self.buttonBlock(button.tag);
        
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
