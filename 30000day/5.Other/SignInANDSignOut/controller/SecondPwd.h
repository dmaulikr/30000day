//
//  SecondPwd.h
//  30000天
//
//  Created by wei on 15/9/16.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "updatePwdViewCtr.h"


@interface SecondPwd : STBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *PBbtn1;//问题1按钮

@property (weak, nonatomic) IBOutlet UIButton *PBbtn2;

@property (weak, nonatomic) IBOutlet UIButton *PBbtn3;

@property (weak, nonatomic) IBOutlet UITextField *ASText1;//答案1

@property (weak, nonatomic) IBOutlet UITextField *ASText2;

@property (weak, nonatomic) IBOutlet UITextField *ASText3;

- (IBAction)submitbtn:(UIButton *)sender;

@end
