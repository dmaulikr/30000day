//
//  AppointmentTableViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentCollectionView.h"

@interface AppointmentTableViewCell : UITableViewCell

//根据时间数组算出cell应该有的高度
+ (CGFloat)cellHeightWithTimeArray:(NSMutableArray *)timeArray;


@end
