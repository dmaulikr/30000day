//
//  LifeDescendFactorsTableViewCell.h
//  30000day
//
//  Created by wei on 16/5/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeDescendFactorsModel.h"

@interface LifeDescendFactorsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dataLable;

@property (weak, nonatomic) IBOutlet UILabel *dataTitleLable;

@property (nonatomic,strong) LifeDescendFactorsModel *lifeModel;

@end
