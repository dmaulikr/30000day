//
//  ShopDetailCommentTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShopDetailCommentTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ShopDetailCommentTableViewCell

- (void)awakeFromNib {
    
    self.commentContentImageViewOne.userInteractionEnabled = YES;
    self.commentContentImageViewTwo.userInteractionEnabled = YES;
    self.commentContentImageViewThree.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookImage:)];
    [self.commentContentImageViewOne addGestureRecognizer:portraitTap];
    
    UITapGestureRecognizer *portraitTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookImage:)];
    [self.commentContentImageViewTwo addGestureRecognizer:portraitTapTwo];
    
    UITapGestureRecognizer *portraitTapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lookImage:)];
    [self.commentContentImageViewThree addGestureRecognizer:portraitTapThree];
    
    [self.commentButton addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)commentClick:(UIButton *)sender {

    if (self.commentBlock) {
        self.commentBlock((UIButton *)sender);
    }

}

- (IBAction)commentZambiaButtonClick:(id)sender {
    
    if (self.commentZambiaButtonBlock) {
        self.commentZambiaButtonBlock((UIButton *)sender);
    }
    
}


- (IBAction)checkReply:(UIButton *)sender {
    
    if (self.changeStateBlock) {
        self.changeStateBlock((UIButton *)sender);
    }
    
}

- (void)setCommentModel:(CommentModel *)commentModel {

    _commentModel = commentModel;
    
    if (commentModel.clickLike.intValue) {
        
        self.commentContentLable.text = @"已赞";
        
    } else {
    
        self.commentContentLable.text = @"赞";
    
    }
    
    self.commentContentLable.text = commentModel.remark;
    
    self.commentNameLable.text = [commentModel.userName isEqualToString:@""] ? commentModel.userName:@"错误数据";
    
    NSString *str = [NSString stringWithFormat:@"%@",commentModel.createTime];//时间戳
    NSTimeInterval time = [str doubleValue]/(double)1000;
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    self.commentTimeLable.text = currentDateStr;
    
    [self.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.headImg]];
    
}

- (void)lookImage:(UITapGestureRecognizer *)tap {
    
    if (![(UIImageView *)tap.view image]) {
        return;
    }
    
    UIImageView *picView = (UIImageView *)tap.view;
    
    if (self.lookPhoto) {
        self.lookPhoto(picView);
    }
}

@end
