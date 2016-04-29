//
//  SMSVerificationViewController.h
//  30000天
//
//  Created by wei on 16/1/12.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSVerificationViewController : ShowBackItemViewController

@property (nonatomic,assign) NSInteger isSignOut;//1:表示是注册的，2:表示是寻找密码的, 3:验证号码是否存在

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *name;

@end
