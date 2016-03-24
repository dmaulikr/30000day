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

@property (weak, nonatomic) IBOutlet AppointmentCollectionView *appointmentView;

@end
