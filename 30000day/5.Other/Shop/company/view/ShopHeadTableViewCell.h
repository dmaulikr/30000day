//
//  ShopHeadTableViewCell.h
//  30000day
//
//  Created by wei on 16/3/31.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *storeNameLable;

@property (weak, nonatomic) IBOutlet UILabel *keywordLable;

@property (weak, nonatomic) IBOutlet UILabel *businessHoursLable;

@end
