//
//  STInputView.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STInputView.h"

@interface STInputView ()

@property (nonatomic,strong) NSLayoutConstraint *textViewLeftConstrains;

@property (nonatomic,strong) UIButton *photo_button;

@property (nonatomic,strong) UIButton *picture_button;

@property (nonatomic,strong) UIButton *sendButton;

@end

@implementation STInputView


- (void)drawRect:(CGRect)rect {
    
}

- (id)init {
    
    if (self = [super init]) {
        
        [self configUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
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

- (void)setIsShowMedia:(BOOL)isShowMedia {
    
    _isShowMedia = isShowMedia;
    
    if (_isShowMedia) {
     
        self.textViewLeftConstrains.constant = 70.0f;
        
        self.picture_button.hidden = NO;
        
        self.photo_button.hidden = NO;
        
    } else {
        
        self.textViewLeftConstrains.constant = 10.0f;
        
        self.picture_button.hidden = YES;
        
        self.photo_button.hidden = YES;
    }
}

- (void)configUI {
    
    self.backgroundColor = RGBACOLOR(230, 230, 230, 1);
    
    if (!self.textView) {
        
        //1.设置textView
        UITextView *textView = [[UITextView alloc] init];
        
        textView.font = [UIFont systemFontOfSize:17.0f];
        
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        
        textView.layer.cornerRadius = 3;
        
        textView.layer.masksToBounds = YES;
        
        textView.layer.borderColor = RGBACOLOR(230, 230, 230, 1).CGColor;
        
        textView.layer.borderWidth = 0.5f;
        
        textView.returnKeyType = UIReturnKeyDone;
        
        [self addSubview:textView];
        
        self.textView = textView;
        
        NSArray *constraint_H_array = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[textView]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)];
        
        NSArray *constraint_V_array = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[textView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)];
        
        self.textViewLeftConstrains = [constraint_H_array firstObject];
        
        [self addConstraints:constraint_H_array];
        
        [self addConstraints:constraint_V_array];
    }
    
    if (!self.sendButton) {
        
        //2.设置发送按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"发送" forState:UIControlStateNormal];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        NSArray *constraint_H_button = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
        
        NSArray *constraint_V_button = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
        
        [self addConstraints:constraint_H_button];
        
        [self addConstraints:constraint_V_button];
        
        self.sendButton = button;
    }

    if (!self.picture_button && !self.photo_button) {
        
        //3.设置发送图片
        UIButton *picture_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [picture_button setImage:[UIImage imageNamed:@"picture"] forState:UIControlStateNormal];
        
        picture_button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [picture_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [picture_button addTarget:self action:@selector(pictureButtonAction) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:picture_button];
        
        //4.设置拍照
        UIButton *photo_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [photo_button setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
        
        photo_button.translatesAutoresizingMaskIntoConstraints = NO;
        
        [photo_button addTarget:self action:@selector(photoButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:photo_button];
        
        NSArray *constraint_H_picture_button = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[picture_button(29)]-4-[photo_button(29)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(picture_button,photo_button)];
        
        NSArray *constraint_V_picture_button = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[picture_button(20)]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(picture_button)];
        
        NSArray *constraint_V_picture_photo_button = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[photo_button(20)]-15-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(photo_button)];
        
        [self addConstraints:constraint_H_picture_button];
        
        [self addConstraints:constraint_V_picture_button];
        
        [self addConstraints:constraint_V_picture_photo_button];
        
        self.photo_button = photo_button;
        
        self.picture_button = picture_button;
    }
}

- (void)buttonAction {
    
    if (self.buttonClickBlock) {
        
        self.buttonClickBlock(STInputViewButtonSendType);
    }
}

- (void)pictureButtonAction {
    
    if (self.buttonClickBlock) {
        
        self.buttonClickBlock(STInputViewButtonPictureType);
    }
}

- (void)photoButtonAction {
    
    if (self.buttonClickBlock) {
        
        self.buttonClickBlock(STInputViewButtonPhotoType);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textView.layer.cornerRadius = 5;
    
    self.textView.layer.masksToBounds = YES;
    
    self.textView.enablesReturnKeyAutomatically = NO;
}

- (void)dealloc {
    
    self.photo_button = nil;
    
    self.picture_button = nil;
    
    self.textViewLeftConstrains = nil;
    
    self.textView = nil;
    
    self.sendButton = nil;
}


@end
