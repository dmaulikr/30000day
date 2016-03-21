//
//  QGRecordDetailHeadView.m
//  QGym
//
//  Created by win5 on 9/28/15.
//  Copyright (c) 2015 win5. All rights reserved.
//

#import "QGRecordDetailSwitchHeadView.h"

@implementation QGRecordDetailSwitchHeadView

- (void)drawRect:(CGRect)rect {
   
    
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

@end
