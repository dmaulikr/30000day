//
//  PersonHeadView.h
//  30000day
//
//  Created by GuoJia on 16/2/18.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *changeStatusButton;

@property (nonatomic,copy) void (^(changeStateBlock))(UIButton *changeStatusButton);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
