//
//  STShowURLView.m
//  30000day
//
//  Created by GuoJia on 16/9/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STShowURLView.h"
#import "UIImageView+WebCache.h"

#define Margin_min 3
#define Heigh 60

@interface STShowURLView ()

@property (nonatomic,strong) UILabel *titleLabel;//标题label
@property (nonatomic,strong) UILabel *textLabel;//内容label
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) STShowURLModel *showURLModel;

@end

@implementation STShowURLView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    
    if (!self.titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = LOWBLUECOLOR;
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        self.titleLabel = label;
        
        //添加点击事件
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [label addGestureRecognizer:tap];
    }
    
    if (!self.textLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = LOWBLUECOLOR;
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        self.textLabel = label;
        label.backgroundColor = [UIColor blueColor];
        //添加点击事件
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [label addGestureRecognizer:tap];
    }
    
    if (!self.imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        //添加点击事件
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
    }
    self.backgroundColor =  RGBACOLOR(245, 245, 245, 1);
}

//点击行动
- (void)tapAction {
    if (self.tapBlock) {
        self.tapBlock(self.showURLModel);
    }
}

- (void)showURLViewWithShowURLModel:(STShowURLModel *)showURLModel {
    self.showURLModel = showURLModel;
    self.titleLabel.text = showURLModel.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:showURLModel.imageURLString] placeholderImage:[Common imageWithColor:RGBACOLOR(230, 230, 230, 230)]];
    [self setNeedsLayout];
}
//只有一个不为空的时候都要返回高度
+ (CGFloat)heighOfShowURLView:(STShowURLModel *)showURLModel {
    
    if ([Common isObjectNull:showURLModel.title] && [Common isObjectNull:showURLModel.imageURLString]) {
        return 0.0f;
    } else {
        if ([showURLModel.title isEqualToString:@"网页链接"]) {
            return 20.0f;
        } else {
            return Heigh;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(Margin_min, Margin_min, Heigh - 2 * Margin_min, Heigh - 2 * Margin_min);
    if ([self.showURLModel.title isEqualToString:@"网页链接"]) {
        
        if ([Common isObjectNull:self.showURLModel.imageURLString]) {//图片是空的
            self.imageView.hidden = YES;
            self.textLabel.hidden = YES;
            self.titleLabel.frame = CGRectMake(0,0,self.width,self.height);
            self.backgroundColor = [UIColor clearColor];
        } else {
            self.imageView.hidden = NO;
            self.textLabel.hidden = NO;
            self.imageView.frame = CGRectMake(Margin_min, Margin_min, Heigh - 2 * Margin_min, Heigh - 2 * Margin_min);
            self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + Margin_min, Margin_min,self.width - self.imageView.width - Margin_min - Margin_min, (Heigh - 2 * Margin_min) / 2.0f);
            self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + Margin_min, CGRectGetMaxY(self.titleLabel.frame), self.width - self.imageView.width - Margin_min - Margin_min, (Heigh - 2 * Margin_min) / 2.0f);
            self.backgroundColor = RGBACOLOR(247, 247, 247, 1);
        }
        
    } else {
        
        self.imageView.hidden = NO;
        self.textLabel.hidden = NO;
        self.imageView.frame = CGRectMake(Margin_min, Margin_min, Heigh - 2 * Margin_min, Heigh - 2 * Margin_min);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + Margin_min, Margin_min,self.width - self.imageView.width - Margin_min - Margin_min, (Heigh - 2 * Margin_min) / 2.0f);
        self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + Margin_min, CGRectGetMaxY(self.titleLabel.frame), self.width - self.imageView.width - Margin_min - Margin_min, (Heigh - 2 * Margin_min) / 2.0f);
        self.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    }
}

@end

@implementation STShowURLModel

@end
