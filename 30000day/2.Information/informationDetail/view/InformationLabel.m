//
//  InformationLabel.m
//  30000day
//
//  Created by GuoJia on 16/4/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationLabel.h"

@interface InformationLabel ()

@property (nonatomic,strong) UIImageView *showImageView;

@end

@implementation InformationLabel

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
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _showImageView.x = 5;
    
    _showImageView.centerY = self.height/2.0f;
    
    _showImageView.width = 17;
    
    _showImageView.height = 17;
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self layoutIfNeeded];
}

+ (CGFloat)getLabelWidthWithText:(NSString *)text {
    
    CGFloat width = [Common widthWithText:text height:34.0f fontSize:14.0f];
    
    return width + 17 + 10;
}

@end
