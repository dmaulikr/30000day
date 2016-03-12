//
//  CommentOptionsTableViewCell.m
//  30000day
//
//  Created by wei on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentOptionsTableViewCell.h"

@interface CommentOptionsTableViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseButtonLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseButtonRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commonlyBttonLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commonlyBttonRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badButtonLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allButtonRight;

@end

@implementation CommentOptionsTableViewCell

- (void)awakeFromNib {
    
    CGFloat with = (self.bounds.size.width - 65 * 4 - 29) / 3;
    
    self.praiseButtonLeft.constant = with;
    
    self.praiseButtonRight.constant = with;
    
    self.commonlyBttonLeft.constant = with;
    
    self.commonlyBttonRight.constant = with;
    
    self.badButtonLeft.constant = with;
    
    self.allButtonRight.constant = with;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
