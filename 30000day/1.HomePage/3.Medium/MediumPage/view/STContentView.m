//
//  STContentView.m
//  30000day
//
//  Created by GuoJia on 16/8/5.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STContentView.h"
#define SingleContentHeight    16.7070313f	    //一行高度

@interface STContentView ()
@property (nonatomic,strong) UILabel *contentLabel;//内容label
@property (nonatomic,copy)   NSAttributedString *mediaContent;

@end

@implementation STContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!self.contentLabel) {
        //内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
}

//开始展示内容
- (void)showContent:(NSAttributedString *)mediaContentAttributedString {
    self.mediaContent = mediaContentAttributedString;
    self.contentLabel.attributedText = mediaContentAttributedString;
    [self setNeedsLayout];
}

+ (CGFloat)heightContentViewWith:(NSAttributedString *)mediaContent contenteViewWidth:(CGFloat)width {
    
    if ([Common heightWithText:mediaContent.string width:width fontSize:14.0f] > 5 * SingleContentHeight) {
        return 5 * SingleContentHeight;
    } else {
        return [Common heightWithText:mediaContent.string width:width fontSize:14.0f];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentLabel.frame = CGRectMake(0, 0, self.width, self.height);
}

@end
