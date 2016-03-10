//
//  PersonHeadView.m
//  30000day
//
//  Created by GuoJia on 16/2/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "PersonHeadView.h"

@implementation PersonHeadView

- (void)drawRect:(CGRect)rect {
    
    self.changeStatusButton.layer.cornerRadius = 3;
    
    self.changeStatusButton.layer.masksToBounds = YES;
    
}

- (IBAction)buttonClick:(id)sender {
    
    if (self.changeStateBlock) {
        
        self.changeStateBlock((UIButton *)sender);
        
    }
}

@end
