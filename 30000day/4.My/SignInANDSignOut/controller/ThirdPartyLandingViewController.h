//
//  ThirdPartyLandingViewController.h
//  30000day
//
//  Created by wei on 16/5/3.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThirdPartyLandingViewController : ShowBackItemViewController

@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *uid;

@property (nonatomic,assign) BOOL isConceal;//是否隐藏 下面显示头像和昵称的控件 yes:表示是从设置等截面进来的 NO:表示从登录截面进来的
//@property (nonatomic,copy) BOOL is

@end
