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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    self.commentNameLable.text = commentModel.userName;
    
    self.commentTimeLable.text = [NSString stringWithFormat:@"%@",commentModel.createTime];
    
    [self.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.headImg]];
    
}

@end
