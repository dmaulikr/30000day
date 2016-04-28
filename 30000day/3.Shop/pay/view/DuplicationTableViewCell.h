//
//  DuplicationTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/4/28.
//  Copyright © 2016年 GuoJia. All rights reserved.
//  该cell被多处使用

#import <UIKit/UIKit.h>
#import "AppointmentModel.h"

@interface DuplicationTableViewCell : UITableViewCell

//*******第一个xib的连线
@property (weak, nonatomic) IBOutlet UILabel *titleLabel_first;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel_first;
- (void)configCellWithActivityModel:(ActivityModel *)model;//配置价格
- (void)configCellWithAppointmentTimeModel:(AppointmentTimeModel *)timeModel;//配置预约场次


@end
