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
#define Heigh 50

@interface STShowURLView ()

@property (nonatomic,strong) UILabel *titleLabel;
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
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        self.titleLabel = label;
        
        //添加点击事件
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [label addGestureRecognizer:tap];
    }
    
    if (!self.imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        //添加点击事件
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
    }
    self.backgroundColor =  RGBACOLOR(240, 240, 240, 1);
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
    if (![Common isObjectNull:showURLModel.imageURLString] || ![Common isObjectNull:showURLModel.imageURLString]) {
        return Heigh;
    } else {
        return 0.0f;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(Margin_min, Margin_min, Heigh - 2 * Margin_min, Heigh - 2 * Margin_min);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + Margin_min, Margin_min,self.width - self.imageView.width - Margin_min - Margin_min, Heigh - 2 * Margin_min);
}

@end

@implementation STShowURLModel

@end
