//
//  STShowRedPacketView.m
//  30000day
//
//  Created by GuoJia on 16/9/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowRedPacketView.h"

@interface STShowRedPacketView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *pickRedPacketButton;

@end

@implementation STShowRedPacketView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureUI];
}

- (void)configureUI {
    self.headImageView.layer.cornerRadius = 35;
    self.headImageView.layer.masksToBounds = YES;
    self.pickRedPacketButton.layer.cornerRadius = 40;
    self.pickRedPacketButton.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
