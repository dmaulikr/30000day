//
//  ShopDetailHeadTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/11.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTImagePlayView.h"

@interface ShopDetailHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MTImagePlayView *rollImageView;

@property (weak, nonatomic) IBOutlet UILabel *storeLable;

@property (weak, nonatomic) IBOutlet UILabel *keywordLable;

@property (weak, nonatomic) IBOutlet UILabel *positionLable;

@property (weak, nonatomic) IBOutlet UILabel *businessHoursLable;
@property (weak, nonatomic) IBOutlet UILabel *businessHoursKeyLable;



@end
