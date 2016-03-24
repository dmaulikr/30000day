//
//  AppointmentTableViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/23.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentTableViewCell.h"

@interface AppointmentTableViewCell () <AppointmentCollectionViewDelegate>

@end

@implementation AppointmentTableViewCell

- (void)awakeFromNib {
    
    self.appointmentView.dataArray = [NSMutableArray arrayWithArray:@[@"1号场",@"2号场",@"3号场",@"4号场",@"5号场",@"6号场",@"7号场",@"8号场"]];
    
    self.appointmentView.time_dataArray = [NSMutableArray arrayWithArray:@[@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00"]];
    
    self.appointmentView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma ---
#pragma mark --- AppointmentCollectionViewDelegate

- (void)appointmentCollectionView:(AppointmentCollectionView *)appointmentCollectionView didSelectionAppointmentIndexPath:(NSIndexPath *)indexPath {
    
    
    
}


@end
