//
//  InformationDetailDownView.m
//  30000day
//
//  Created by wei on 16/4/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "InformationDetailDownView.h"

@implementation InformationDetailDownView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)shareButton:(UIButton *)sender {
    
    if (self.shareButtonBlock) {
        
        self.shareButtonBlock((UIButton *)sender);
        
    }
    
}

- (IBAction)zanButton:(UIButton *)sender {
    
    if (self.zanButtonBlock) {
        
        self.zanButtonBlock((UIButton *)sender);
        
    }
    
}

- (IBAction)commentButton:(UIButton *)sender {

    if (self.commentButtonBlock) {
        
        self.commentButtonBlock();
        
    }
    
}




@end
