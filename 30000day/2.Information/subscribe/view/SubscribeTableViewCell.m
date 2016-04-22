//
//  SubscribeTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/4/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubscribeTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SubscribeTableViewCell

- (void)awakeFromNib {
    
    self.secondSucribeButton.layer.borderColor = LOWBLUECOLOR.CGColor;
    
    self.secondSucribeButton.layer.borderWidth = 1.0f;
    
    self.showImageView.layer.cornerRadius = 3.0f;
    
    self.showImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//按钮点击回调
- (IBAction)buttonClickAction:(id)sender {
    
    if (self.clickActionBlock) {
        
        self.clickActionBlock(sender);
    }
}

- (void)setWriterModel:(InformationWriterModel *)writerModel {
    
    _writerModel = writerModel;
    
    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:_writerModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.secondTitleLabel.text = _writerModel.writerName;
    
    self.secondSubTitleLabel.text = [NSString stringWithFormat:@"%d人订阅",(int)_writerModel.subscribeCount];
    
    if (_writerModel.isMineSubscribe == 0) {//没有订阅
        
        [self.secondSucribeButton setTitle:@"订阅" forState:UIControlStateNormal];
        
    } else {//我的订阅
        
        [self.secondSucribeButton setTitle:@"取消订阅" forState:UIControlStateNormal];
    }
    
    if ([Common isObjectNull:_writerModel.memo]) {

        
    } else {
        
        self.secondIntroductionLabel.text = [NSString stringWithFormat:@"%@",_writerModel.memo];
    }
}

//- (NSString *)


@end
