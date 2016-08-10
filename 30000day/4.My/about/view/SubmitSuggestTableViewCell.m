//
//  SubmitSuggestTableViewCell.m
//  30000day
//
//  Created by wei on 16/8/8.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "SubmitSuggestTableViewCell.h"

@implementation SubmitSuggestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.submitButton.layer.cornerRadius = 6;
    self.submitButton.layer.masksToBounds = YES;
    
    [self.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    
    [lable setText:@"请简要描述你的问题和意见"];
    
    [lable setFont:[UIFont systemFontOfSize:14.0]];
    
    [lable setTextColor:[UIColor colorWithRed:189.0/255.0 green:189.0/255.0 blue:189.0/255.0 alpha:1.0]];
    
    [self.textView addSubview:lable];
    
    [self.textView setDelegate:self];
    
    self.lable = lable;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {

    self.lable.hidden = YES;

}

- (void)submitClick {

    if (self.subMitBlock) {
        
        self.subMitBlock();
        
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
