//
//  FactorVerificationView.h
//  30000day
//
//  Created by wei on 16/5/21.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FactorVerificationView : UIView

@property (nonatomic,copy) void (^(buttonBlock))(UIButton *);

@property (weak, nonatomic) IBOutlet UITextField *passWordTextFiled;


@end
