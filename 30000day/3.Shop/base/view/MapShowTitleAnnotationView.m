//
//  MapShowTitleAnnotationView.m
//  30000day
//
//  Created by GuoJia on 16/4/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "MapShowTitleAnnotationView.h"
#import "UIImage+WF.h"

@interface MapShowTitleAnnotationView ()

@property (nonatomic, copy) UILabel *label;

@property (nonatomic ,retain) UIImageView *backgroundImageView;//背景图片

@end

@implementation MapShowTitleAnnotationView

@synthesize label = _label;
@synthesize backgroundImageView = _backgroundImageView;

 - (void)setTitle:(NSString *)title {
     _title = title;
     _label.text = title;
}

- (void)setSize:(CGSize)size {
    
    _size = size;
    
    [self layoutIfNeeded];
}

- (id)initWithAnnotation:(id <BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        _backgroundImageView = [[UIImageView alloc] init];
        
        _backgroundImageView.image = [[UIImage imageNamed:@"Rectangle 23"] imageWithTintColor:RGBACOLOR(83, 128, 196, 1)];
        
        [self addSubview:_backgroundImageView];
        
        _label = [[UILabel alloc] init];
        
        _label.textColor = [UIColor whiteColor];
        
        _label.font = [UIFont systemFontOfSize:14];
        
        _label.textAlignment = NSTextAlignmentCenter;
        
        [_backgroundImageView addSubview:_label];
        
        [self bringSubviewToFront:_backgroundImageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _backgroundImageView.frame = CGRectMake(0.f, 0.f,_size.width + 10,25);
    
    _label.frame = CGRectMake(5.f, -3.f,_size.width, 25);
    
    [self setBounds:CGRectMake(0.f, 0.f, _size.width + 10, 30)];
}

+ (CGSize)titleSize:(NSString *)title {
    
    CGRect frame = [title boundingRectWithSize:CGSizeMake(2000, 25) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    return frame.size;
}

@end
