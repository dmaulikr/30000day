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

    // Configure the view for the selected state
}

- (IBAction)checkReply:(id)sender {
    
    if (self.changeStateBlock) {
        self.changeStateBlock((UIButton *)sender);
    }

    
}

- (void)setCommentModel:(CommentModel *)commentModel {
    
    _commentModel = commentModel;
    
    self.commentContentLable.text = commentModel.remark;
    
    self.commentNameLable.text = commentModel.userName;
    
    [self.commentHeadPortraitImageView sd_setImageWithURL:[NSURL URLWithString:commentModel.headImg]];
    
}

@end
