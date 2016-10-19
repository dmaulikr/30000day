//
//  IntroduceView.m
//  30000day
//
//  Created by WeiGe on 16/6/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "IntroduceView.h"

@implementation IntroduceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self loadView];
        
    }
    
    return self;
}

- (void)loadView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
    CGFloat one = 64 + 80 + ((SCREEN_HEIGHT - 188) / 2.0f) / 2.0f - 20;
    
    CGFloat two = 64 + 80 + (SCREEN_HEIGHT - 188) / 2.0f + ((SCREEN_HEIGHT - 188) / 2.0f) / 2.0f;
    
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 25, one, 50, 50)];
    
    [imageView setImage:[UIImage imageNamed:@"clickImg.png"]];
    
    [self addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 75, one + 50, 150, 20)];
    
    [lable setText:@"选择不同的显示方式"];
    
    [lable setTextColor:[UIColor whiteColor]];
    
    [lable setFont:[UIFont systemFontOfSize:16.0]];
    
    [self addSubview:lable];
    
    
    CGFloat center = (two - (one + 50)) / 2;
    
    UILabel *voiceLable = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150, one + center + 50, 300, 20)];
    
    [voiceLable setTextAlignment:NSTextAlignmentCenter];
    
    [voiceLable setText:@"您可以在 我的->设置 关闭主页语音播报"];
    
    [voiceLable setTextColor:[UIColor whiteColor]];
    
    [voiceLable setFont:[UIFont systemFontOfSize:15.0]];

    [self addSubview:voiceLable];

    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 25, two, 50, 50)];
    
    [imageView1 setImage:[UIImage imageNamed:@"clickImg.png"]];
    
    [self addSubview:imageView1];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 35, two + 50, 70, 20)];
    
    [lable1 setText:@"点击试试"];
    
    [lable1 setTextColor:[UIColor whiteColor]];
    
    [lable1 setFont:[UIFont systemFontOfSize:16.0]];
    
    [self addSubview:lable1];

    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [self removeFromSuperview];
    
}

@end
