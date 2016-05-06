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
    
    self.checkReply.layer.masksToBounds = YES;
    self.checkReply.layer.borderWidth = 1.0;
    self.checkReply.layer.borderColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0].CGColor;
    self.checkReply.layer.cornerRadius = 10.0;
    
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
    [self.commentZambiaButton addTarget:self action:@selector(commentZambiaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkReply addTarget:self action:@selector(checkReply:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)commentZambiaButtonClick:(id)sender {
    
    if (self.zanButtonBlock) {
        self.zanButtonBlock((UIButton *)sender);
    }
    
}


- (void)checkReply:(UIButton *)sender {
    
    if (self.replyBlock) {
        self.replyBlock((UIButton *)sender);
    }
    
}

- (void)setInformationCommentModel:(InformationCommentModel *)informationCommentModel {
    
    _informationCommentModel = informationCommentModel;
    
    if (informationCommentModel.commentPid.integerValue == informationCommentModel.pId.integerValue) {
        
        [self setBackgroundColor:VIEWBORDERLINECOLOR];
        
    } else {
    
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    
    if (self.isHideBelowView) {
        
        self.checkReply.hidden = YES;
        self.commentZambiaButton.hidden = YES;
        self.commentButton.hidden = YES;
        self.commentCountLable.hidden = YES;
        self.zanLable.hidden = YES;
        
    } else {
    
        if (informationCommentModel.pId.integerValue != -1) {
            
            self.replyLable.hidden = NO;
            self.replyNameLable.hidden = NO;
            self.replyNameLable.text = informationCommentModel.parentNickName;
            
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
    
        if (informationCommentModel.isClickLike.integerValue) {
            
            [self.commentZambiaButton setImage:[UIImage imageNamed:@"icon_zan_blue"] forState:UIControlStateNormal];
            self.commentZambiaButton.selected = YES;
            
        } else {
            
            [self.commentZambiaButton setImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
            self.commentZambiaButton.selected = NO;
            
        }
        
        self.commentCountLable.text = [NSString stringWithFormat:@"%ld",informationCommentModel.clickLikeCount];
    }

    
    
    self.commentContentLable.text = informationCommentModel.remark;
    
    
    if ([Common isObjectNull:_informationCommentModel.nickName]) {
        
       self.commentNameLable.text = _informationCommentModel.userName;
        
    } else {
        
        self.commentNameLable.text = _informationCommentModel.nickName;
    }
    
    [self.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:informationCommentModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    NSString *str = [NSString stringWithFormat:@"%@",informationCommentModel.createTime];//时间戳
    
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]/(double)1000];
    
    NSString *currentDateStr = [[Common dateFormatterWithFormatterString:@"yyyy-MM-dd HH:mm"] stringFromDate: detaildate];
    
    self.commentTimeLable.text = currentDateStr;
    
    if (informationCommentModel.commentPhotos != nil && ![informationCommentModel.commentPhotos isEqualToString:@""]) {
        
        NSString *str = [informationCommentModel.commentPhotos stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSArray *photoUrl = [str componentsSeparatedByString:@";"];
        
        for (int i = 0; i < photoUrl.count; i++) {

            if (i == 0) {
                [self.commentContentImageViewOne sd_setImageWithURL:[NSURL URLWithString:photoUrl[i]]];
            }
            
            if (i == 1) {
                [self.commentContentImageViewTwo sd_setImageWithURL:[NSURL URLWithString:photoUrl[i]]];
            }
            
            if (i == 2) {
                [self.commentContentImageViewThree sd_setImageWithURL:[NSURL URLWithString:photoUrl[i]]];
            }
            
        }
        
    } else {
        
        self.commentContentImageViewOne.hidden = YES;
        self.commentContentImageViewTwo.hidden = YES;
        self.commentContentImageViewThree.hidden = YES;
        
    }
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

//tableview 重用时自动调用该方法
- (void)prepareForReuse {
    [super prepareForReuse];

    [self.commentContentImageViewOne sd_setImageWithURL:nil];
    [self.commentContentImageViewTwo sd_setImageWithURL:nil];
    [self.commentContentImageViewThree sd_setImageWithURL:nil];
    
    self.commentContentImageViewOne.hidden = NO;
    self.commentContentImageViewTwo.hidden = NO;
    self.commentContentImageViewThree.hidden = NO;

}

@end
