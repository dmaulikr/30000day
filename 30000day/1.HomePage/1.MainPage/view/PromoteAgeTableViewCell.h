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

//ageDeclineCellThird
@property (weak, nonatomic) IBOutlet UILabel *physicalExaminationLableThird;



+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;

- (void)configTempCellWith:(NSIndexPath *)indexPath;

@end
