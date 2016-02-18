//
//  regitViewCtr.h
//  30000天
//
//  Created by wei on 15/11/19.
//  Copyright © 2015年 wei. All rights reserved.
//

@interface SignOutViewController : ShowBackItemViewController < UITextFieldDelegate,UITextFieldDelegate >

@property (nonatomic,strong) NSString *PhoneNumber;

@property (nonatomic,copy) NSString *mobileToken;//校验后获取的验证码

@end
