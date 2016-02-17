
//
//  ShareAnimatonView.m
//  30000day
//
//  Created by GuoJia on 16/2/16.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShareAnimatonView.h"



@interface ShareAnimatonView () 

@property (weak, nonatomic) IBOutlet UIButton *WeChatFriendsBtn;

@property (weak, nonatomic) IBOutlet UIButton *WeChatBtn;

@property (weak, nonatomic) IBOutlet UIButton *QQspaceBtn;

@property (weak, nonatomic) IBOutlet UIButton *qqBtn;

@property (weak, nonatomic) IBOutlet UIButton *SinaBtn;

@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

@property (weak, nonatomic) IBOutlet UIButton *shortMessageBtn;

@property (weak, nonatomic) IBOutlet UIButton *LinkBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation ShareAnimatonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    
    self.WeChatFriendsBtn.layer.borderWidth=1.0;
    self.WeChatFriendsBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.WeChatFriendsBtn.layer.cornerRadius = 6;
    self.WeChatFriendsBtn.layer.masksToBounds = YES;
    
    self.WeChatBtn.layer.borderWidth=1.0;
    self.WeChatBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.WeChatBtn.layer.cornerRadius = 6.0;
    self.WeChatBtn.layer.masksToBounds = YES;
    
    self.QQspaceBtn.layer.borderWidth=1.0;
    self.QQspaceBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.QQspaceBtn.layer.cornerRadius = 6.0;
    self.QQspaceBtn.layer.masksToBounds = YES;
    
    self.qqBtn.layer.borderWidth=1.0;
    self.qqBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.qqBtn.layer.cornerRadius = 6.0;
    self.qqBtn.layer.masksToBounds = YES;
    
    self.SinaBtn.layer.borderWidth=1.0;
    self.SinaBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.SinaBtn.layer.cornerRadius = 6.0;
    self.SinaBtn.layer.masksToBounds = YES;
    
    self.emailBtn.layer.borderWidth=1.0;
    self.emailBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.emailBtn.layer.cornerRadius = 6.0;
    self.emailBtn.layer.masksToBounds = YES;
    
    self.shortMessageBtn.layer.borderWidth=1.0;
    self.shortMessageBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.shortMessageBtn.layer.cornerRadius = 6.0;
    self.shortMessageBtn.layer.masksToBounds = YES;
    
    self.LinkBtn.layer.borderWidth=1.0;
    self.LinkBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    self.LinkBtn.layer.cornerRadius = 6.0;
    self.LinkBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.borderWidth=1.0;
    self.cancelBtn.layer.borderColor=VIEWBORDERLINECOLOR.CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];

    [self addGestureRecognizer:tap];
    
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    CGPoint location = [tap locationInView:self];
    
    if (location.y < SCREEN_HEIGHT - SCREEN_WIDTH * 50 / 75) {//表示点击上面空白才会取消
        
        [ShareAnimatonView annimationRemoveFromSuperView:self];
        
    }
}

- (IBAction)buttonClickAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {
        
        
    } else if (button.tag == 2) {
        
        
        
    } else if (button.tag == 3) {
        
        
        
    } else if (button.tag == 4) {
     
        
        
    } else if (button.tag == 5) {
        
        
    } else if (button.tag == 6 ) {
        
        
    } else if (button.tag == 7) {
        
        
    } else if (button.tag == 8) {
        
        
    } else if (button.tag == 9) {//取消按钮
        
        
    }
    
    if (self.shareButtonBlock) {
        
        self.shareButtonBlock(button.tag,self);
    }
}

+ (void)annimationRemoveFromSuperView:(ShareAnimatonView *)animationview {
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        animationview.backgroudView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,SCREEN_WIDTH * 50/75);
        
    } completion:^(BOOL finished) {
        
        [animationview removeFromSuperview];
        
    }];
    
}

@end
