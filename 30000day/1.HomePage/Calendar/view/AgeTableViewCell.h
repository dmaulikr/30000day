//
//  AgeTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/24.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *ageButton;

@property (nonatomic , copy) void(^(chooseAgeBlock))();

@end
