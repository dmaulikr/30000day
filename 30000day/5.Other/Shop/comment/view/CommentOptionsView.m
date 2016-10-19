//
//  CommentOptionsView.m
//  30000day
//
//  Created by wei on 16/4/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#define SELECTEDBTNCOLOR [UIColor colorWithRed:244.0/255.0 green:185.0/255.0 blue:121.0/255.0 alpha:1.0]
#define BTNCOLOR [UIColor colorWithRed:252.0/255.0 green:232.0/255.0 blue:209.0/255.0 alpha:1.0]

#import "CommentOptionsView.h"

@implementation CommentOptionsView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        //UIView *optionsView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        //optionsView.layer.borderWidth = 0.1;
        //optionsView.layer.borderColor = [UIColor colorWithRed:130.0/255.0 green:130.0/255.0 blue:130.0/255.0 alpha:1.0].CGColor
        
        UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *commonlyBtton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *badButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [allButton setBackgroundColor:SELECTEDBTNCOLOR];
        [praiseButton setBackgroundColor:BTNCOLOR];
        [commonlyBtton setBackgroundColor:BTNCOLOR];
        [badButton setBackgroundColor:BTNCOLOR];
        
        self.buttonAll = allButton;
        self.buttonPraise = praiseButton;
        self.buttonCommonly = commonlyBtton;
        self.buttonBad = badButton;
        
        CGFloat with = (SCREEN_WIDTH - 65 * 4 - 30) / 3;
        
        [allButton setFrame:CGRectMake(15, 10, 65, 24)];
        [praiseButton setFrame:CGRectMake(15 + 65 + with, 10, 65, 24)];
        [commonlyBtton setFrame:CGRectMake(15 + 65 * 2 + with * 2, 10, 65, 24)];
        [badButton setFrame:CGRectMake(15 + 65 * 3 + with * 3, 10, 65, 24)];
        
        [allButton setTitle:@"全部" forState:UIControlStateNormal];
        [allButton setSelected:YES];
        
        [praiseButton setTitle:@"好评" forState:UIControlStateNormal];
        [commonlyBtton setTitle:@"中评" forState:UIControlStateNormal];
        [badButton setTitle:@"差评" forState:UIControlStateNormal];
        
        allButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        praiseButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        commonlyBtton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        badButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        
        [allButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [praiseButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [commonlyBtton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        [badButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        [allButton setTag:0];
        [allButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [praiseButton setTag:1];
        [praiseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [commonlyBtton setTag:2];
        [commonlyBtton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [badButton setTag:3];
        [badButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:allButton];
        [self addSubview:praiseButton];
        [self addSubview:commonlyBtton];
        [self addSubview:badButton];

        
    }
    
    return self;

}

- (void)buttonClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:
        
                self.buttonAll.backgroundColor = SELECTEDBTNCOLOR;
                
                self.buttonPraise.backgroundColor = BTNCOLOR;

                self.buttonCommonly.backgroundColor = BTNCOLOR;

                self.buttonBad.backgroundColor = BTNCOLOR;

            break;
        case 1:

                self.buttonAll.backgroundColor = BTNCOLOR;
                
                self.buttonPraise.backgroundColor = SELECTEDBTNCOLOR;
                
                self.buttonCommonly.backgroundColor = BTNCOLOR;
                
                self.buttonBad.backgroundColor = BTNCOLOR;

            break;
        case 2:
                
                self.buttonAll.backgroundColor = BTNCOLOR;
                
                self.buttonPraise.backgroundColor = BTNCOLOR;
                
                self.buttonCommonly.backgroundColor = SELECTEDBTNCOLOR;
                
                self.buttonBad.backgroundColor = BTNCOLOR;
            
            break;
        case 3:
            
            self.buttonAll.backgroundColor = BTNCOLOR;
            
            self.buttonPraise.backgroundColor = BTNCOLOR;
            
            self.buttonCommonly.backgroundColor = BTNCOLOR;
            
            self.buttonBad.backgroundColor = SELECTEDBTNCOLOR;
            
            break;
            
        default:
            break;
    }
    

    
    if (self.changeStateBlock) {
        self.changeStateBlock(sender);
    }
    
}

@end
