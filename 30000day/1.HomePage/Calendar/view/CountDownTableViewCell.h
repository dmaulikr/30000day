//
//  CountDownTableViewCell.h
//  30000day
//
//  Created by WeiGe on 16/6/20.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countDownLable;

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (nonatomic,copy) void(^(chooseAgeBlock))();

@end
