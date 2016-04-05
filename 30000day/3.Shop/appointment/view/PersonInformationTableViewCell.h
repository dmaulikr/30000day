//
//  PersonInformationTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentModel.h"

@interface PersonInformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *contactTextField;//联系人label

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;//手机号码label

@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;//备注的textView




@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;//总价label

//根据AppointmentTimeModel配置总计
- (void)configTotalPriceWith:(NSMutableArray *)timeModelArray;



//标题label
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;

//内容label
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)configOrderWithAppointmentTimeModel:(AppointmentTimeModel *)timeModel;

@end
