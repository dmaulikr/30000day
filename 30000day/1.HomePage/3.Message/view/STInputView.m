//
//  STInputView.m
//  30000day
//
//  Created by GuoJia on 16/3/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STInputView.h"

@implementation STInputView

+ (instancetype)inputView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"STInputView" owner:nil options:nil] lastObject];
}

- (IBAction)buttonClickAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {
        
        if (self.buttonClickBlock) {
            
            self.buttonClickBlock(STShowInputViewPhotosAlbum);
        }
        
    } else if (button.tag == 2) {
        
        if (self.buttonClickBlock) {
            
            self.buttonClickBlock(STInputViewTypeCamera);
        }
        
    } else if (button.tag == 3) {
        
        if (self.buttonClickBlock) {
            
            self.buttonClickBlock(STInputViewTypeVideo);
        }
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
