//
//  XHMessageDisplayNotificationTextView.m
//  30000day
//
//  Created by GuoJia on 16/6/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "XHMessageDisplayNotificationTextView.h"

#define NOTIFICATION_TEXT_LABEL_MARGIN   5

#define NOTIFICATION_TEXT_LABEL_TOP_MARGIN 3

@interface XHMessageDisplayNotificationTextView ()

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
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(NOTIFICATION_TEXT_LABEL_MARGIN,NOTIFICATION_TEXT_LABEL_TOP_MARGIN, CGRectGetWidth(frame) - 2 * NOTIFICATION_TEXT_LABEL_MARGIN, CGRectGetHeight(frame) - 2 * NOTIFICATION_TEXT_LABEL_TOP_MARGIN)];//这里加3是因为有缝隙
            
            label.font = [UIFont systemFontOfSize:13.0f];
            
            label.textColor = [UIColor whiteColor];
            
            [self addSubview:label];
            
            self.displayNotificationTextLabel = label;
        }
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:backgroundColor];
    
    self.displayNotificationTextLabel.backgroundColor = backgroundColor;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.displayNotificationTextLabel.frame = CGRectMake(NOTIFICATION_TEXT_LABEL_MARGIN,NOTIFICATION_TEXT_LABEL_TOP_MARGIN, CGRectGetWidth(self.frame) - 2 * NOTIFICATION_TEXT_LABEL_MARGIN, CGRectGetHeight(self.frame) - 2 * NOTIFICATION_TEXT_LABEL_TOP_MARGIN);
}

+ (CGFloat)textViewHeightWithDisplayText:(NSString *)text withWidth:(CGFloat)width withFont:(UIFont *)font {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width - NOTIFICATION_TEXT_LABEL_MARGIN * 2, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.height + 2 * NOTIFICATION_TEXT_LABEL_TOP_MARGIN;
}

+ (CGFloat)textViewWidthWithDisplayText:(NSString *)text withHeight:(CGFloat)height withFont:(UIFont *)font {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(1000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect.size.width + 2 * NOTIFICATION_TEXT_LABEL_MARGIN;
}

@end
