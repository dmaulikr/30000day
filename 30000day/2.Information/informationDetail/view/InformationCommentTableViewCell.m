//
//  InformationCommentTableViewCell.m
//  30000day
//
//  Created by wei on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationCommentTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation InformationCommentTableViewCell

- (void)awakeFromNib {
    
    self.checkReply.layer.masksToBounds = YES;
    self.checkReply.layer.borderWidth = 1.0;
    self.checkReply.layer.borderColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0].CGColor;
    self.checkReply.layer.cornerRadius = 10.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)replybuttonClick:(UIButton *)sender {
    
    if (self.replyBlock) {
        
        self.replyBlock(sender);
        
    }
    
}

- (IBAction)zanButtonClick:(id)sender {
    
    if (self.zanButtonBlock) {
        
        self.zanButtonBlock(sender);
        
    }
}

- (IBAction)commentButtonClick:(id)sender {
    
    if (self.commentBlock) {
        
        self.commentBlock(sender);
        
    }
    
}

- (void)setInformationCommentModel:(InformationCommentModel *)informationCommentModel {
    
    if (informationCommentModel.pId.integerValue != -1) {
        
        self.replyLable.hidden = NO;
        self.replyNameLable.hidden = NO;
        self.replyNameLable.text = informationCommentModel.parentUserName;
        
    } else {
    
        self.replyLable.hidden = YES;
        self.replyNameLable.hidden = YES;
        
    }
    
    if (!informationCommentModel.selected) {
        
        [self.checkReply setTitle:@"查看回复" forState:UIControlStateNormal];
        informationCommentModel.selected = NO;
        
    } else {
    
        [self.checkReply setTitle:@"收起回复" forState:UIControlStateNormal];
        informationCommentModel.selected = YES;
    
    }

    [self.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:informationCommentModel.headImg]];
    
    self.commentNameLable.text = [NSString stringWithFormat:@"%@",informationCommentModel.userName];
    
    NSString *str = [NSString stringWithFormat:@"%@",informationCommentModel.createTime];//时间戳
    NSTimeInterval time = [str doubleValue]/(double)1000;
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    self.commentTimeLable.text = currentDateStr;
    
    self.commentContentLable.text = informationCommentModel.remark;

    self.commentCountLable.text = [NSString stringWithFormat:@"%@",informationCommentModel.countCommentNum];

}


@end
