//
//  myViewCell.h
//  30000天
//
//  Created by wei on 16/1/19.
//  Copyright © 2016年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *seperatorLineView;//分割线view

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seprratorLineViewLeadingConstrain;//分割线的左约束

@end
