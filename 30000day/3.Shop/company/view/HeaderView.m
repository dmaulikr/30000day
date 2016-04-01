//
//  HeaderView.m
//  30000day
//
//  Created by wei on 16/4/1.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (void)btnOpenList:(UIButton *)sender {

    if (self.changeStateBlock) {
        
        self.changeStateBlock((UIButton *)sender);
        
    }
}

- (void)loadView {

    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 11, SCREEN_WIDTH, 21)];
    self.titleLabel.text = self.productTypeName;
    [self addSubview:self.titleLabel];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 18, 13, 7)];
    self.imageView.tag = 20000 + self.section;
    
    //更具当前是否展开设置图片
    NSString *string = [NSString stringWithFormat:@"%ld",(long)self.section];
    
    if ([self.selectedArr containsObject:string]) {
        
        self.imageView.image = [UIImage imageNamed:@"navigationbar_arrow_down"];
        
    }else{
        
        self.imageView.image = [UIImage imageNamed:@"navigationbar_arrow_up"];
    }
    
    [self addSubview:self.imageView];
    
    //添加一个button 用来监听点击分组，实现分组的展开关闭。
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    self.button.tag = 10000 + self.section;
    [self.button addTarget:self action:@selector(btnOpenList:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.button];

}

@end
