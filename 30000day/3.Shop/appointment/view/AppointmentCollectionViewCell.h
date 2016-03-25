//
//  AppointmentCollectionViewCell.h
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,AppointmentColorType) {

    AppointmentColorCanUse = 0,//可用状态
    
    AppointmentColorMyUse,//我的预定
    
    AppointmentColorSellOut,//已经售完
    
    AppointmentColorNoneUse,//不可用
};

@interface AppointmentCollectionViewCell : UICollectionViewCell

@property (nonatomic,assign) NSInteger flag;//标志

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
