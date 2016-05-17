//
//  PromoteAgeTableViewCell.h
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoteAgeTableViewCell : UITableViewCell

//sportsRemindCellFirst
@property (weak, nonatomic) IBOutlet UILabel *sportTextLableFirst;

//sleepCellSecond
@property (weak, nonatomic) IBOutlet UILabel *sleepLableSecond;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;


//ageDeclineCellThird
@property (weak, nonatomic) IBOutlet UILabel *physicalExaminationLableThird;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel_third;

@end
