//
//  CityHeadView.m
//  30000day
//
//  Created by GuoJia on 16/3/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CityHeadView.h"

#define CityHeadViewLabelH 40

#define CityHeadViewLabelMargin 10

#define CityHeadViewLabelW  ([[UIScreen mainScreen] bounds].size.width - 4 * CityHeadViewLabelMargin)/3


@implementation CityHeadView

- (void)setCityArray:(NSMutableArray *)cityArray {
    
    _cityArray = cityArray;
    
    NSUInteger butonCount = _cityArray.count;
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        
        if (i == 0) {
            
            label.text = @"热门城市";
            
        } else {

            label.text = @"国内城市";
        }
        
        label.font = [UIFont systemFontOfSize:15];
        
        label.textColor = [UIColor darkGrayColor];
        
        [self.contentView addSubview:label];
    }
    
    while (self.contentView.subviews.count - 2  < butonCount) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        button.layer.borderWidth = 1.0f;
        
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        button.backgroundColor = [UIColor whiteColor];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:button];
    }
    
    //遍历图片空间，设置按钮
    for (int i = 0; i < _cityArray.count; i++) {
        
        UIButton *button = self.contentView.subviews[i+2];
        
        if (i < butonCount) {
            
            [button setTitle:_cityArray[i] forState:UIControlStateNormal];
            
            button.tag = i;
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button.hidden = NO;//注意这句代码的含义
            
        } else {
            
            button.hidden = YES;//防止重用出现了双重
        }
    }
}

//按钮点击事件
- (void)buttonAction:(UIButton *)button {
    
    if (self.buttonActionBlock) {
        
        self.buttonActionBlock(button.tag);
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //设置图片的尺寸和位置
    NSUInteger buttonCount = self.cityArray.count;
    
    for (int i = 0; i < buttonCount; i++) {
        
        if (i == 0) {
            
            UILabel *label_first = (UILabel *)self.contentView.subviews[0];
            
            label_first.frame = CGRectMake(10, 0, 100, 40);
            
        } else if (i == 1) {
            
            UILabel *label_second = (UILabel *)self.contentView.subviews[1];
            
            label_second.frame = CGRectMake(10,self.height - 40, 100, 40);
        }
        
        UIButton *button = self.contentView.subviews[i+2];//取出其中每一个imageView
        
        int col = i % 3;
        
        int row = i / 3;
        
        button.x  = col * (CityHeadViewLabelW + CityHeadViewLabelMargin) + 10;
        
        button.y  = row * (CityHeadViewLabelH + CityHeadViewLabelMargin) + 40;
        
        button.width =  CityHeadViewLabelW;
        
        button.height = CityHeadViewLabelH;
    }
}

+ (CGFloat)cityHeadViewHeightWithButtonCount:(NSUInteger)count {
    
    int maxCols = 3;
    
    NSUInteger rows = (count + maxCols - 1)/maxCols;
    
    CGFloat viewHeight  = rows * CityHeadViewLabelH + (rows - 1)*CityHeadViewLabelMargin;
    
    return viewHeight + 80;
}

@end
