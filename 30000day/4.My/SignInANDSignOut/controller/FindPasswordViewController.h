//
//  findPwdViewCtr.h
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPasswordViewController : ShowBackItemViewController

@property (weak, nonatomic) UITextField *accountText;

@property (weak, nonatomic) IBOutlet UITextField *phoneText;

@property (weak, nonatomic) IBOutlet UITextField *ckText;

@property (weak, nonatomic) IBOutlet UIButton *ckbtn;

- (IBAction)ckbtnclick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@end
