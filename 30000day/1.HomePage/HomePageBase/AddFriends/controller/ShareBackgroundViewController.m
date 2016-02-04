//
//  ShareBackgroundViewController.m
//  30000day
//
//  Created by wei on 16/2/4.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "ShareBackgroundViewController.h"

@interface ShareBackgroundViewController ()
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

@implementation ShareBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButtonsLines];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view removeFromSuperview];
}

-(void)addButtonsLines{
    
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
    
    [self.cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)cancelClick{
    [self.view removeFromSuperview];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
