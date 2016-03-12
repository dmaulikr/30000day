//
//  MTGooderOrderInvoiceCommentsCell.m
//  17dong_ios
//
//  Created by win5 on 7/10/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import "MTGooderOrderInvoiceCommentsCell.h"

@implementation MTGooderOrderInvoiceCommentsCell

- (void)awakeFromNib {
    // Initialization code
    self.commentsTextView.layer.cornerRadius = 5;
    self.commentsTextView.layer.masksToBounds = YES;
    self.commentsTextView.layer.borderColor = [UIColor colorWithRed:179.0f/255.0f green:179.0f/255.0f blue:179.0f/255.0f alpha:1.0f].CGColor;
    self.commentsTextView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
