//
//  updatePwdViewCtr.h
//  30000天
//
//  Created by 30000天_001 on 14-8-21.
//  Copyright (c) 2014年 30000天_001. All rights reserved.
//

#import "NewPasswordViewController.h"

@interface NewPasswordViewController : ShowBackItemViewController

@property (nonatomic,copy) NSString *mobileToken;

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,assign) BOOL type;//YES表示密保验证 NO表示手机验证

@end
