//
//  CalendarScrollView.m
//  30000day
//
//  Created by GuoJia on 16/3/29.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "CalendarScrollView.h"

@implementation CalendarScrollView


- (void)drawRect:(CGRect)rect {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *label_1 = [self creatLabelWithFrame:CGRectMake(15, 5, 250, 25) title:@"从您出生到这天过去了16814天!"];
    
    UILabel *label_2 = [self creatLabelWithFrame:CGRectMake(15, 35, 250, 25) title:@"从今天到所选岁数还有16814天!"];
    
    [self addSubview:label_1];
    
    [self addSubview:label_2];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,60, self.width,self.height - 60)];
    
    scrollView.backgroundColor = [UIColor yellowColor];
    
    [self addSubview:scrollView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0.5f)];
    
    view.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    
    [self addSubview:view];
    
    UIButton *button = [self creatButtonWithTitle:@"80岁" frame:CGRectMake(SCREEN_WIDTH - 30 - 30, 35, 60, 25)];
    
    [self addSubview:button];
}

- (UIButton *)creatButtonWithTitle:(NSString *)title frame:(CGRect)frame {
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:RGBACOLOR(0, 93, 193, 1) forState:UIControlStateNormal];
    
    return button;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (UILabel *)creatLabelWithFrame:(CGRect )frame title:(NSString *)text {
    
    UILabel *label_1 = [[UILabel alloc] initWithFrame:frame];
    
    label_1.text = text;
    
    label_1.font = [UIFont systemFontOfSize:15.0f];
    
    return label_1;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    if (self.moveBlock) {
        
        self.moveBlock();
    }
}

@end
