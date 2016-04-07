//
//  InformationTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *InformationDetailTitle;

@property (weak, nonatomic) IBOutlet UIButton *InformationDetailAuthor;

@property (weak, nonatomic) IBOutlet UILabel *InformationDetailTime;

@property (weak, nonatomic) IBOutlet UILabel *InformationDetailContent;

@end
