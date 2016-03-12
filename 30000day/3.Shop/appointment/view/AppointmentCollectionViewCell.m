//
//  AppointmentCollectionViewCell.m
//  30000day
//
//  Created by GuoJia on 16/3/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "AppointmentCollectionViewCell.h"

@implementation AppointmentCollectionViewCell

- (void)awakeFromNib {
    
    self.layer.borderColor = RGBACOLOR(200, 200, 200, 1).CGColor;
    
    self.layer.borderWidth = 0.5f;
    
}

@end
