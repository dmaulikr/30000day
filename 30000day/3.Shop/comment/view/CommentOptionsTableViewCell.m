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
    [super awakeFromNib];
    
    CGFloat with = (self.bounds.size.width - 65 * 4 - 29) / 3;
    self.praiseButtonLeft.constant = with;
    self.praiseButtonRight.constant = with;
    self.commonlyBttonLeft.constant = with;
    self.commonlyBttonRight.constant = with;
    self.badButtonLeft.constant = with;
    self.allButtonRight.constant = with;
    self.allButton.layer.cornerRadius = 8;
    self.praiseButton.layer.cornerRadius = 8;
    self.commonlyBtton.layer.cornerRadius = 8;
    self.badButton.layer.cornerRadius = 8;
    [self.allButton setTag:-1];
    //[self.allButton setImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    //[self.allButton setImage:[UIImage imageNamed:@"type1"] forState:UIControlStateHighlighted];
    [self.allButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.praiseButton setTag:1];
    //[self.praiseButton setImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    //[self.praiseButton setImage:[UIImage imageNamed:@"type1"] forState:UIControlStateHighlighted];
    [self.praiseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.commonlyBtton setTag:2];
    //[self.commonlyBtton setImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    //[self.commonlyBtton setImage:[UIImage imageNamed:@"type1"] forState:UIControlStateHighlighted];
    [self.commonlyBtton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.badButton setTag:3];
    //[self.badButton setImage:[UIImage imageNamed:@"type"] forState:UIControlStateNormal];
    //[self.badButton setImage:[UIImage imageNamed:@"type1"] forState:UIControlStateHighlighted];
    [self.badButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)buttonClick:(id)sender {
    
    if (self.changeStateBlock) {
        
        self.changeStateBlock((UIButton *)sender);
        
    }
}


@end
