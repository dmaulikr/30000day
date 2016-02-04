//
//  HealthyTableViewCell.h
//  Healthy
//
//  Created by wei on 15/10/14.
//  Copyright (c) 2015年 wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *setButton;

@property (nonatomic,strong) NSIndexPath *cellIndexPath;

@property (nonatomic ,copy) void (^(setButtonClick))(NSIndexPath *);

@end
