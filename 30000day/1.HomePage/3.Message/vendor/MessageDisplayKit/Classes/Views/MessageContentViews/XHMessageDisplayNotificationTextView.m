//
//  XHMessageDisplayNotificationTextView.m
//  30000day
//
//  Created by GuoJia on 16/6/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "XHMessageDisplayNotificationTextView.h"

#define NOTIFICATION_TEXT_LABEL_MARGIN   5

@interface XHMessageDisplayNotificationTextView ()

@property (nonatomic,weak,readwrite) UILabel *displayNotificationTextLabel;

@end

@implementation XHMessageDisplayNotificationTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        if (!self.displayNotificationTextLabel) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(NOTIFICATION_TEXT_LABEL_MARGIN, 0, CGRectGetWidth(frame) - 2 * NOTIFICATION_TEXT_LABEL_MARGIN, CGRectGetHeight(frame))];
            
            label.font = [UIFont systemFontOfSize:13.0f];
            
            label.textColor = [UIColor whiteColor];
            
            label.translatesAutoresizingMaskIntoConstraints = NO;
            
            self.displayNotificationTextLabel = label;
        }
    }
    
    return self;
}

- (UILabel *)displayNotificationTextLabel {
    
    return self.displayNotificationTextLabel;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    
    self.displayNotificationTextLabel.backgroundColor = backgroundColor;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.displayNotificationTextLabel.frame = CGRectMake(NOTIFICATION_TEXT_LABEL_MARGIN, 0, CGRectGetWidth(self.frame) - 2 * NOTIFICATION_TEXT_LABEL_MARGIN, CGRectGetHeight(self.frame));
}

+ (CGFloat)textViewHeightWithDisplayText:(NSString *)text WithWidth:(CGFloat)width withFont:(UIFont *)font {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width - NOTIFICATION_TEXT_LABEL_MARGIN * 2, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height;
}

@end
