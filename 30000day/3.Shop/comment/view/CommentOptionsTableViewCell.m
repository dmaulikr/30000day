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
    
    self.allButton.layer.cornerRadius = 8;
    
    self.praiseButton.layer.cornerRadius = 8;
    
    self.commonlyBtton.layer.cornerRadius = 8;
    
    self.badButton.layer.cornerRadius = 8;
    
    [self.allButton setTag:1];
    [self.allButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.praiseButton setTag:2];
    [self.praiseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.commonlyBtton setTag:3];
    [self.commonlyBtton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.badButton setTag:4];
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
