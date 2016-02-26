//
//  AddContentTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/2/26.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AddContentTableViewCell.h"

@interface AddContentTableViewCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AddContentTableViewCell 

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRemindModel:(RemindModel *)remindModel {
    
    if ([Common isObjectNull:remindModel.content]) {
    
        self.contentLabel.text = @"请输入内容";
        
    } else {
        
        self.contentLabel.text = @"";
    
    }
    
    self.contentTextView.text = remindModel.content;
}

#pragma ---
#pragma mark --- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([Common isObjectNull:textView.text]) {
        
        if ([Common isObjectNull:text]) {
            
            self.contentLabel.text = @"请输入内容";
            
        } else {
            
            self.contentLabel.text = @"";
            
        }
        
    } else {
        
        if ([Common isObjectNull:text]) {
            
            if (self.contentTextView.text.length > 1) {
                
                self.contentLabel.text = @"";
                
            } else {
                
                self.contentLabel.text = @"请输入内容";
                
            }
            
        } else {
            
            if ([Common isObjectNull:self.contentTextView.text]) {
                
                 self.contentLabel.text = @"请输入内容";
                
            } else {
                
                self. self.contentLabel.text = @"";
            }

        }
        
    }
    
    return YES;
}

@end
