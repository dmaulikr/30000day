//
//  CommentView.m
//  30000day
//
//  Created by GuoJia on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CommentView.h"

@interface CommentView ()



@end

@implementation CommentView {
    
    BOOL _a;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    
    if ( self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    return self;
}

- (id)init {
    
    if (self = [super init]) {
        
        [self configUI];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    if (!_showImageView) {
        
        _showImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_edit"]];
        
        [self addSubview:_showImageView];
    }
    
    if (!_showLabel) {
        
        _showLabel = [[UILabel alloc] init];
        
        _showLabel.textAlignment = NSTextAlignmentCenter;
        
        _showLabel.textColor = [UIColor darkGrayColor];
        
        _showLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [self addSubview:_showLabel];
        
        _showLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *H_constrains = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_showLabel]-7-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_showLabel)];
        
        NSLayoutConstraint *cententX = [NSLayoutConstraint constraintWithItem:_showLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
        
        [self addConstraint:cententX];
        
        [self addConstraints:H_constrains];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:tap];
    
    _a = NO;
}

- (BOOL)isSelected {
    
    return _a;
}

- (void)setSelected:(BOOL)selected {
    
    _a = selected;
}


- (void)tapAction {
    
    if (self.clickBlock) {
        
        self.clickBlock();
        
//        if (_a) {
//            
//            _a = NO;
//            
//        } else {
//            
//            _a = YES;
//        }
    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _showImageView.x = 7;
    
    _showImageView.centerY = self.height/2.0f;
    
    _showImageView.width = 17;
    
    _showImageView.height = 17;
}

- (CGFloat)getLabelWidthWithText:(NSString *)text textHeight:(CGFloat)textHeight {
    
    CGFloat width = [Common widthWithText:text height:textHeight fontSize:14.0f];
    
    return width + 17 + 20;
}

@end
