//
//  PromoteAgeTableViewCell.h
//  30000day
//
//  Created by wei on 16/5/10.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoteAgeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sportTextLable;

@property (weak, nonatomic) IBOutlet UILabel *sleepLable;

@property (weak, nonatomic) IBOutlet UILabel *physicalExaminationLable;






+ (instancetype)tempTableViewCellWith:(UITableView *)tableView
                            indexPath:(NSIndexPath *)indexPath;

- (void)configTempCellWith:(NSIndexPath *)indexPath;

@end
