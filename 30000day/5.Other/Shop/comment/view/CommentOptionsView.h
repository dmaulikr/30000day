//
//  CommentOptionsView.h
//  30000day
//
//  Created by wei on 16/4/27.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentOptionsView : UIView

@property (nonatomic,copy) void (^(changeStateBlock))(UIButton *changeStatusButton);

@property (nonatomic,strong) UIButton *buttonAll;
@property (nonatomic,strong) UIButton *buttonPraise;
@property (nonatomic,strong) UIButton *buttonCommonly;
@property (nonatomic,strong) UIButton *buttonBad;

@end
