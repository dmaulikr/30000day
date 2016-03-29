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

- (void)drawRect:(CGRect)rect {
    
    [self configUI];
}

- (void)configUI {
    
    self.backgroundColor = [UIColor whiteColor];
    
    //设置两个按钮
    UIButton *firstButton = [self creatButtonWithTitle:@"全部商圈" frame:CGRectMake(0,0,self.width/2.0f,self.height - 4.0f)];
    
    [self addSubview:firstButton];
    
    UIButton *secondButton = [self creatButtonWithTitle:@"地铁" frame:CGRectMake(self.width/2.0f,0,self.width/2.0f,self.height - 4)];
    
    self.btn_1 = firstButton;
    
    [self addSubview:secondButton];
    
    //设置两个底部view
    UIView *firstView = [self createViewWithFrame:CGRectMake(0, self.height - 4.0f, self.width/2.0f, 3) backgroundColor:RGBACOLOR(0, 93, 193, 1)];
    
    [self addSubview:firstView];
    
    UIView *secondView = [self createViewWithFrame:CGRectMake(self.width/2.0f, self.height - 4.0f, self.width/2.0f, 3) backgroundColor:[UIColor whiteColor]];
    
    [self addSubview:secondView];
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
    
    [button setTitleColor:RGBACOLOR(0, 93, 193, 1) forState:UIControlStateNormal];

    return button;
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 86) {
        self.view_1.alpha = 1.0f;
        self.view_2.alpha = 0;
        [self.btn_2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btn_1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        if (self.ClickBlock) {
            self.ClickBlock(QGSwtichBtnFirstType);
        }
    }else if (btn.tag == 87){
        self.view_2.alpha = 1.0f;
        self.view_1.alpha = 0;
        [self.btn_2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.btn_1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (self.ClickBlock) {
            self.ClickBlock(QGSwtichBtnSecondType);
        }
    }
}

- (void)becomeFirst {
    
    self.view_1.alpha = 1.0f;
    self.view_2.alpha = 0;
    [self.btn_2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btn_1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}


@end
