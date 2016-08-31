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

typedef NS_ENUM(NSInteger,ShowLabelType) {
    
    ShowLabelPastAgeAndAllAgeType = 0,//过去天龄+总天龄
    ShowLabelSurplusAgeAndAllAgeType,//剩余天龄+总天龄
    ShowLabelPastAgeAndSurplusAgeType,//过去天龄+剩余天龄
};

@interface ActivityIndicatorTableViewCell : UITableViewCell

- (void)reloadData:(float)totalLifeDayNumber birthDayString:(NSString *)birthdayString showLabelTye:(ShowLabelType)type;

@property (nonatomic,assign) ShowLabelType type;

@property (weak, nonatomic) IBOutlet UILabel *label_1;
@property (weak, nonatomic) IBOutlet UILabel *label_2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
