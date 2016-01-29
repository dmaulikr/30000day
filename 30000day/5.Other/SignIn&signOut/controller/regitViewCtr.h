//
//  regitViewCtr.h
//  30000天
//
//  Created by wei on 15/11/19.
//  Copyright © 2015年 wei. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface regitViewCtr : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTxt;

@property (weak, nonatomic) IBOutlet UITextField *userPwdTxt;

@property (weak, nonatomic) IBOutlet UITextField *ConfirmPasswordTxt;

@property (weak, nonatomic) IBOutlet UITextField *userNickNameTxt;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIView *passwordTextSubView;

@property (weak, nonatomic) IBOutlet UIView *niceNameTextSubView;

@property (nonatomic,strong) NSString* PhoneNumber;

@end
