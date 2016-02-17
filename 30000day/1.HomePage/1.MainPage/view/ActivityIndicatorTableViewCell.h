//
//  ActivityIndicatorTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/2/17.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"

@interface ActivityIndicatorTableViewCell : UITableViewCell

@property (weak , nonatomic) IBOutlet MDRadialProgressView *indicatiorView;

- (void)reloadData:(float)totalLifeDayNumber;

@property (weak, nonatomic) IBOutlet UILabel *label_1;

@property (weak, nonatomic) IBOutlet UILabel *label_2;

@end
