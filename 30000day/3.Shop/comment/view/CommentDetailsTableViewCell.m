//
//  CommentDetailsTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentDetailsTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation CommentDetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)checkReply:(id)sender {
    
    if (self.changeStateBlock) {
        self.changeStateBlock((UIButton *)sender);
    }

    
}

- (void)setCommentModel:(CommentModel *)commentModel {
    
    _commentModel = commentModel;
    
    self.commentContentLable.text = commentModel.remark;
    
    if (commentModel.userName != nil) {
        
        self.commentNameLable.text = commentModel.userName;
        
    } else {
        
        self.commentNameLable.text = @"错误数据";
    }
    
    self.replyNameLable.text = commentModel.pName;
    
    [self.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.headImg] placeholderImage:[UIImage imageNamed:@"sd-4"]];
    
    if (commentModel.picUrl != nil && ![commentModel.picUrl isEqualToString:@"test.img"] && ![commentModel.picUrl isEqualToString:@"/img.img"]) {
        
        [self.commentContentImageViewOne sd_setImageWithURL:[NSURL URLWithString:commentModel.picUrl]];
        [self.commentContentImageViewTwo sd_setImageWithURL:[NSURL URLWithString:commentModel.picUrl]];
        [self.commentContentImageViewThree sd_setImageWithURL:[NSURL URLWithString:commentModel.picUrl]];
        
    } else {
    
        self.commentContentImageViewOne.hidden = YES;
        self.commentContentImageViewTwo.hidden = YES;
        self.commentContentImageViewThree.hidden = YES;
        
    }
    
}

@end
