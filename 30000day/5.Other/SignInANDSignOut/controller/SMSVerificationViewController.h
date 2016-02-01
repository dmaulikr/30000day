//
//  SMSVerificationViewController.h
//  30000天
//
//  Created by wei on 16/1/12.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSVerificationViewController : STBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *sms;

@property (weak, nonatomic) IBOutlet UIButton *smsBtn;

- (IBAction)nextBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *textSubView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end
