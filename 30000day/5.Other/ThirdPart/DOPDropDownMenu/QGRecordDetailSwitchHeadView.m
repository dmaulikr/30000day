//
//  QGRecordDetailHeadView.m
//  QGym
//
//  Created by win5 on 9/28/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import "QGRecordDetailSwitchHeadView.h"
#import "UIView+Extension.h"

@implementation QGRecordDetailSwitchHeadView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (!self.btn_1) {
        
        //设置两个按钮
        UIButton *firstButton = [self creatButtonWithTitle:@"全部商圈" frame:CGRectMake(0,0,self.width/2.0f,self.height - 4.0f)];
        
        firstButton.tag = 86;
        
        [firstButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        self.btn_1 = firstButton;
        
        [firstButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:firstButton];
    }
    
    if (!self.btn_2) {
        
        UIButton *secondButton = [self creatButtonWithTitle:@"地铁" frame:CGRectMake(self.width/2.0f,0,self.width/2.0f,self.height - 4)];
        
        [secondButton setTitleColor:RGBACOLOR(200, 200, 200, 1) forState:UIControlStateNormal];
        
        [secondButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        secondButton.tag = 87;
        
        self.btn_2 = secondButton;
        
        [self addSubview:secondButton];
    }
    
    if (!self.view_1) {
        
        //设置两个底部view
        UIView *firstView = [self createViewWithFrame:CGRectMake(0.7f, self.height - 3.0f, self.width/2.0f - 1.4f, 2.0f) backgroundColor:LOWBLUECOLOR];
        
        _view_1 = firstView;
        
        firstView.hidden = NO;
        
        [self addSubview:firstView];
    }
    
    if (!self.view_2) {
        
        UIView *secondView = [self createViewWithFrame:CGRectMake(self.width/2.0f + 1.4f, self.height - 3.0f, self.width/2.0f - 2.10f, 2.0f) backgroundColor:LOWBLUECOLOR];
        
        secondView.hidden = YES;
        
        _view_2 = secondView;
        
        [self addSubview:secondView];
        
    }
    //背景图片
    UIView *backgroudView = [self createViewWithFrame:CGRectMake(0.0f, self.height - 1.0f, self.width, 0.3f) backgroundColor:RGBACOLOR(230, 230, 230, 1)];

    [self addSubview:backgroudView];
    
    //设置
    UIView *backgroudview_line = [self createViewWithFrame:CGRectMake(self.width/2.0f, 10.0f, 1.0f, self.height - 20.0f) backgroundColor:RGBACOLOR(220, 220, 220, 1)];
    
    [self addSubview:backgroudview_line];
}

- (UIView *)createViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color {
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    view.backgroundColor = color;
    
    return view;
}

- (UIButton *)creatButtonWithTitle:(NSString *)title frame:(CGRect)frame {
    
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = frame;
    
    [button setTitle:title forState:UIControlStateNormal];

    return button;
}

- (void)btnClick:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 86) {
        
        _view_1.hidden = NO;
        
        _view_2.hidden = YES;
        
        [_btn_2 setTitleColor:RGBACOLOR(200,200 , 200, 1) forState:UIControlStateNormal];
        
        [_btn_1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        if (self.ClickBlock) {
            
            self.ClickBlock(QGSwtichBtnFirstType);
        }
        
    } else if (btn.tag == 87){
        
         _view_1.hidden = YES;
        
         _view_2.hidden = NO;
        
        [_btn_2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [_btn_1 setTitleColor:RGBACOLOR(200,200 , 200, 1) forState:UIControlStateNormal];
        
        if (self.ClickBlock) {
            
            self.ClickBlock(QGSwtichBtnSecondType);
        }
    }
}

- (void)becomeFirst {
    
    self.view_1.hidden = NO;
    
    self.view_2.hidden = YES;
    
    [self.btn_2 setTitleColor:RGBACOLOR(200,200 , 200, 1) forState:UIControlStateNormal];
    
    [self.btn_1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

@end
