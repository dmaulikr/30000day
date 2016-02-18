//
//  SignInViewController.h
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

@class CLLocationManager;

@interface SignInViewController : STBaseViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (weak, nonatomic) IBOutlet UITextField *userPwdTF;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIView *textSubView;

@property (weak, nonatomic) IBOutlet UIButton *lockPassWord;

@property (weak, nonatomic) IBOutlet UIButton *sina;

@property (weak, nonatomic) IBOutlet UIButton *qq;

@property (weak, nonatomic) IBOutlet UIButton *water;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

- (IBAction)regitView:(UIButton *)sender;

@end
