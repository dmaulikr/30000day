//
//  SportHeadTableViewCell.h
//  30000day
//
//  Created by WeiGe on 16/7/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SportHeadTableViewCell : UITableViewCell

@property (strong, nonatomic) UIButton *beginButton;

@property (strong, nonatomic) UILabel *beginLable;

@property (strong, nonatomic) UIButton *editorButton;

@property (strong, nonatomic) UILabel *editorLable;

@property (nonatomic,copy) void (^buttonBlock)(UIButton *);

@end
