//
//  SportHeadTableViewCell.m
//  30000day
//
//  Created by WeiGe on 16/7/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SportHeadTableViewCell.h"

@implementation SportHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.beginButton.tag = 0;
    
    
    CGFloat x = (SCREEN_WIDTH - 80 * 2) / 3;
    
    [self.beginButton setFrame:CGRectMake(x, 10, 80, 80)];
    
    [self.beginButton setBackgroundColor:LOWBLUECOLOR];
    
    self.beginButton.layer.masksToBounds = YES;
    
    self.beginButton.layer.cornerRadius = 40;
    
    [self.beginButton addTarget:self action:@selector(beginSport:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.beginButton];
    
    
    self.beginLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 40, 20)];
    
    [self.beginLable setText:@"开始"];
    
    [self.beginLable setTextAlignment:NSTextAlignmentCenter];
    
    [self.beginLable setTextColor:[UIColor whiteColor]];
    
    [self.beginButton addSubview:self.beginLable];
    
    
    self.editorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.editorButton.tag = 1;
    
    [self.editorButton setFrame:CGRectMake(x * 2 + 80, 10, 80, 80)];
    
    [self.editorButton setBackgroundColor:LOWBLUECOLOR];
    
    self.editorButton.layer.masksToBounds = YES;
    
    self.editorButton.layer.cornerRadius = 40;
    
    [self.editorButton addTarget:self action:@selector(beginSport:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.editorButton];
    
    
    self.editorLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 40, 20)];
    
    [self.editorLable setTextAlignment:NSTextAlignmentCenter];
    
    [self.editorLable setText:@"编辑"];
    
    [self.editorLable setTextColor:[UIColor whiteColor]];
    
    [self.editorButton addSubview:self.editorLable];
    
}

- (void)beginSport:(UIButton *)sender {
    
    if (self.buttonBlock) {
        self.buttonBlock(sender);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
