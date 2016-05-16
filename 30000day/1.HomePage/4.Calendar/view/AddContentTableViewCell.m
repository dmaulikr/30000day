//
//  AddContentTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddContentTableViewCell.h"

@interface AddContentTableViewCell () 

@end

@implementation AddContentTableViewCell 

- (void)awakeFromNib {
    
    self.contentTextView.placeholder = @"请输入内容";
    
    self.contentTextView.placeholderColor = RGBACOLOR(200, 200, 200, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RemindModel *)model {
    
    _model = model;
    
    self.contentTextView.text = _model.content;
}

@end
