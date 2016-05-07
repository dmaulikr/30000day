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
        
        if ([Common readAppIntegerDataForKey:IS_BIG_PICTUREMODEL]) {
            
            [Common saveAppIntegerDataForKey:IS_BIG_PICTUREMODEL withObject:0];
            
        } else {
            
            [Common saveAppIntegerDataForKey:IS_BIG_PICTUREMODEL withObject:1];
        }
        
        self.changeStateBlock((UIButton *)sender);
        
    }
}

@end
