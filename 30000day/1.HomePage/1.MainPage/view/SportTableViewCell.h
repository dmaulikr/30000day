//
//  SportTableViewCell.h
//  30000day
//
//  Created by WeiGe on 16/7/7.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportInformationModel.h"

@interface SportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *distanceLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UILabel *stepNumberLable;

@property (weak, nonatomic) IBOutlet UILabel *calorieLable;

@property (nonatomic,strong) SportInformationModel *sportInformationModel;


@end
