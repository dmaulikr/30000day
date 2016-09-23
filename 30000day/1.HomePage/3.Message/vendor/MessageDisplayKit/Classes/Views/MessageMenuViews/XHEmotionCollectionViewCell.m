//
//  XHEmotionCollectionViewCell.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-5-3.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHEmotionCollectionViewCell.h"

@interface XHEmotionCollectionViewCell ()

/**
 *  显示表情封面的控件
 */
@property (nonatomic, weak) UIImageView *emotionImageView;

/**
 * 显示表情的名字
 */
@property (nonatomic, weak) UILabel *emotionLabel;


/**
 *  配置默认控件和参数
 */
- (void)setup;
@end

@implementation XHEmotionCollectionViewCell

#pragma setter method

- (void)setEmotion:(XHEmotion *)emotion {
    _emotion = emotion;
    
    // TODO:
    self.emotionImageView.image = emotion.emotionConverPhoto;
    
    self.emotionLabel.text = emotion.emotionName;
}

#pragma mark - Life cycle

- (void)setup {
    
    if (!_emotionImageView) {
        
        UIImageView *emotionImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:emotionImageView];
        
        self.emotionImageView = emotionImageView;
    }
    
    if (!_emotionLabel) {
        
        UILabel *label = [[UILabel alloc] init];
    
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:10.0f];
        
        label.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:label];
        
        _emotionLabel = label;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.emotionImageView.frame = CGRectMake(0, 0, self.emotionSize.width, self.emotionSize.height);
    
    self.emotionLabel.frame = CGRectMake(0, self.height  + 4,self.width , 10.0f);
}

- (void)dealloc {
    self.emotion = nil;
}

@end
