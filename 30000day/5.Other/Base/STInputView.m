//
//  STInputView.m
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STInputView.h"

@interface STInputView ()



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

- (void)configUI {
    
    self.backgroundColor = RGBACOLOR(242, 242, 242, 1);
    
    //1.设置textView
    UITextView *textView = [[UITextView alloc] init];
    
    textView.font = [UIFont systemFontOfSize:17.0f];
    
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    textView.layer.cornerRadius = 3;
    
    textView.layer.masksToBounds = YES;
    
    textView.layer.borderColor = RGBACOLOR(230, 230, 230, 1).CGColor;
    
    textView.layer.borderWidth = 0.5f;
    
    [self addSubview:textView];
    
    self.textView = textView;
    
    NSArray *constraint_H_array = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[textView]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)];
    
    NSArray *constraint_V_array = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[textView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)];
    
    [self addConstraints:constraint_H_array];
    
    [self addConstraints:constraint_V_array];
    
    //2.设置发送按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"发送" forState:UIControlStateNormal];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:button];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [self addSubview:button];
    
    NSArray *constraint_H_button = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    
    NSArray *constraint_V_button = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button(40)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    
    [self addConstraints:constraint_H_button];
    
    [self addConstraints:constraint_V_button];
     
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textView.layer.cornerRadius = 5;
    
    self.textView.layer.masksToBounds = YES;
    
    self.textView.enablesReturnKeyAutomatically = NO;
}

@end
